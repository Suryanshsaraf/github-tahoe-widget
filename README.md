# GitHub Tahoe: Native macOS WidgetKit App

A premium, native macOS desktop widget for tracking your GitHub contributions, active streaks, and review queues. Built with **SwiftUI** and **WidgetKit**, styled after the **macOS 26 Tahoe "Liquid Glass"** visual system.

---

## ⚡ Features
* **Native Widget Gallery integration:** Drag, drop, and resize widgets natively on the macOS desktop wallpaper.
* **Liquid Glass Backing:** Uses macOS native `NSVisualEffectView` frosted glass overlays and drifting background fluid gradients.
* **Dynamic Streaks:** Track contribution streaks (current vs. longest) with active emoji highlights.
* **Review Queue Dashboard (GraphQL):** Tracks active pull requests waiting for review and outgoing PR statuses (private token mode).
* **Multi-Size Layouts:** Fully responsive small, medium, and large layouts matching Apple's widget guidelines.

---

## 🚀 Setup & Installation

### Step 1: Install XcodeGen
This project utilizes **XcodeGen** to build the Xcode project structure programmatically. Install it via Homebrew:
```bash
brew install xcodegen
```

### Step 2: Generate the Xcode Project
In the project root directory, run the project generator:
```bash
xcodegen generate
```
This will compile `project.yml` and output a ready-to-run Xcode project file: `GitHubTahoeApp.xcodeproj`.

### Step 3: Compile and Launch
1. Open the generated `GitHubTahoeApp.xcodeproj` in Xcode.
2. Go to the project settings, and select **"Sign to Run Locally"** (or select your personal developer team) for both the `GitHubTahoeApp` and `GitHubTahoeWidget` targets.
3. Build and Run the `GitHubTahoeApp` target.
4. The settings window will open. Type in your username (e.g. `Suryanshsaraf`) and click **Save Settings** to cache the data.

### Step 4: Add to Desktop
1. Right-click your macOS desktop background and select **"Edit Widgets..."**.
2. Search for **"GitHub Tahoe Widget"**.
3. Choose your size (Small, Medium, or Large) and drag it onto your desktop wallpaper!
