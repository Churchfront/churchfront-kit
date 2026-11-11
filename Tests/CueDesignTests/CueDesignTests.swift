import XCTest
@testable import CueDesign

final class CueDesignTests: XCTestCase {
    /// The dark ramp is the agreed neutral grey ramp (2026-11-10). Changing it changes every Cue app.
    func testDarkRampIsNeutralGrey() {
        let ramp: [(String, UInt32)] = [
            ("bg", SignalColor.Hex.bg.dark), ("surface", SignalColor.Hex.surface.dark),
            ("toolbar", SignalColor.Hex.toolbar.dark), ("header", SignalColor.Hex.header.dark),
            ("surfaceRaised", SignalColor.Hex.surfaceRaised.dark), ("surfaceSunken", SignalColor.Hex.surfaceSunken.dark),
            ("line", SignalColor.Hex.line.dark), ("lineStrong", SignalColor.Hex.lineStrong.dark),
            ("inkMuted", SignalColor.Hex.inkMuted.dark), ("inkSubtle", SignalColor.Hex.inkSubtle.dark),
        ]
        for (name, v) in ramp {
            let r = (v >> 16) & 0xFF, g = (v >> 8) & 0xFF, b = v & 0xFF
            XCTAssertTrue(r == g && g == b, "\(name) is tinted: \(String(v, radix: 16))")
        }
        XCTAssertEqual(SignalColor.Hex.bg.dark, 0x121212)
        XCTAssertEqual(SignalColor.Hex.surface.dark, 0x1C1C1C)
        XCTAssertEqual(SignalColor.Hex.accentSoft.dark, 0x2B3A45)
    }

    func testFigtreeRegisters() {
        XCTAssertTrue(SignalFont.register())
    }
}
