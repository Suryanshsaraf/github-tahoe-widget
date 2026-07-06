import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

public class WidgetSettingsStore: ObservableObject {
    public static let shared = WidgetSettingsStore()
    
    private let appGroupId = "group.com.Suryanshsaraf.github-tahoe-widget"
    
    @Published public var username: String = ""
    @Published public var token: String = ""
    @Published public var theme: String = "tahoe-dream"
    @Published public var cachedProfile: GitHubUserProfile? = nil
    
    private var defaults: UserDefaults {
        return UserDefaults(suiteName: appGroupId) ?? UserDefaults.standard
    }
    
    private init() {
        loadSettings()
    }
    
    public func saveSettings(username: String, token: String, theme: String) {
        self.username = username
        self.token = token
        self.theme = theme
        
        defaults.set(username, forKey: "github_username")
        defaults.set(token, forKey: "github_token")
        defaults.set(theme, forKey: "github_theme")
        defaults.synchronize()
        
        // Notify Widget Center that values changed
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    public func loadSettings() {
        self.username = defaults.string(forKey: "github_username") ?? "Suryanshsaraf"
        self.token = defaults.string(forKey: "github_token") ?? ""
        self.theme = defaults.string(forKey: "github_theme") ?? "tahoe-dream"
        
        if let data = defaults.data(forKey: "github_cached_profile"),
           let profile = try? JSONDecoder().decode(GitHubUserProfile.self, from: data) {
            self.cachedProfile = profile
        }
    }
    
    public func cacheProfile(_ profile: GitHubUserProfile) {
        self.cachedProfile = profile
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: "github_cached_profile")
            defaults.synchronize()
        }
    }
    
    public func clearCache() {
        self.cachedProfile = nil
        defaults.removeObject(forKey: "github_cached_profile")
        defaults.synchronize()
    }
}
