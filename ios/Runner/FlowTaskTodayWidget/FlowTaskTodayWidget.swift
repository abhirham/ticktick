import SwiftUI
import WidgetKit

private struct FlowTaskWidgetSnapshot: Decodable {
  let dueTodayCount: Int
  let generatedAt: String
  let timeZone: String
  let nextDueTodayTasks: [String]
  let displayMode: String
  let lockScreenTitlesEnabled: Bool
  let tapDestination: String

  static let empty = FlowTaskWidgetSnapshot(
    dueTodayCount: 0,
    generatedAt: "",
    timeZone: "",
    nextDueTodayTasks: [],
    displayMode: "countOnly",
    lockScreenTitlesEnabled: false,
    tapDestination: "today"
  )
}

private struct FlowTaskWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: FlowTaskWidgetSnapshot
}

private struct FlowTaskWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> FlowTaskWidgetEntry {
    FlowTaskWidgetEntry(date: Date(), snapshot: .empty)
  }

  func getSnapshot(in context: Context, completion: @escaping (FlowTaskWidgetEntry) -> Void) {
    completion(FlowTaskWidgetEntry(date: Date(), snapshot: readSnapshot()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FlowTaskWidgetEntry>) -> Void) {
    let entry = FlowTaskWidgetEntry(date: Date(), snapshot: readSnapshot())
    let nextRefresh = Calendar.current.nextDate(
      after: Date(),
      matching: DateComponents(hour: 0, minute: 1),
      matchingPolicy: .nextTime
    ) ?? Date().addingTimeInterval(3600)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }

  private func readSnapshot() -> FlowTaskWidgetSnapshot {
    let defaults = UserDefaults(suiteName: "group.com.flowtask.flowtask") ?? UserDefaults.standard
    guard let json = defaults.string(forKey: "today_snapshot"),
          let data = json.data(using: .utf8),
          let snapshot = try? JSONDecoder().decode(FlowTaskWidgetSnapshot.self, from: data) else {
      return .empty
    }
    return snapshot
  }
}

private struct FlowTaskTodayWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: FlowTaskWidgetEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("Today")
        .font(.headline.weight(.bold))
        .foregroundStyle(Color.white)
      Text("\(entry.snapshot.dueTodayCount)")
        .font(.system(size: family == .systemSmall ? 42 : 52, weight: .bold))
        .foregroundStyle(Color(red: 0.29, green: 0.47, blue: 1.0))
      Text(entry.snapshot.dueTodayCount == 1 ? "task due today" : "tasks due today")
        .font(.caption)
        .foregroundStyle(Color.gray)
      if shouldShowTitles {
        ForEach(entry.snapshot.nextDueTodayTasks.prefix(3), id: \.self) { title in
          Text("• \(title)")
            .font(.caption)
            .lineLimit(1)
            .foregroundStyle(Color.white.opacity(0.88))
        }
      }
      Spacer(minLength: 0)
    }
    .background(Color(red: 0.11, green: 0.11, blue: 0.11))
    .widgetURL(url)
  }

  private var shouldShowTitles: Bool {
    if family == .accessoryCircular || family == .accessoryRectangular {
      return entry.snapshot.lockScreenTitlesEnabled
    }
    return entry.snapshot.displayMode == "countAndTitles"
  }

  private var url: URL? {
    switch entry.snapshot.tapDestination {
    case "addTask":
      return URL(string: "flowtask://add")
    case "calendar":
      return URL(string: "flowtask://calendar")
    default:
      return URL(string: "flowtask://today")
    }
  }
}

@main
struct FlowTaskTodayWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "FlowTaskTodayWidget",
      provider: FlowTaskWidgetProvider()
    ) { entry in
      FlowTaskTodayWidgetView(entry: entry)
    }
    .configurationDisplayName("FlowTask Today")
    .description("Shows today's due task count.")
    .supportedFamilies([
      .systemSmall,
      .systemMedium,
      .accessoryCircular,
      .accessoryRectangular,
    ])
  }
}
