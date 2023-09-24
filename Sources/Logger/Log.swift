//
//  Log.swift
//  Logger
//
//  Created by d.pashchenko on 24.09.2023.
//

import Foundation

/// Implement the `CustomStringConvertible` protocol for the `LoggerMessageType` enum
extension Log.Level: CustomStringConvertible {
    /// Convert a `Log.Level` into a printable format.
    public var description: String {
        switch self {
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
}

/// A logger protocol implemented by Logger implementations. This API is used by Kitura
/// throughout its implementation when logging.
public protocol Logger {

    /// Output a logged message.
    ///
    /// - Parameter type: The type of the message (`LoggerMessageType`) being logged.
    /// - Parameter msg: The message to be logged.
    /// - Parameter functionName: The name of the function invoking the logger API.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     logger API.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      logger API.
    func log(
        level: Log.Level,
        message: String,
        params: [String: Any]?,
        functionName: String,
        lineNum: Int,
        fileName: String
    )
}

public extension Logger {
    var logDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        return formatter.string(from: Date())
    }
}

open class Log {
    /// The type of a particular log message. It is passed with the message to be logged to the
    /// actual logger implementation. It is also used to enable filtering of the log based
    /// on the minimal type to log.
    public enum Level: Int {
        /// Log level type for logging a debugging message.
        case debug
        /// Log level type for logging an informational message.
        case info
        /// Log level type for logging a warning message.
        case warning
        /// Log level type for logging an error message.
        case error
        // Log level type for logging an error message.
    }

    #if DEBUG
    public static var level: Level = .debug
    #else
    public static var level: Level = .info
    #endif

    public static var isEnabled: Bool = true

    /// Instances of the logger. Inject your loggers here
    public static var loggers: [Logger] = []
    
    /// Log a debugging message.
    ///
    /// - Parameter message: The message to be logged.
    /// - Parameter functionName: The name of the function invoking the logger API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     logger API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      logger API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func debug(
        message: @autoclosure () -> String,
        params: [String: Any]? = nil,
        functionName: String = #function,
        lineNum: Int = #line,
        filePath: String = #file
    ) {
        guard isEnabled, isLogging(level: .debug) else { return }

        for logger in loggers {
            logger.log(
                level: .debug,
                message: message(),
                params: params,
                functionName: functionName,
                lineNum: lineNum,
                fileName: filePath.fileName
            )
        }
    }
    
    /// Log an informational message.
    ///
    /// - Parameter message: The message to be logged.
    /// - Parameter functionName: The name of the function invoking the logger API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     logger API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      logger API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func info(
        message: @autoclosure () -> String,
        params: [String: Any]? = nil,
        functionName: String = #function,
        lineNum: Int = #line,
        filePath: String = #file
    ) {
        guard isEnabled, isLogging(level: .info) else { return }

        for logger in loggers {
            logger.log(
                level: .info,
                message: message(),
                params: params,
                functionName: functionName,
                lineNum: lineNum,
                fileName: filePath.fileName
            )
        }
    }

    /// Log a warning message.
    ///
    /// - Parameter message: The message to be logged.
    /// - Parameter functionName: The name of the function invoking the logger API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     logger API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      logger API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func warning(
        message: @autoclosure () -> String,
        params: [String: Any]? = nil,
        functionName: String = #function,
        lineNum: Int = #line,
        filePath: String = #file,
        error: NSError? = nil
    ) {
        guard isEnabled, isLogging(level: .warning) else { return }

        for logger in loggers {
            logger.log(
                level: .warning,
                message: message(),
                params: params,
                functionName: functionName,
                lineNum: lineNum,
                fileName: filePath.fileName
            )
        }
    }

    /// Log an error message.
    ///
    /// - Parameter message: The message to be logged.
    /// - Parameter functionName: The name of the function invoking the logger API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     logger API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      logger API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func error(
        message: @autoclosure () -> String,
        params: [String: Any]? = nil,
        functionName: String = #function,
        lineNum: Int = #line,
        filePath: String = #file
    ) {
        guard isEnabled, isLogging(level: .error) else { return }

        for logger in loggers {
            logger.log(
                level: .error,
                message: message(),
                params: params,
                functionName: functionName,
                lineNum: lineNum,
                fileName: filePath.fileName
            )
        }
    }

    /// Indicates whether a LoggerAPI Logger is configured to log at the specified level.
    ///
    /// - Parameter level: The type of message (`Level`).
    ///
    /// - Returns: A Boolean indicating whether a message of the specified type
    ///           will be logged
    private class func isLogging(level: Level) -> Bool {
        return level.rawValue >= self.level.rawValue
    }
}

public extension String {
    var fileName: String {
        return URL(fileURLWithPath: self)
            .deletingPathExtension()
            .lastPathComponent
    }
}
