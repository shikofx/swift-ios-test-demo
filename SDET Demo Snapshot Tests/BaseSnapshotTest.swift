import XCTest
import SnapshotTesting

class BaseSnapshotTest: XCTestCase {
    
    override func setUp() {
        // Make active to record snapshots
//       isRecording = true
    }
    
    // Define all the configurations we need in one place
    let lightModeConfigs: [String: ViewImageConfig] = [
        // Using more common device configurations for better compatibility
        "iPhoneX": .iPhoneX,
        "iPhoneSE_Portrait": .iPhoneSe(.portrait),
        "iPadPro11_Portrait": .iPadPro11(.portrait)
    ]

    let darkModeConfig: (name: String, config: ViewImageConfig) = ("iPhoneX_DarkMode", .iPhoneX)

    /// Helper function that takes snapshots for all configurations
    func assertSnapshots<Value>(
        of value: Value,
        as snapshotting: Snapshotting<Value, UIImage>,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let className = fileURL.deletingPathExtension().lastPathComponent

        // Snapshots for light mode
        lightModeConfigs.forEach { name, config in
            assertSnapshot(
                of: value as! UIViewController,
                as: .image(on: config),
                named: "\(className).\(name)",
                file: file,
                testName: testName,
                line: line
            )
        }

        // Snapshot for dark mode
        assertSnapshot(
            of: value as! UIViewController,
            as: .image(on: darkModeConfig.config, traits: .init(userInterfaceStyle: .dark)),
            named: "\(className).\(darkModeConfig.name)",
            file: file,
            testName: testName,
            line: line
        )
    }
}
