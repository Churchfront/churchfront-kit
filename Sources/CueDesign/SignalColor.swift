import SwiftUI
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Churchfront Signal tokens for the Cue apps.
///
/// Dark is the booth default: neutral greys like Ableton and ProPresenter,
/// never blue-tinted, so operators judge slide, video and lighting colour
/// truthfully. Colour is kept for meaning (accent, status, tally).
/// Light values follow the Signal design system for apps that offer it.
public enum SignalColor {
    /// Raw hex values, so non-SwiftUI code (Metal, CoreGraphics, web remotes) can share them.
    public struct Pair: Sendable, Equatable {
        public let dark: UInt32
        public let light: UInt32
    }

    public enum Hex {
        // Brand constants.
        public static let midnight: UInt32 = 0x090E14
        public static let grey: UInt32 = 0xE6E7E8
        public static let refresh: UInt32 = 0xCAE7F9

        // Surfaces, darkest to lightest in dark mode.
        public static let bg = Pair(dark: 0x121212, light: 0xE6E7E8)            // page
        public static let surface = Pair(dark: 0x1C1C1C, light: 0xF4F5F6)       // panels, sidebars
        public static let toolbar = Pair(dark: 0x232323, light: 0xEDEEEF)       // toolbars
        public static let header = Pair(dark: 0x262626, light: 0xEDEEEF)        // panel and table headers
        public static let surfaceRaised = Pair(dark: 0x2E2E2E, light: 0xFFFFFF) // menus, inputs, hovered rows
        public static let surfaceSunken = Pair(dark: 0x0A0A0A, light: 0xD9DCDF) // wells: waveforms, meters, previews
        public static let line = Pair(dark: 0x333333, light: 0xC9CED4)          // decorative hairlines
        public static let lineStrong = Pair(dark: 0x6B6B6B, light: 0x6F7C8A)    // control borders, 3:1

        // Text.
        public static let ink = Pair(dark: 0xE6E7E8, light: 0x121212)           // 13:1
        public static let inkMuted = Pair(dark: 0xABABAB, light: 0x3A4858)      // 7:1
        public static let inkSubtle = Pair(dark: 0x8A8A8A, light: 0x526172)     // 5:1, metadata

        // Accent and actions.
        public static let accent = Pair(dark: 0xCAE7F9, light: 0x155C8F)
        public static let accentStrong = Pair(dark: 0x7CC2EE, light: 0x0F4A75)
        public static let accentSoft = Pair(dark: 0x2B3A45, light: 0xCAE7F9)    // selected fill
        public static let action = Pair(dark: 0xCAE7F9, light: 0x121212)
        public static let actionHover = Pair(dark: 0xA6D6F4, light: 0x2E2E2E)
        public static let onAction = Pair(dark: 0x121212, light: 0xE6E7E8)
        public static let focusRing = Pair(dark: 0x7CC2EE, light: 0x1A73B3)

        // Status.
        public static let success = Pair(dark: 0x4FD8C4, light: 0x0B6E68)
        public static let successSoft = Pair(dark: 0x0A2B28, light: 0xD2F5EF)
        public static let warning = Pair(dark: 0xF2B84B, light: 0x7A5000)
        public static let warningSoft = Pair(dark: 0x2E2208, light: 0xF8E7C2)
        public static let danger = Pair(dark: 0xFF6B5E, light: 0xB42318)
        public static let dangerSoft = Pair(dark: 0x34120F, light: 0xFBDAD6)
        public static let onDanger = Pair(dark: 0x121212, light: 0xFFFFFF)

        // Tally: program red, preview green, as on every switcher panel.
        public static let tallyProgram = Pair(dark: 0xEF4136, light: 0xD92D20)
        public static let tallyPreview = Pair(dark: 0x6CCB6A, light: 0x2E7D32)
    }

    public static let midnight = solid(Hex.midnight)
    public static let grey = solid(Hex.grey)
    public static let refresh = solid(Hex.refresh)

    public static let bg = token(Hex.bg)
    public static let surface = token(Hex.surface)
    public static let toolbar = token(Hex.toolbar)
    public static let header = token(Hex.header)
    public static let surfaceRaised = token(Hex.surfaceRaised)
    public static let surfaceSunken = token(Hex.surfaceSunken)
    public static let line = token(Hex.line)
    public static let lineStrong = token(Hex.lineStrong)
    public static let ink = token(Hex.ink)
    public static let inkMuted = token(Hex.inkMuted)
    public static let inkSubtle = token(Hex.inkSubtle)
    public static let accent = token(Hex.accent)
    public static let accentStrong = token(Hex.accentStrong)
    public static let accentSoft = token(Hex.accentSoft)
    public static let action = token(Hex.action)
    public static let actionHover = token(Hex.actionHover)
    public static let onAction = token(Hex.onAction)
    public static let focusRing = token(Hex.focusRing)
    public static let success = token(Hex.success)
    public static let successSoft = token(Hex.successSoft)
    public static let warning = token(Hex.warning)
    public static let warningSoft = token(Hex.warningSoft)
    public static let danger = token(Hex.danger)
    public static let dangerSoft = token(Hex.dangerSoft)
    public static let onDanger = token(Hex.onDanger)
    public static let tallyProgram = token(Hex.tallyProgram)
    public static let tallyPreview = token(Hex.tallyPreview)

    /// A fixed sRGB colour from 0xRRGGBB.
    public static func solid(_ v: UInt32, opacity: Double = 1) -> Color {
        Color(.sRGB, red: Double((v >> 16) & 0xFF) / 255, green: Double((v >> 8) & 0xFF) / 255, blue: Double(v & 0xFF) / 255, opacity: opacity)
    }

    /// A colour that follows the app's light or dark appearance.
    public static func token(_ pair: Pair) -> Color {
        #if canImport(AppKit)
        return Color(nsColor: NSColor(name: nil) { appearance in
            let dark = appearance.bestMatch(from: [.darkAqua, .aqua]) != .aqua
            return nsColor(dark ? pair.dark : pair.light)
        })
        #elseif canImport(UIKit)
        return Color(uiColor: UIColor { traits in
            uiColor(traits.userInterfaceStyle == .light ? pair.light : pair.dark)
        })
        #else
        return solid(pair.dark)
        #endif
    }

    #if canImport(AppKit)
    public static func nsColor(_ v: UInt32) -> NSColor {
        NSColor(srgbRed: CGFloat((v >> 16) & 0xFF) / 255, green: CGFloat((v >> 8) & 0xFF) / 255, blue: CGFloat(v & 0xFF) / 255, alpha: 1)
    }
    #elseif canImport(UIKit)
    public static func uiColor(_ v: UInt32) -> UIColor {
        UIColor(red: CGFloat((v >> 16) & 0xFF) / 255, green: CGFloat((v >> 8) & 0xFF) / 255, blue: CGFloat(v & 0xFF) / 255, alpha: 1)
    }
    #endif
}

/// Spacing and corner radii on a 4 pt grid.
public enum SignalSpace {
    public static let s1: CGFloat = 4, s2: CGFloat = 8, s3: CGFloat = 12, s4: CGFloat = 16, s5: CGFloat = 20, s6: CGFloat = 24
    public static let rSM: CGFloat = 4, rMD: CGFloat = 6, rLG: CGFloat = 10
}
