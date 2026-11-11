import SwiftUI
import CoreText

/// Figtree, bundled in CueKit so apps don't each carry a copy.
public enum CueFont {
    nonisolated(unsafe) public private(set) static var figtreeLoaded = false

    /// Registers Figtree for this process. Call once at launch.
    @discardableResult
    public static func register() -> Bool {
        if figtreeLoaded { return true }
        guard let url = Bundle.module.url(forResource: "Figtree-VariableFont_wght", withExtension: "ttf") else { return false }
        var err: Unmanaged<CFError>?
        let ok = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &err)
        figtreeLoaded = ok || CTFontCreateWithName("Figtree" as CFString, 12, nil).familyName == "Figtree"
        return figtreeLoaded
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
