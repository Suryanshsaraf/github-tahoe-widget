import Foundation

public struct GitHubContributionDay: Codable, Identifiable, Hashable {
    public var id: String { date }
    public let date: String
    public let count: Int
    public let level: Int
    
    public init(date: String, count: Int, level: Int) {
        self.date = date
        self.count = count
        self.level = level
    }
}

public struct GitHubPullRequest: Codable, Identifiable, Hashable {
    public var id: String { url }
    public let title: String
    public let url: String
    public let repo: String
    public let author: String?
    public let createdAt: String
    
    public init(title: String, url: String, repo: String, author: String? = nil, createdAt: String) {
        self.title = title
        self.url = url
        self.repo = repo
        self.author = author
        self.createdAt = createdAt
    }
}

public struct GitHubUserProfile: Codable, Hashable {
    public let username: String
    public let name: String
    public let avatarUrl: String
    public let bio: String?
    public let followers: Int
    public let stars: Int
    public let totalContributions: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let contributions: [GitHubContributionDay]
    public let incomingPRs: [GitHubPullRequest]
    public let outgoingPRs: [GitHubPullRequest]
    public let authenticated: Bool
    
    public init(
        username: String,
        name: String,
        avatarUrl: String,
        bio: String?,
        followers: Int,
        stars: Int,
        totalContributions: Int,
        currentStreak: Int,
        longestStreak: Int,
        contributions: [GitHubContributionDay],
        incomingPRs: [GitHubPullRequest],
        outgoingPRs: [GitHubPullRequest],
        authenticated: Bool
    ) {
        self.username = username
        self.name = name
        self.avatarUrl = avatarUrl
        self.bio = bio
        self.followers = followers
        self.stars = stars
        self.totalContributions = totalContributions
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.contributions = contributions
        self.incomingPRs = incomingPRs
        self.outgoingPRs = outgoingPRs
        self.authenticated = authenticated
    }
}
