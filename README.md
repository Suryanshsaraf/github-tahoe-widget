# GitHub Tahoe: Native macOS WidgetKit App

A premium, native macOS desktop widget for tracking your GitHub contributions, active streaks, stars, and review queues. Built natively using **SwiftUI**, **WidgetKit**, and the **macOS 26 Tahoe "Liquid Glass"** visual system.

---

## ⚡ Features

* **Direct Desktop Placement:** Drag, drop, and resize widgets natively on the macOS desktop wallpaper.
* **Liquid Glass Backing:** Uses macOS native `NSVisualEffectView` frosted glass overlays and animated background liquid gradient orbs.
* **Dynamic Streaks:** Track contribution streaks (current vs. longest) with active emoji highlights.
* **Review Queue Dashboard (GraphQL):** Tracks active pull requests waiting for review and outgoing PR statuses (requires token).
* **Multi-Size Layouts:** Fully responsive small, medium, and large layouts matching Apple's widget guidelines.
* **XcodeGen Powered:** No messy Xcode project merge conflicts; the project structure is cleanly generated on-the-fly.

---

## 📂 Project Structure

```
github-tahoe-widget/
├── project.yml                 # XcodeGen configuration target file
├── .gitignore                  # Excludes generated projects and build caches
├── README.md                   # Setup and usage guide
├── GitHubTahoeApp/             # macOS Host Configurator App
│   ├── AppEntry.swift          # Main entry point (App window setup)
│   ├── ContentView.swift       # Form UI (Username, PAT, Theme picker)
│   ├── GitHubTahoeModel.swift  # Profile, PR, and Day data structures
│   ├── GitHubNetworkService.swift # REST & GraphQL API data fetcher
│   ├── WidgetSettingsStore.swift  # Shared database coordinator (App Groups)
│   └── LiquidGlassTheme.swift  # Frosted glass modifiers & animated blobs
└── GitHubTahoeWidget/          # macOS Widget Extension Target
    ├── Info.plist              # Widget metadata config
    ├── TahoeWidgetTimelineProvider.swift # Timeline loading and cache provider
    └── TahoeWidgetView.swift   # Small, Medium, and Large SwiftUI widget templates
```

---

## 🚀 Setup & Installation

### Step 1: Install XcodeGen
This project utilizes **XcodeGen** to build the Xcode project structure programmatically. Install it via Homebrew:
```bash
brew install xcodegen
```

### Step 2: Generate the Xcode Project
In your terminal, navigate to the project directory and run:
```bash
xcodegen generate
```
This will compile `project.yml` and output a ready-to-run Xcode project file: `GitHubTahoeApp.xcodeproj`.

### Step 3: Configure Signing & App Groups
1. Double-click the generated `GitHubTahoeApp.xcodeproj` to open it in Xcode.
2. Select the root **GitHubTahoeApp** in the Project Navigator (left pane).
3. Under the **Signing & Capabilities** tab:
   * Select your target **GitHubTahoeApp**:
     * Set **Signing Certificate** to **"Sign to Run Locally"** (or select your personal Apple Developer Team).
     * Add **App Groups** and configure it with: `group.com.Suryanshsaraf.github-tahoe-widget`.
   * Select your target **GitHubTahoeWidget**:
     * Set **Signing Certificate** to **"Sign to Run Locally"** (must match the host app).
     * Add **App Groups** and check `group.com.Suryanshsaraf.github-tahoe-widget`.

### Step 4: Build & Save Settings
1. Build and Run (`Cmd + R`) the **GitHubTahoeApp** target.
2. The config window will open. Type in your GitHub username (`Suryanshsaraf`).
3. (Optional) Paste in a **GitHub Personal Access Token (Classic)** with the `repo` and `read:user` scopes to activate **Private Mode** (tracks private contributions and pull request reviews).
4. Select your theme (e.g. **Tahoe Dream**) and click **Save Settings**.

### Step 5: Add Widget to Desktop
1. Right-click your macOS desktop background and select **"Edit Widgets..."**.
2. Scroll or search for **"GitHub Tahoe Widget"**.
3. Choose your preferred size:
   * **Small:** Shows your total contributions and current streak 🔥.
   * **Medium:** Shows your profile header and an 18-week contribution grid.
   * **Large:** Shows your profile header, full streaks stats row, 20-week contribution grid, and active pull request review queues.
4. Drag it anywhere on your desktop wallpaper!

---

## 🎨 Themes Available

* **Tahoe Dream:** Vibrant Neon Cyan, Hot Pink, and Violet gradient blobs drifting behind frosted glass.
* **Aurora Glass:** Refreshing Emerald Green, Mint, and Marine Blue background blobs.
* **Sunset Glow:** Rich Orange, Ember Red, and Magenta gradients.
* **Graphite Matte:** Minimalist, high-end monochrome glass look.
