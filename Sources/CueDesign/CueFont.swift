import SwiftUI
import CoreText

/// Figtree, bundled in CueKit so apps don't each carry a copy.
public enum CueFont {
    nonisolated(unsafe) public private(set) static var figtreeLoaded = false

    /// Registers Figtree for this process. Call once at launch.
    @discardableResult
    public static func register() -> Bool {
        if figtreeLoaded { return true }
        guard let url = figtreeURL() else { return false }
        var err: Unmanaged<CFError>?
        let ok = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &err)
        figtreeLoaded = ok || CTFontCreateWithName("Figtree" as CFString, 12, nil).familyName == "Figtree"
        return figtreeLoaded
    }

    /// Finds the font without `Bundle.module`, which crashes when an app's build
    /// script assembles the .app by hand and leaves CueKit's resource bundle out.
    /// Looks in CueKit's bundle (inside the app, beside the binary, or in the
    /// build folder), then in the app's own resources.
    static func figtreeURL() -> URL? {
        let name = "Figtree-VariableFont_wght", ext = "ttf", bundleName = "CueKit_CueDesign.bundle"
        var places: [URL] = []
        if let r = Bundle.main.resourceURL { places.append(r.appendingPathComponent(bundleName)) }
        places.append(Bundle.main.bundleURL.appendingPathComponent(bundleName))
        if let exe = Bundle.main.executableURL { places.append(exe.deletingLastPathComponent().appendingPathComponent(bundleName)) }
        places.append(URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("Resources"))
        for place in places {
            if let b = Bundle(url: place), let url = b.url(forResource: name, withExtension: ext) { return url }
            let direct = place.appendingPathComponent("\(name).\(ext)")
            if FileManager.default.fileExists(atPath: direct.path) { return direct }
        }
        return Bundle.main.url(forResource: name, withExtension: ext)
    }
}

private extension CTFont {
    var familyName: String { CTFontCopyFamilyName(self) as String }
}

public extension Font {
    /// Figtree when registered, the system font otherwise.
    static func cueSans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        CueFont.figtreeLoaded ? .custom("Figtree", size: size).weight(weight) : .system(size: size, weight: weight)
    }
}

public extension View {
    /// ALL CAPS panel label, tracked out.
    func cuePanelLabel(_ color: Color = CueColor.inkSubtle) -> some View {
        font(.cueSans(11, .bold)).tracking(1.4).textCase(.uppercase).foregroundStyle(color).lineLimit(1).fixedSize()
    }
}

/// The small press-down feedback every Cue app uses on its buttons.
public struct CuePressStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.96 : 1).brightness(configuration.isPressed ? 0.08 : 0)
    }
}
