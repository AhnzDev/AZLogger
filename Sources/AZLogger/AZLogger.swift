// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import OSLog

public enum AZLogLevel {
    case debug, error
    case request, response

    var osLogType: OSLogType {
        switch self {
        case .debug:     return .debug
        case .error:     return .error
        case .request:   return .info
        case .response:  return .info
        }
    }

    var symbol: String {
        switch self {
        case .debug:     return "ℹ️"
        case .error:     return "❌"
        case .request:   return "✈️"  // outgoing
        case .response:  return "🛩️"  // incoming
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
    // MARK: - Console Logger
    public static func azLog(
        _ message: @autoclosure () -> Any,
        level: AZLogLevel = .debug,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let filename = (file as NSString).lastPathComponent
        let typeName = filename.replacingOccurrences(of: ".swift", with: "")
        let evaluatedMessage = message()
        let location = "\(typeName) → \(function):\(line)"
        let text = "[\(level.symbol)] \(location) → \(evaluatedMessage)"
#if DEBUG
        print(text)
#endif
    }
    
    // MARK: - OSLog (swift-log) Logger
    public static func azOsLog(
        _ message: @autoclosure () -> Any,
        level: AZLogLevel = .debug,
        category: String = "debug",
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let filename = (file as NSString).lastPathComponent
        let typeName = filename.replacingOccurrences(of: ".swift", with: "")
        let evaluatedMessage = message()
        let location = "\(typeName)→\(function):\(line)"
        let logger = Logger(subsystem: subsystem, category: category)
        let text = "\(location): \(String(describing: evaluatedMessage))"
        
        switch level {
        case .debug:   logger.debug(  "\(text)")
        case .error:   logger.error(  "\(text)")
        case .request: logger.info(    "\(text)")
        case .response: logger.info(    "\(text)")
        }
    }
}
