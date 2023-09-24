//
//  CrashlyticsLogger.swift
//  Real Time Chess
//
//  Created by Дмитрий Пащенко on 24.09.2023.
//

import Logger
import FirebaseCrashlytics

public final class CrashlyticsLogger: Logger {
    private lazy var core: Crashlytics = .crashlytics()
    
    public func log(
        level: Log.Level,
        message: String,
        params: [String : Any]?,
        functionName: String,
        lineNum: Int,
        fileName: String
    ) {
        guard level != .debug else {
            return
        }
        
        switch level {
        case .debug:
            break // ignore
        case .info:
            var result = ""
            result += "\(logDate) \(level.description) "
            result += "\(fileName)->\(functionName):\(lineNum) "
            result += "\n\t"
            
            result += message
            
            params?.forEach { key, value in
                result += "\n    \(key): \(value)"
            }
            
            result += "\n"
            
            core.log(result)
        case .warning, .error:
            core.record(
                error: NSError(
                    domain: "[\(level.description)] \(fileName)->\(functionName):\(lineNum) \(message)",
                    code: -1,
                    userInfo: params
                )
            )
        }
    }
}
