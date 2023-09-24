//
//  ConsoleLogger.swift
//  Prom
//
//  Created by Дмитрий Пащенко on 19.08.2020.
//  Copyright © 2020 UAProm. All rights reserved.
//

import Foundation

public final class ConsoleLogger: Logger {
    public init() { }
    
	// MARK: - Public methods
    public func log(
        level: Log.Level,
        message: String,
        params: [String: Any]?,
        functionName: String,
        lineNum: Int,
        fileName: String
    ) {
		let symbol = level.symbol
		
		var result = ""
		result += "\(symbol) "
		result += "\(logDate) \(level.description) "
		result += "\(fileName)->\(functionName):\(lineNum) "
		result += "\(symbol)"
		result += "\n\t"
		
		result += message
		
		params?.forEach { key, value in
			result += "\n    \(key): \(value)"
		}
		
		result += "\n"
		
		print(result)
	}
}

fileprivate extension Log.Level {
    var symbol: String {
        switch self {
        case .error:
            return "❤️"
        case .warning:
            return "💛"
        case .info:
            return "💜"
        case .debug:
            return "💙"
        }
    }
}
