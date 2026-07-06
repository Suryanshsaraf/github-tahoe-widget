import SwiftUI

public struct ContentView: View {
    @StateObject private var store = WidgetSettingsStore.shared
    @State private var usernameInput: String = ""
    @State private var tokenInput: String = ""
    @State private var selectedTheme: String = "tahoe-dream"
    @State private var isTestingConnection: Bool = false
    @State private var statusMessage: String = ""
    @State private var isErrorStatus: Bool = false
    
    private let networkService = GitHubNetworkService()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "square.grid.3x3.topleft.filled")
                    .font(.system(size: 28))
                    .foregroundStyle(.cyan)
                VStack(alignment: .leading, spacing: 2) {
                    Text("GitHub Tahoe")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Liquid Glass macOS Widget Configurator")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.bottom, 5)
            
            // Configuration Form
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("GitHub Username")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("Enter username", text: $usernameInput)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Personal Access Token (PAT)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    SecureField("ghp_...", text: $tokenInput)
                        .textFieldStyle(.roundedBorder)
                    Text("Provide a token to track private repository contributions and active PR queues.")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Widget Theme")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Picker("", selection: $selectedTheme) {
                        Text("Tahoe Dream (Neon Cyan/Purple/Pink)").tag("tahoe-dream")
                        Text("Aurora Glass (Green/Cyan)").tag("aurora-glass")
                        Text("Sunset Glow (Orange/Red/Magenta)").tag("sunset-glow")
                        Text("Graphite Matte (Monochrome)").tag("graphite-matte")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            .cornerRadius(12)
            
            // Status and Buttons
            HStack {
                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundColor(isErrorStatus ? .red : .green)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                Spacer()
                
                Button(action: testConnection) {
                    if isTestingConnection {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.horizontal, 8)
                    } else {
                        Text("Test Connection")
                    }
                }
                .disabled(usernameInput.isEmpty || isTestingConnection)
                
                Button("Save Settings") {
                    store.saveSettings(username: usernameInput, token: tokenInput, theme: selectedTheme)
                    statusMessage = "Settings saved successfully! Widgets updated."
                    isErrorStatus = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(usernameInput.isEmpty)
            }
            
            // User Preview Info (if available)
            if let profile = store.cachedProfile {
                Divider()
                HStack(spacing: 12) {
                    // Profile Image
                    AsyncImage(url: URL(string: profile.avatarUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 44, height: 44)
                    }
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name)
                            .font(.headline)
                        Text("@\(profile.username) • \(profile.authenticated ? "🔒 Private mode" : "🌐 Public mode")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(profile.totalContributions) Contributions")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Streak: \(profile.currentStreak) days 🔥")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .padding(24)
        .frame(width: 520, height: 450)
        .onAppear {
            usernameInput = store.username
            tokenInput = store.token
            selectedTheme = store.theme
        }
    }
    
    private func testConnection() {
        isTestingConnection = true
        statusMessage = "Connecting to GitHub..."
        isErrorStatus = false
        
        Task {
            do {
                let tokenOpt = tokenInput.isEmpty ? nil : tokenInput
                let profile = try await networkService.fetchUserProfile(username: usernameInput, token: tokenOpt)
                
                await MainActor.run {
                    store.cacheProfile(profile)
                    statusMessage = "Connected successfully! Saved cache."
                    isTestingConnection = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "Error: \(error.localizedDescription)"
                    isErrorStatus = true
                    isTestingConnection = false
                }
            }
        }
    }
}
