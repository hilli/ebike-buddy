import SwiftUI
import WeatherKit
import os

struct WeatherAttributionView: View {
    let attribution: WeatherAttribution

    @Environment(\.colorScheme) private var colorScheme

    private let logger = Logger(subsystem: "dk.hilli.GiantLogger", category: "WeatherAttribution")

    var body: some View {
        HStack {
            AsyncImage(
                url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Label("Weather", systemImage: "apple.logo")
                        .font(.system(size: 14))
                        .foregroundStyle(.primary)
                        .onChange(of: phase.error?.localizedDescription, initial: true) { _, message in
                            if let message {
                                logger.error("Failed to load Apple Weather mark: \(message)")
                            }
                        }
                }
            }
            .frame(width: 82, height: 18)
            .accessibilityLabel("Apple Weather")

            Spacer(minLength: 8)

            Link("Weather data sources", destination: attribution.legalPageURL)
        }
        .font(.caption)
    }
}
