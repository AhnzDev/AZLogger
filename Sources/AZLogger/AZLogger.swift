// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import OSLog

public enum AZLogLevel {
    case debug, info, warning, error, fault, `default`

    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .fault: return .fault
        case .default: return .default
        }
    }

    var symbol: String {
        switch self {
        case .debug: return "🐛"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .fault: return "🔥"
        case .default: return "📌"
        }
    }
}
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)

public final class AZLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.azlogger.default"

}

public enum AZLogDestination {
    case console
    case oslog
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension AZLogger {
    public static func log(_ message: @autoclosure () -> Any,
                           level: AZLogLevel = .debug,
                           category: String = "Default",
                           destination: AZLogDestination = .console,
                           function: String = #function,
                           file: String = #file,
                           line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        let typeName = filename.replacingOccurrences(of: ".swift", with: "")
        let evaluatedMessage = message()
        let location = "\(typeName).\(function):\(line)"
        let text = "[\(level.symbol)] \(location) → \(evaluatedMessage)"

        switch destination {
        case .console:
            print(text)
        case .oslog:
            let logger = Logger(subsystem: subsystem, category: category)
            switch level {
            case .debug: logger.debug("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            case .info: logger.info("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            case .warning: logger.log("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            case .error: logger.error("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            case .fault: logger.fault("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            case .default: logger.log("\(location): \(String(describing: evaluatedMessage), privacy: .public)")
            }
        }
    }
}
