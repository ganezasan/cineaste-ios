//
//  Cineaste_Widget.swift
//  Cineaste-Widget
//
//  Created by Xaver Lohmüller on 30.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), movies: store.state.movies, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), movies: store.state.movies, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, movies: store.state.movies, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let movies: [Movie]
    let configuration: ConfigurationIntent

    init(date: Date, movies: [Movie], configuration: ConfigurationIntent) {
        self.date = date
        self.movies = movies
        self.configuration = configuration
    }

    init(date: Date, movies: Set<Movie>, configuration: ConfigurationIntent) {
        self.date = date
        self.movies = Array(movies)
        self.configuration = configuration
    }
}

struct Cineaste_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(entry.movies) { movie in
                Text(movie.title)
            }
        }
    }
}

extension Movie: Identifiable {}

@main
struct Cineaste_Widget: Widget {
    let kind: String = "Cineaste_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Cineaste_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Cineaste_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Cineaste_WidgetEntryView(entry: SimpleEntry(date: Date(), movies: [Movie.testingWatchlist, .testingWatchlist2], configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Movie {
    static let testingWatchlist = Movie(
        id: 10_898,
        title: "The Little Mermaid II: Return to the Sea",
        voteAverage: 6.3,
        voteCount: 898,
        posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
        overview: "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
        runtime: 72,
        releaseDate: Date(timeIntervalSince1970: 948_585_600),
        genres: [
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 10_751, name: "Family"),
            Genre(id: 10_402, name: "Music")
        ],
        watched: false,
        watchedDate: nil,
        listPosition: 0,
        popularity: 2.535
    )

    static let testingWatchlist2 = Movie(
        id: 3,
        title: "Harry Potter",
        voteAverage: 0,
        voteCount: 0,
        posterPath: nil,
        overview: "",
        runtime: 132,
        releaseDate: Date(timeIntervalSince1970: 1_763_589_628),
        genres: [],
        watched: false,
        watchedDate: nil,
        popularity: 448
    )
}
