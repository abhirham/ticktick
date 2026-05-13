import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../shared/presentation/flow_action_button.dart';
import '../../../shared/presentation/flow_bottom_sheet.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';
import '../application/list_group_providers.dart';
import '../data/list_group_repository.dart';

const _listColorOptions = [
  '#4774FA',
  '#13C8A0',
  '#F7B43B',
  '#DA3E38',
  '#8D8D8D',
  '#F1F1F1',
];

const _listIconOptions = [
  _ListIconOption(null, Icons.list_alt_rounded, 'Default'),
  _ListIconOption('inbox', Icons.inbox_outlined, 'Inbox'),
  _ListIconOption('menu', Icons.menu_rounded, 'Lines'),
  _ListIconOption('flag', Icons.flag_outlined, 'Flag'),
  _ListIconOption('bank', Icons.account_balance_outlined, 'Bank'),
  _ListIconOption('spark', Icons.auto_awesome_outlined, 'Spark'),
];

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  String? _selectedListId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final openCount = ref.watch(openTaskCountProvider).valueOrNull ?? 0;
    final completedCount =
        ref.watch(completedTaskCountProvider).valueOrNull ?? 0;
    final trashCount = ref.watch(trashTaskCountProvider).valueOrNull ?? 0;
    final summariesAsync = ref.watch(listSummariesProvider);
    final summaries = summariesAsync.valueOrNull ?? const <TaskListSummary>[];
    final routeListId = _routeListId(context);
    final selectedSummary = _selectedSummary(
      summaries,
      _selectedListId ?? routeListId,
    );

    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'Lists',
            leading: FlowIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open navigation',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            actions: [
              FlowIconButton(
                icon: Icons.add_box_outlined,
                tooltip: 'Add list',
                onPressed: () => _showListSheet(),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _ListPanel(
                  title: 'Smart Views',
                  children: [
                    _SimpleNavRow(
                      icon: Icons.checklist_rounded,
                      label: 'All Tasks',
                      count: openCount,
                      onTap: () => context.go('/all'),
                    ),
                    _SimpleNavRow(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Completed',
                      count: completedCount,
                      onTap: () => context.go('/completed'),
                    ),
                    _SimpleNavRow(
                      icon: Icons.delete_outline_rounded,
                      label: 'Trash',
                      count: trashCount,
                      onTap: () => context.go('/trash'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                summariesAsync.when(
                  data: (items) => _ListPanel(
                    title: 'Lists',
                    trailing: _PanelIconAction(
                      icon: Icons.add_rounded,
                      tooltip: 'Add list',
                      onPressed: () => _showListSheet(),
                    ),
                    children: [
                      for (var index = 0; index < items.length; index += 1)
                        _ManagedListRow(
                          summary: items[index],
                          active:
                              selectedSummary?.list.id == items[index].list.id,
                          canMoveUp: index > 0,
                          canMoveDown: index < items.length - 1,
                          onTap: () => setState(() {
                            _selectedListId = items[index].list.id;
                          }),
                          onMoveUp: () => _moveList(items, index, -1),
                          onMoveDown: () => _moveList(items, index, 1),
                          onEdit: () => _showListSheet(list: items[index].list),
                        ),
                    ],
                  ),
                  loading: () => _ListPanel(
                    title: 'Lists',
                    children: [_PanelMessage(text: 'Loading lists...')],
                  ),
                  error: (error, _) => _ListPanel(
                    title: 'Lists',
                    children: [_PanelMessage(text: '$error', danger: true)],
                  ),
                ),
                if (selectedSummary != null) ...[
                  const SizedBox(height: 16),
                  _SelectedListGroupsPanel(
                    summary: selectedSummary,
                    onAddGroup: () =>
                        _showGroupSheet(list: selectedSummary.list),
                    onEditGroup: (section, sections) => _showGroupSheet(
                      list: selectedSummary.list,
                      section: section,
                      sections: sections,
                    ),
                    onMoveGroup: _moveGroup,
                    onMoveTask: (task, sections) => _showMoveTaskSheet(
                      task: task,
                      list: selectedSummary.list,
                      sections: sections,
                    ),
                  ),
                ],
                if (summaries.isEmpty && summariesAsync.hasValue) ...[
                  const SizedBox(height: 16),
                  _ListPanel(
                    title: 'Groups',
                    children: [
                      _PanelMessage(text: 'Create a list to add groups.'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  TaskListSummary? _selectedSummary(
    List<TaskListSummary> summaries,
    String? selectedListId,
  ) {
    if (summaries.isEmpty) {
      return null;
    }
    for (final summary in summaries) {
      if (summary.list.id == selectedListId) {
        return summary;
      }
    }
    return summaries.first;
  }

  String? _routeListId(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.queryParameters['list'];
    } catch (_) {
      return null;
    }
  }

  Future<void> _moveList(
    List<TaskListSummary> summaries,
    int index,
    int direction,
  ) async {
    final targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= summaries.length) {
      return;
    }
    final reordered = [...summaries];
    final moved = reordered.removeAt(index);
    reordered.insert(targetIndex, moved);
    await ref.read(listGroupRepositoryProvider).reorderLists([
      for (final summary in reordered) summary.list.id,
    ]);
  }

  Future<void> _moveGroup(
    TaskList list,
    List<ListTaskSection> sections,
    String groupId,
    int direction,
  ) async {
    final groups = [
      for (final section in sections)
        if (section.groupId != null) section,
    ];
    final index = groups.indexWhere((section) => section.groupId == groupId);
    final targetIndex = index + direction;
    if (index < 0 || targetIndex < 0 || targetIndex >= groups.length) {
      return;
    }
    final reordered = [...groups];
    final moved = reordered.removeAt(index);
    reordered.insert(targetIndex, moved);
    await ref
        .read(listGroupRepositoryProvider)
        .reorderGroups(
          listId: list.id,
          orderedIds: [for (final section in reordered) section.groupId!],
        );
  }

  Future<void> _showListSheet({TaskList? list}) async {
    await showFlowBottomSheet<void>(
      context: context,
      builder: (context) => _ListEditorSheet(list: list),
    );
  }

  Future<void> _showGroupSheet({
    required TaskList list,
    ListTaskSection? section,
    List<ListTaskSection> sections = const [],
  }) async {
    if (section?.isUngrouped ?? false) {
      return;
    }
    await showFlowBottomSheet<void>(
      context: context,
      builder: (context) =>
          _GroupEditorSheet(list: list, section: section, sections: sections),
    );
  }

  Future<void> _showMoveTaskSheet({
    required TaskItem task,
    required TaskList list,
    required List<ListTaskSection> sections,
  }) async {
    await showFlowBottomSheet<void>(
      context: context,
      builder: (context) =>
          _MoveTaskSheet(task: task, list: list, sections: sections),
    );
  }
}

class _SelectedListGroupsPanel extends ConsumerStatefulWidget {
  const _SelectedListGroupsPanel({
    required this.summary,
    required this.onAddGroup,
    required this.onEditGroup,
    required this.onMoveGroup,
    required this.onMoveTask,
  });

  final TaskListSummary summary;
  final VoidCallback onAddGroup;
  final void Function(ListTaskSection section, List<ListTaskSection> sections)
  onEditGroup;
  final Future<void> Function(
    TaskList list,
    List<ListTaskSection> sections,
    String groupId,
    int direction,
  )
  onMoveGroup;
  final void Function(TaskItem task, List<ListTaskSection> sections) onMoveTask;

  @override
  ConsumerState<_SelectedListGroupsPanel> createState() =>
      _SelectedListGroupsPanelState();
}

class _SelectedListGroupsPanelState
    extends ConsumerState<_SelectedListGroupsPanel> {
  ListTaskGroupingMode _groupingMode = ListTaskGroupingMode.manualGroups;
  ListTaskSortMode _sortMode = ListTaskSortMode.manual;

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(
      listTaskSectionsProvider(
        ListTaskSectionsRequest(
          listId: widget.summary.list.id,
          groupingMode: _groupingMode,
          sortMode: _sortMode,
        ),
      ),
    );
    final color = _colorFromHex(
      widget.summary.list.color,
      context.colors.primary,
    );
    return _ListPanel(
      title: widget.summary.list.name,
      subtitle:
          '${widget.summary.openTaskCount} open - ${_groupingModeLabel(_groupingMode)} - ${_sortModeLabel(_sortMode)}',
      leading: Icon(
        _iconDataForList(widget.summary.list.icon),
        color: color,
        size: 20,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TinyIconButton(
            icon: Icons.tune_rounded,
            tooltip: 'Group and sort',
            onPressed: _showGroupSortSheet,
          ),
          _TinyIconButton(
            icon: Icons.create_new_folder_outlined,
            tooltip: 'Add group',
            onPressed: _groupingMode == ListTaskGroupingMode.manualGroups
                ? widget.onAddGroup
                : null,
          ),
        ],
      ),
      children: [
        sectionsAsync.when(
          data: (sections) {
            if (sections.isEmpty) {
              return _PanelMessage(text: 'Ungrouped is ready for tasks.');
            }
            final groupSections = [
              for (final section in sections)
                if (section.groupId != null) section,
            ];
            return Column(
              children: [
                for (final section in sections)
                  _GroupSectionView(
                    section: section,
                    allSections: sections,
                    groupIndex: groupSections.indexWhere(
                      (item) => item.groupId == section.groupId,
                    ),
                    groupCount: groupSections.length,
                    onEdit: () => widget.onEditGroup(section, sections),
                    onMoveUp: section.groupId == null
                        ? null
                        : () => widget.onMoveGroup(
                            widget.summary.list,
                            sections,
                            section.groupId!,
                            -1,
                          ),
                    onMoveDown: section.groupId == null
                        ? null
                        : () => widget.onMoveGroup(
                            widget.summary.list,
                            sections,
                            section.groupId!,
                            1,
                          ),
                    onMoveTask: widget.onMoveTask,
                  ),
              ],
            );
          },
          loading: () => _PanelMessage(text: 'Loading groups...'),
          error: (error, _) => _PanelMessage(text: '$error', danger: true),
        ),
      ],
    );
  }

  Future<void> _showGroupSortSheet() async {
    final selection = await showFlowBottomSheet<_GroupSortSelection>(
      context: context,
      builder: (context) =>
          _GroupSortSheet(groupingMode: _groupingMode, sortMode: _sortMode),
    );
    if (selection == null || !mounted) {
      return;
    }
    setState(() {
      _groupingMode = selection.groupingMode;
      _sortMode = selection.sortMode;
    });
  }
}

class _GroupSectionView extends ConsumerWidget {
  const _GroupSectionView({
    required this.section,
    required this.allSections,
    required this.groupIndex,
    required this.groupCount,
    required this.onEdit,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onMoveTask,
  });

  final ListTaskSection section;
  final List<ListTaskSection> allSections;
  final int groupIndex;
  final int groupCount;
  final VoidCallback onEdit;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final void Function(TaskItem task, List<ListTaskSection> sections) onMoveTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final canMoveUp = groupIndex > 0;
    final canMoveDown = groupIndex >= 0 && groupIndex < groupCount - 1;
    final canManageGroup = section.groupId != null;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                if (section.groupId == null)
                  Icon(Icons.inbox_outlined, color: colors.iconMuted, size: 20)
                else
                  _TinyIconButton(
                    icon: section.isCollapsed
                        ? Icons.keyboard_arrow_right_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    tooltip: section.isCollapsed
                        ? 'Expand group'
                        : 'Collapse group',
                    onPressed: () => ref
                        .read(listGroupRepositoryProvider)
                        .setGroupCollapsed(
                          id: section.groupId!,
                          isCollapsed: !section.isCollapsed,
                        ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: section.isUngrouped
                          ? colors.textMuted
                          : colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
                Text(
                  '${section.tasks.length}',
                  style: TextStyle(color: colors.textMuted, fontSize: 14.5),
                ),
                const SizedBox(width: 4),
                if (canManageGroup) ...[
                  _TinyIconButton(
                    icon: Icons.keyboard_arrow_up_rounded,
                    tooltip: 'Move group up',
                    onPressed: canMoveUp ? onMoveUp : null,
                  ),
                  _TinyIconButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    tooltip: 'Move group down',
                    onPressed: canMoveDown ? onMoveDown : null,
                  ),
                  _TinyIconButton(
                    icon: Icons.more_horiz_rounded,
                    tooltip: 'Edit group',
                    onPressed: onEdit,
                  ),
                ],
              ],
            ),
          ),
          if (!section.isCollapsed) ...[
            if (section.tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    section.isUngrouped
                        ? 'Ungrouped stays available for this list.'
                        : 'No tasks in this group.',
                    style: TextStyle(color: colors.textMuted, fontSize: 14.5),
                  ),
                ),
              )
            else
              for (final task in section.tasks)
                _GroupTaskRow(
                  task: task,
                  onOpen: () => context.go('/task/${task.id}'),
                  onComplete: () =>
                      ref.read(taskRepositoryProvider).completeTask(task.id),
                  onMove: () => onMoveTask(task, allSections),
                ),
          ],
        ],
      ),
    );
  }
}

class _GroupTaskRow extends StatelessWidget {
  const _GroupTaskRow({
    required this.task,
    required this.onOpen,
    required this.onComplete,
    required this.onMove,
  });

  final TaskItem task;
  final VoidCallback onOpen;
  final VoidCallback onComplete;
  final VoidCallback onMove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onOpen,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 42),
        child: Row(
          children: [
            TaskCheckBox(checked: false, onTap: onComplete),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
            _TinyIconButton(
              icon: Icons.drive_file_move_outline,
              tooltip: 'Move task',
              onPressed: onMove,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListPanel extends StatelessWidget {
  const _ListPanel({
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 13.5,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _SimpleNavRow extends StatelessWidget {
  const _SimpleNavRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _BaseRow(
      icon: Icon(icon, color: context.colors.icon, size: 22),
      label: label,
      count: count,
      onTap: onTap,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.colors.textMuted,
        size: 22,
      ),
    );
  }
}

class _ManagedListRow extends StatelessWidget {
  const _ManagedListRow({
    required this.summary,
    required this.active,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onTap,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onEdit,
  });

  final TaskListSummary summary;
  final bool active;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onTap;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final listColor = _colorFromHex(summary.list.color, colors.primary);
    return _BaseRow(
      icon: Icon(
        _iconDataForList(summary.list.icon),
        color: listColor,
        size: 22,
      ),
      label: summary.list.name,
      count: summary.openTaskCount,
      active: active,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TinyIconButton(
            icon: Icons.keyboard_arrow_up_rounded,
            tooltip: 'Move list up',
            onPressed: canMoveUp ? onMoveUp : null,
          ),
          _TinyIconButton(
            icon: Icons.keyboard_arrow_down_rounded,
            tooltip: 'Move list down',
            onPressed: canMoveDown ? onMoveDown : null,
          ),
          _TinyIconButton(
            icon: Icons.more_horiz_rounded,
            tooltip: 'Edit list',
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class _BaseRow extends StatelessWidget {
  const _BaseRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
    required this.trailing,
    this.active = false,
  });

  final Widget icon;
  final String label;
  final int count;
  final VoidCallback onTap;
  final Widget trailing;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
          decoration: BoxDecoration(
            color: active ? colors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: icon)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: TextStyle(color: colors.textMuted, fontSize: 14.5),
              ),
              const SizedBox(width: 6),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupSortSelection {
  const _GroupSortSelection({
    required this.groupingMode,
    required this.sortMode,
  });

  final ListTaskGroupingMode groupingMode;
  final ListTaskSortMode sortMode;
}

class _GroupSortSheet extends StatefulWidget {
  const _GroupSortSheet({required this.groupingMode, required this.sortMode});

  final ListTaskGroupingMode groupingMode;
  final ListTaskSortMode sortMode;

  @override
  State<_GroupSortSheet> createState() => _GroupSortSheetState();
}

class _GroupSortSheetState extends State<_GroupSortSheet> {
  late ListTaskGroupingMode _groupingMode;
  late ListTaskSortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _groupingMode = widget.groupingMode;
    _sortMode = widget.sortMode;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            title: 'Group & Sort',
            subtitle: 'Choose this list view.',
          ),
          const SizedBox(height: 18),
          Text(
            'Group by',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (final mode in ListTaskGroupingMode.values)
            _ModeChoiceRow(
              icon: _groupingModeIcon(mode),
              label: _groupingModeLabel(mode),
              selected: mode == _groupingMode,
              onTap: () => setState(() => _groupingMode = mode),
            ),
          const SizedBox(height: 16),
          Text(
            'Sort by',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (final mode in ListTaskSortMode.values)
            _ModeChoiceRow(
              icon: _sortModeIcon(mode),
              label: _sortModeLabel(mode),
              selected: mode == _sortMode,
              onTap: () => setState(() => _sortMode = mode),
            ),
          const SizedBox(height: 22),
          FlowActionButton(
            primary: true,
            icon: Icons.check_rounded,
            label: 'Apply',
            onPressed: () => Navigator.of(context).pop(
              _GroupSortSelection(
                groupingMode: _groupingMode,
                sortMode: _sortMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChoiceRow extends StatelessWidget {
  const _ModeChoiceRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.primary : colors.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ListEditorSheet extends ConsumerStatefulWidget {
  const _ListEditorSheet({this.list});

  final TaskList? list;

  @override
  ConsumerState<_ListEditorSheet> createState() => _ListEditorSheetState();
}

class _ListEditorSheetState extends ConsumerState<_ListEditorSheet> {
  late final TextEditingController _nameController;
  late String _color;
  String? _icon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list?.name ?? '');
    _color = widget.list?.color ?? _listColorOptions.first;
    _icon = widget.list?.icon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEditing = widget.list != null;
    final canRename = widget.list?.isSystemList != true;
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            title: isEditing ? 'Edit List' : 'New List',
            subtitle: canRename ? null : 'System list name is locked.',
          ),
          const SizedBox(height: 18),
          _SheetTextField(
            controller: _nameController,
            hintText: 'List name',
            enabled: canRename,
          ),
          const SizedBox(height: 20),
          Text(
            'Color',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final color in _listColorOptions)
                _ColorSwatch(
                  color: color,
                  selected: _color.toUpperCase() == color,
                  onTap: () => setState(() => _color = color),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Icon',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in _listIconOptions)
                _IconChoice(
                  option: option,
                  selected: option.key == _icon,
                  color: _colorFromHex(_color, colors.primary),
                  onTap: () => setState(() => _icon = option.key),
                ),
            ],
          ),
          const SizedBox(height: 22),
          FlowActionButton(
            primary: true,
            icon: Icons.save_outlined,
            label: isEditing ? 'Save List' : 'Create List',
            onPressed: _save,
          ),
          if (isEditing && canRename) ...[
            const SizedBox(height: 10),
            FlowActionButton(
              icon: Icons.delete_outline,
              label: 'Delete List',
              destructive: true,
              onPressed: _confirmDelete,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repository = ref.read(listGroupRepositoryProvider);
    final list = widget.list;
    try {
      if (list == null) {
        await repository.createList(
          name: _nameController.text,
          color: _color,
          icon: _icon,
        );
      } else {
        if (!list.isSystemList) {
          await repository.renameList(id: list.id, name: _nameController.text);
        }
        await repository.updateListStyle(
          id: list.id,
          color: _color,
          icon: _icon,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (error) {
      if (mounted) {
        _showSheetSnack(context, '$error');
      }
    }
  }

  Future<void> _confirmDelete() async {
    final list = widget.list;
    if (list == null) {
      return;
    }
    final confirmed = await showFlowBottomSheet<bool>(
      context: context,
      builder: (context) => _ConfirmSheet(
        title: 'Delete List',
        message: 'Tasks in ${list.name} will move to Inbox.',
        actionLabel: 'Delete List',
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await ref.read(listGroupRepositoryProvider).deleteList(list.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (error) {
      if (mounted) {
        _showSheetSnack(context, '$error');
      }
    }
  }
}

class _GroupEditorSheet extends ConsumerStatefulWidget {
  const _GroupEditorSheet({
    required this.list,
    required this.sections,
    this.section,
  });

  final TaskList list;
  final List<ListTaskSection> sections;
  final ListTaskSection? section;

  @override
  ConsumerState<_GroupEditorSheet> createState() => _GroupEditorSheetState();
}

class _GroupEditorSheetState extends ConsumerState<_GroupEditorSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.section?.title ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.section != null;
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            title: isEditing ? 'Edit Group' : 'New Group',
            subtitle: widget.list.name,
          ),
          const SizedBox(height: 18),
          _SheetTextField(controller: _nameController, hintText: 'Group name'),
          const SizedBox(height: 22),
          FlowActionButton(
            primary: true,
            icon: Icons.save_outlined,
            label: isEditing ? 'Save Group' : 'Create Group',
            onPressed: _save,
          ),
          if (isEditing) ...[
            const SizedBox(height: 10),
            FlowActionButton(
              icon: Icons.delete_outline,
              label: 'Delete Group',
              destructive: true,
              onPressed: _confirmDelete,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repository = ref.read(listGroupRepositoryProvider);
    try {
      final section = widget.section;
      if (section == null) {
        await repository.createGroup(
          listId: widget.list.id,
          name: _nameController.text,
        );
      } else {
        await repository.renameGroup(
          id: section.groupId!,
          name: _nameController.text,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (error) {
      if (mounted) {
        _showSheetSnack(context, '$error');
      }
    }
  }

  Future<void> _confirmDelete() async {
    final section = widget.section;
    if (section == null) {
      return;
    }
    final choice = await showFlowBottomSheet<_DeleteGroupChoice>(
      context: context,
      builder: (context) =>
          _DeleteGroupChoiceSheet(section: section, sections: widget.sections),
    );
    if (choice == null) {
      return;
    }
    try {
      await ref
          .read(listGroupRepositoryProvider)
          .deleteGroup(
            section.groupId!,
            taskDisposition: choice.disposition,
            targetGroupId: choice.targetGroupId,
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (error) {
      if (mounted) {
        _showSheetSnack(context, '$error');
      }
    }
  }
}

class _DeleteGroupChoice {
  const _DeleteGroupChoice({required this.disposition, this.targetGroupId});

  final DeleteGroupTaskDisposition disposition;
  final String? targetGroupId;
}

class _DeleteGroupChoiceSheet extends StatefulWidget {
  const _DeleteGroupChoiceSheet({
    required this.section,
    required this.sections,
  });

  final ListTaskSection section;
  final List<ListTaskSection> sections;

  @override
  State<_DeleteGroupChoiceSheet> createState() =>
      _DeleteGroupChoiceSheetState();
}

class _DeleteGroupChoiceSheetState extends State<_DeleteGroupChoiceSheet> {
  DeleteGroupTaskDisposition _disposition =
      DeleteGroupTaskDisposition.moveToUngrouped;
  String? _targetGroupId;

  @override
  Widget build(BuildContext context) {
    final otherGroups = [
      for (final section in widget.sections)
        if (section.groupId != null &&
            section.groupId != widget.section.groupId)
          section,
    ];
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            title: 'Delete Group',
            subtitle:
                'Choose what happens to tasks in ${widget.section.title}.',
          ),
          const SizedBox(height: 16),
          _DeleteGroupChoiceRow(
            icon: Icons.inbox_outlined,
            label: 'Move tasks to Ungrouped',
            selected:
                _disposition == DeleteGroupTaskDisposition.moveToUngrouped,
            onTap: () => setState(() {
              _disposition = DeleteGroupTaskDisposition.moveToUngrouped;
              _targetGroupId = null;
            }),
          ),
          for (final group in otherGroups)
            _DeleteGroupChoiceRow(
              icon: Icons.folder_outlined,
              label: 'Move tasks to ${group.title}',
              selected:
                  _disposition == DeleteGroupTaskDisposition.moveToGroup &&
                  _targetGroupId == group.groupId,
              onTap: () => setState(() {
                _disposition = DeleteGroupTaskDisposition.moveToGroup;
                _targetGroupId = group.groupId;
              }),
            ),
          _DeleteGroupChoiceRow(
            icon: Icons.delete_outline,
            label: 'Move tasks to Trash',
            destructive: true,
            selected: _disposition == DeleteGroupTaskDisposition.deleteTasks,
            onTap: () => setState(() {
              _disposition = DeleteGroupTaskDisposition.deleteTasks;
              _targetGroupId = null;
            }),
          ),
          const SizedBox(height: 22),
          FlowActionButton(
            icon: Icons.delete_outline,
            label: 'Delete Group',
            destructive: true,
            onPressed: () => Navigator.of(context).pop(
              _DeleteGroupChoice(
                disposition: _disposition,
                targetGroupId: _targetGroupId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteGroupChoiceRow extends StatelessWidget {
  const _DeleteGroupChoiceRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = destructive
        ? colors.danger
        : selected
        ? colors.primary
        : colors.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _MoveTaskSheet extends ConsumerWidget {
  const _MoveTaskSheet({
    required this.task,
    required this.list,
    required this.sections,
  });

  final TaskItem task;
  final TaskList list;
  final List<ListTaskSection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(title: 'Move Task', subtitle: task.title),
          const SizedBox(height: 14),
          for (final section in sections)
            _MoveTargetRow(
              label: section.title,
              selected:
                  task.groupId == section.groupId ||
                  (task.groupId == null && section.isUngrouped),
              onTap: () async {
                await ref
                    .read(listGroupRepositoryProvider)
                    .moveTaskToGroup(
                      taskId: task.id,
                      listId: list.id,
                      groupId: section.groupId,
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  final String title;
  final String message;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(title: title, subtitle: message),
          const SizedBox(height: 22),
          FlowActionButton(
            icon: Icons.delete_outline,
            label: actionLabel,
            destructive: true,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoveTargetRow extends StatelessWidget {
  const _MoveTargetRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.primary : colors.iconMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.textStrong,
            fontSize: 20.5,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 15,
              height: 1.25,
            ),
          ),
        ],
      ],
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.hintText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: true,
      cursorColor: colors.primary,
      maxLines: 1,
      style: TextStyle(
        color: enabled ? colors.textStrong : colors.textMuted,
        fontSize: 20.5,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
      ),
      textInputAction: TextInputAction.done,
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final swatchColor = _colorFromHex(color, colors.primary);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colors.textStrong : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: swatchColor, shape: BoxShape.circle),
          child: selected
              ? Icon(Icons.check_rounded, size: 18, color: colors.bg)
              : null,
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.option,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final _ListIconOption option;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: option.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 38,
          decoration: BoxDecoration(
            color: selected ? colors.surfaceSelected : colors.surfaceRaised,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(option.icon, color: selected ? color : colors.iconMuted),
        ),
      ),
    );
  }
}

class _PanelIconAction extends StatelessWidget {
  const _PanelIconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _TinyIconButton(icon: icon, tooltip: tooltip, onPressed: onPressed);
  }
}

class _TinyIconButton extends StatelessWidget {
  const _TinyIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        iconSize: 20,
        color: colors.iconMuted,
        disabledColor: colors.textSubtle,
        icon: Icon(icon),
      ),
    );
  }
}

class _PanelMessage extends StatelessWidget {
  const _PanelMessage({required this.text, this.danger = false});

  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          color: danger ? colors.danger : colors.textMuted,
          fontSize: 15,
          height: 1.3,
        ),
      ),
    );
  }
}

class _ListIconOption {
  const _ListIconOption(this.key, this.icon, this.label);

  final String? key;
  final IconData icon;
  final String label;
}

IconData _iconDataForList(String? key) {
  return switch (key) {
    'inbox' => Icons.inbox_outlined,
    'menu' => Icons.menu_rounded,
    'flag' => Icons.flag_outlined,
    'bank' => Icons.account_balance_outlined,
    'spark' => Icons.auto_awesome_outlined,
    _ => Icons.list_alt_rounded,
  };
}

String _groupingModeLabel(ListTaskGroupingMode mode) {
  return switch (mode) {
    ListTaskGroupingMode.manualGroups => 'Manual groups',
    ListTaskGroupingMode.none => 'No groups',
    ListTaskGroupingMode.dueDate => 'Due date',
    ListTaskGroupingMode.priority => 'Priority',
    ListTaskGroupingMode.status => 'Status',
    ListTaskGroupingMode.persistent => 'Persistent',
  };
}

IconData _groupingModeIcon(ListTaskGroupingMode mode) {
  return switch (mode) {
    ListTaskGroupingMode.manualGroups => Icons.folder_outlined,
    ListTaskGroupingMode.none => Icons.view_agenda_outlined,
    ListTaskGroupingMode.dueDate => Icons.calendar_today_outlined,
    ListTaskGroupingMode.priority => Icons.flag_outlined,
    ListTaskGroupingMode.status => Icons.checklist_rounded,
    ListTaskGroupingMode.persistent => Icons.push_pin_outlined,
  };
}

String _sortModeLabel(ListTaskSortMode mode) {
  return switch (mode) {
    ListTaskSortMode.manual => 'Manual sort',
    ListTaskSortMode.dueDate => 'Due date',
    ListTaskSortMode.priority => 'Priority',
    ListTaskSortMode.createdDate => 'Created date',
    ListTaskSortMode.title => 'Title',
  };
}

IconData _sortModeIcon(ListTaskSortMode mode) {
  return switch (mode) {
    ListTaskSortMode.manual => Icons.swap_vert_rounded,
    ListTaskSortMode.dueDate => Icons.calendar_today_outlined,
    ListTaskSortMode.priority => Icons.flag_outlined,
    ListTaskSortMode.createdDate => Icons.schedule_outlined,
    ListTaskSortMode.title => Icons.sort_by_alpha_rounded,
  };
}

Color _colorFromHex(String value, Color fallback) {
  final hex = value.trim().replaceFirst('#', '');
  if (hex.length != 6) {
    return fallback;
  }
  final parsed = int.tryParse(hex, radix: 16);
  if (parsed == null) {
    return fallback;
  }
  return Color(0xFF000000 | parsed);
}

void _showSheetSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
