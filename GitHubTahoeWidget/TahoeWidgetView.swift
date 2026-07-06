import WidgetKit
import SwiftUI

// Core Entry View representing the widget UI
public struct TahoeWidgetEntryView : View {
    var entry: TahoeWidgetTimelineProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    public init(entry: TahoeWidgetTimelineProvider.Entry) {
        self.entry = entry
    }
    
    public var body: some View {
        ZStack {
            if let profile = entry.profile {
                // Drifting Liquid Orbs Background
                LiquidBlobsView(theme: entry.theme)
                
                // Frosted Glass Layer
                VStack(spacing: 0) {
                    switch family {
                    case .systemSmall:
                        renderSmallWidget(profile: profile)
                    case .systemMedium:
                        renderMediumWidget(profile: profile)
                    default: // systemLarge
                        renderLargeWidget(profile: profile)
                    }
                }
                .padding(16)
            } else {
                // Setup / Welcome Screen
                VStack(spacing: 8) {
                    Text("GitHub Tahoe")
                        .font(.headline)
                        .foregroundStyle(.cyan)
                    Text("Configure your username in the configurator app to activate.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .liquidGlassBacking() // Custom liquid glass modifier
    }
    
    // --- 1. SMALL WIDGET LAYOUT ---
    private func renderSmallWidget(profile: GitHubUserProfile) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "square.grid.3x3.topleft.filled")
                    .foregroundColor(.cyan)
                    .font(.title3)
                Spacer()
                Text("🔥 \(profile.currentStreak)")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(profile.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text("@\(profile.username)")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Contributions")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Text("\(profile.totalContributions)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                Spacer()
            }
        }
    }
    
    // --- 2. MEDIUM WIDGET LAYOUT (Dashboard + 18-Week Graph) ---
    private func renderMediumWidget(profile: GitHubUserProfile) -> some View {
        VStack(spacing: 12) {
            // Header Profile & Streak counts
            HStack(alignment: .center) {
                // Profile Avatar Wrapper
                if !profile.avatarUrl.isEmpty, let url = URL(string: profile.avatarUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle().fill(Color.white.opacity(0.1)).frame(width: 36, height: 36)
                    }
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                } else {
                    Circle().fill(Color.white.opacity(0.15)).frame(width: 36, height: 36)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(profile.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("@\(profile.username)")
                        .font(.system(size: 9))
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                // Badges
                HStack(spacing: 6) {
                    VStack(alignment: .center, spacing: 2) {
                        Text("TOTAL")
                            .font(.system(size: 7))
                            .foregroundColor(.secondary)
                        Text("\(profile.totalContributions)")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(6)
                    
                    VStack(alignment: .center, spacing: 2) {
                        Text("STREAK")
                            .font(.system(size: 7))
                            .foregroundColor(.secondary)
                        Text("\(profile.currentStreak) 🔥")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(6)
                }
            }
            
            // Contribution Grid (Last 18 Weeks)
            let weeksToShow = 18
            let daysToShow = weeksToShow * 7
            let recentDays = Array(profile.contributions.suffix(daysToShow))
            let chunkedWeeks = recentDays.publisher.collect(7) // Chunk days into 7-day columns
            
            // Custom CSS-like Grid using Stack
            HStack(spacing: 3) {
                ForEach(0..<weeksToShow, id: \.self) { weekIdx in
                    let startIndex = weekIdx * 7
                    if startIndex < recentDays.count {
                        VStack(spacing: 3) {
                            ForEach(0..<7, id: \.self) { dayIdx in
                                let index = startIndex + dayIdx
                                if index < recentDays.count {
                                    let day = recentDays[index]
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .fill(Color.colorForLevel(day.level, theme: entry.theme))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    // --- 3. LARGE WIDGET LAYOUT (Full Profile + 20-Week Graph + PR List) ---
    private func renderLargeWidget(profile: GitHubUserProfile) -> some View {
        VStack(spacing: 16) {
            // Header Profile Card
            HStack(spacing: 12) {
                if !profile.avatarUrl.isEmpty, let url = URL(string: profile.avatarUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle().fill(Color.white.opacity(0.1)).frame(width: 44, height: 44)
                    }
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    if let bio = profile.bio {
                        Text(bio)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Stars: \(profile.stars) ⭐")
                        .font(.system(size: 10))
                    Text("Followers: \(profile.followers)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            
            // Stats Row
            HStack(spacing: 8) {
                VStack(spacing: 4) {
                    Text("CONTRIBUTIONS")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                    Text("\(profile.totalContributions)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.04))
                .cornerRadius(10)
                
                VStack(spacing: 4) {
                    Text("CURRENT STREAK")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                    Text("\(profile.currentStreak) 🔥")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.04))
                .cornerRadius(10)
                
                VStack(spacing: 4) {
                    Text("LONGEST STREAK")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                    Text("\(profile.longestStreak) 🏆")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.04))
                .cornerRadius(10)
            }
            
            // Contribution Grid (Last 20 Weeks)
            let weeksToShow = 20
            let daysToShow = weeksToShow * 7
            let recentDays = Array(profile.contributions.suffix(daysToShow))
            
            HStack(spacing: 3) {
                ForEach(0..<weeksToShow, id: \.self) { weekIdx in
                    let startIndex = weekIdx * 7
                    if startIndex < recentDays.count {
                        VStack(spacing: 3) {
                            ForEach(0..<7, id: \.self) { dayIdx in
                                let index = startIndex + dayIdx
                                if index < recentDays.count {
                                    let day = recentDays[index]
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .fill(Color.colorForLevel(day.level, theme: entry.theme))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Active Pull Requests List
            if profile.authenticated && (!profile.incomingPRs.isEmpty || !profile.outgoingPRs.isEmpty) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ACTIVE PULL REQUESTS")
                        .font(.system(size: 9))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    let combinedPRs = Array(profile.outgoingPRs.prefix(2)) + Array(profile.incomingPRs.prefix(2))
                    ForEach(combinedPRs, id: \.self) { pr in
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(pr.title)
                                    .font(.system(size: 11))
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Text(pr.author != nil ? "Waiting for review • \(pr.repo)" : "Authored • \(pr.repo)")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// Widget Configuration entry point
@main
public struct TahoeWidget: Widget {
    let kind: String = "GitHubTahoeWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TahoeWidgetTimelineProvider()) { entry in
            TahoeWidgetEntryView(entry: entry)
                .containerBackground(.black.opacity(0.1), for: .widget)
        }
        .configurationDisplayName("GitHub Tahoe Widget")
        .description("Display your GitHub contributions calendar and active pull requests on your desktop.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
