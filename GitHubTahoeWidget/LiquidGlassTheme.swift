import SwiftUI

public extension Color {
    static let tahoeCyan = Color(red: 0.0, green: 0.9, blue: 1.0)
    static let tahoePurple = Color(red: 0.58, green: 0.2, blue: 0.92)
    static let tahoePink = Color(red: 1.0, green: 0.0, blue: 0.5)
    
    static func colorForLevel(_ level: Int, theme: String) -> Color {
        if level == 0 {
            return Color.white.opacity(0.08)
        }
        
        switch theme {
        case "aurora-glass":
            switch level {
            case 1: return Color.green.opacity(0.25)
            case 2: return Color.green.opacity(0.55)
            case 3: return Color.cyan.opacity(0.7)
            default: return Color.cyan
            }
        case "sunset-glow":
            switch level {
            case 1: return Color.orange.opacity(0.25)
            case 2: return Color.orange.opacity(0.55)
            case 3: return Color.red.opacity(0.75)
            default: return Color.tahoePink
            }
        case "graphite-matte":
            switch level {
            case 1: return Color.white.opacity(0.2)
            case 2: return Color.white.opacity(0.4)
            case 3: return Color.white.opacity(0.65)
            default: return Color.white.opacity(0.9)
            }
        default: // tahoe-dream
            switch level {
            case 1: return Color.tahoeCyan.opacity(0.25)
            case 2: return Color.tahoeCyan.opacity(0.6)
            case 3: return Color.tahoePurple.opacity(0.75)
            default: return Color.tahoePink
            }
        }
    }
}

// macOS Native Frosted Glass (NSVisualEffectView Wrapper)
public struct VisualEffectView: NSViewRepresentable {
    public let material: NSVisualEffectView.Material
    public let blendingMode: NSVisualEffectView.BlendingMode
    
    public init(material: NSVisualEffectView.Material = .hudWindow, blendingMode: NSVisualEffectView.BlendingMode = .behindWindow) {
        self.material = material
        self.blendingMode = blendingMode
    }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// Liquid Glass Backing Card Modifier
public struct LiquidGlassModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            )
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.28),
                                Color.white.opacity(0.05),
                                Color.white.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.35), radius: 30, x: 0, y: 20)
    }
}

public extension View {
    func liquidGlassBacking() -> some View {
        self.modifier(LiquidGlassModifier())
    }
}

// Drifting Liquid Blob Background (Matches CSS drift keyframes)
public struct LiquidBlobsView: View {
    @State private var animate = false
    let theme: String
    
    public init(theme: String) {
        self.theme = theme
    }
    
    private var blobColors: (Color, Color, Color) {
        switch theme {
        case "aurora-glass":
            return (Color.green, Color.cyan, Color.blue)
        case "sunset-glow":
            return (Color.orange, Color.red, Color.tahoePink)
        case "graphite-matte":
            return (Color.gray, Color.white, Color.black)
        default:
            return (Color.tahoeCyan, Color.tahoePink, Color.tahoePurple)
        }
    }
    
    public var body: some View {
        ZStack {
            // Blob 1 (Cyan/Green/Orange)
            Circle()
                .fill(RadialGradient(colors: [blobColors.0.opacity(0.4), blobColors.0.opacity(0)], center: .center, startRadius: 0, endRadius: 120))
                .frame(width: 250, height: 250)
                .offset(x: animate ? 60 : -40, y: animate ? -50 : 30)
            
            // Blob 2 (Pink/Red/White)
            Circle()
                .fill(RadialGradient(colors: [blobColors.1.opacity(0.35), blobColors.1.opacity(0)], center: .center, startRadius: 0, endRadius: 100))
                .frame(width: 220, height: 220)
                .offset(x: animate ? -40 : 50, y: animate ? 60 : -40)
            
            // Blob 3 (Purple/Blue/Black)
            Circle()
                .fill(RadialGradient(colors: [blobColors.2.opacity(0.3), blobColors.2.opacity(0)], center: .center, startRadius: 0, endRadius: 150))
                .frame(width: 300, height: 300)
                .offset(x: animate ? 30 : -20, y: animate ? 20 : 50)
        }
        .blur(radius: 40)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 25)
                .repeatForever(autoreverses: true)
            ) {
                animate.toggle()
            }
        }
    }
}
