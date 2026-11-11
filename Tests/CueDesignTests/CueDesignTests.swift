import XCTest
@testable import CueDesign

final class CueDesignTests: XCTestCase {
    /// The dark ramp is the agreed neutral grey ramp (2026-11-10). Changing it changes every Cue app.
    func testDarkRampIsNeutralGrey() {
        let ramp: [(String, UInt32)] = [
            ("bg", CueColor.Hex.bg.dark), ("surface", CueColor.Hex.surface.dark),
            ("toolbar", CueColor.Hex.toolbar.dark), ("header", CueColor.Hex.header.dark),
            ("surfaceRaised", CueColor.Hex.surfaceRaised.dark), ("surfaceSunken", CueColor.Hex.surfaceSunken.dark),
            ("line", CueColor.Hex.line.dark), ("lineStrong", CueColor.Hex.lineStrong.dark),
            ("inkMuted", CueColor.Hex.inkMuted.dark), ("inkSubtle", CueColor.Hex.inkSubtle.dark),
        ]
        for (name, v) in ramp {
            let r = (v >> 16) & 0xFF, g = (v >> 8) & 0xFF, b = v & 0xFF
            XCTAssertTrue(r == g && g == b, "\(name) is tinted: \(String(v, radix: 16))")
        }
        XCTAssertEqual(CueColor.Hex.bg.dark, 0x121212)
        XCTAssertEqual(CueColor.Hex.surface.dark, 0x1C1C1C)
        XCTAssertEqual(CueColor.Hex.accentSoft.dark, 0x2B3A45)
    }

    func testFigtreeRegisters() {
        XCTAssertTrue(CueFont.register())
    }
}
