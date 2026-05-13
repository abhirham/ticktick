import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../data/list_group_repository.dart';

final listGroupRepositoryProvider = Provider<ListGroupRepository>((ref) {
  return ListGroupRepository(ref.watch(appDatabaseProvider));
});

final listSummariesProvider = StreamProvider<List<TaskListSummary>>((ref) {
  return ref.watch(listGroupRepositoryProvider).watchListSummaries();
});

final listGroupsProvider = StreamProvider.family<List<ListGroup>, String>((
  ref,
  listId,
) {
  return ref.watch(listGroupRepositoryProvider).watchGroups(listId);
});

final listTaskSectionsProvider =
    StreamProvider.family<List<ListTaskSection>, ListTaskSectionsRequest>((
      ref,
      request,
    ) {
      return ref
          .watch(listGroupRepositoryProvider)
          .watchListTaskSections(
            listId: request.listId,
            groupingMode: request.groupingMode,
            sortMode: request.sortMode,
          );
    });

class ListTaskSectionsRequest {
  const ListTaskSectionsRequest({
    required this.listId,
    this.groupingMode = ListTaskGroupingMode.manualGroups,
    this.sortMode = ListTaskSortMode.manual,
  });

  final String listId;
  final ListTaskGroupingMode groupingMode;
  final ListTaskSortMode sortMode;

  @override
  bool operator ==(Object other) {
    return other is ListTaskSectionsRequest &&
        other.listId == listId &&
        other.groupingMode == groupingMode &&
        other.sortMode == sortMode;
  }

  @override
  int get hashCode => Object.hash(listId, groupingMode, sortMode);
}
