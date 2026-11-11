// swift-tools-version:5.9
import PackageDescription

// CueKit: the code the Cue apps share (CueScreens, CueStack, CueTracks,
// CueLights, CueVideo, CueCharts). Each app pins a tagged version.
let package = Package(
    name: "CueKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "CueDesign", targets: ["CueDesign"]),
        .library(name: "CueNDI", targets: ["CueNDI"]),
    ],
    targets: [
        // Signal colours (neutral grey ramp), spacing, Figtree and shared controls.
        .target(
            name: "CueDesign",
            resources: [.copy("Resources/Figtree-VariableFont_wght.ttf")]
        ),
        // NDI in and out, loading the runtime at run time (no SDK needed to build).
        .target(name: "CueNDI"),
        .testTarget(name: "CueDesignTests", dependencies: ["CueDesign"]),
    ]
)
