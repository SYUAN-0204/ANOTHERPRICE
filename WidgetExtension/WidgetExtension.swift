import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let taskTitle: String
    let taskDescription: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), taskTitle: "每日任務", taskDescription: "問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), taskTitle: "每日任務", taskDescription: "問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, taskTitle: "每日任務", taskDescription: "問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetExtensionEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.white // Set the background color to white

            VStack(alignment: .leading) {
                Text(entry.taskTitle)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                    .foregroundColor(.black.opacity(0.8))
                    .lineLimit(1)
                    .padding(.top, 3)
                Text(entry.taskDescription)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(.gray)
                    .lineLimit(5)
                    .padding(.top, -3)
                Spacer()
                Text("更新於 2025-05-03")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(5)
                    .padding(.top, -3)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 5)
        }
        .containerBackground(Color.white, for: .widget) // Apply white background to the widget container
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("每日任務 Widget")
        .description("This widget shows your daily tasks.")
    }
}

#Preview(as: .systemMedium) { // Use systemMedium for a wider layout
    WidgetExtension()
} timeline: {
    SimpleEntry(date: .now, taskTitle: "組裝六千塊的電腦", taskDescription: "問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試")
}
