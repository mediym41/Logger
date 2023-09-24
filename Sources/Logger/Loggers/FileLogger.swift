//
//  FileLogger.swift
//  Prom
//
//  Created by Дмитрий Пащенко on 19.08.2020.
//  Copyright © 2020 UAProm. All rights reserved.
//

import Foundation

public final class FileLogger: Logger {
   // MARK: - Properties
    public let fileUrl: URL

    // MARK: - Init
    public init(fileName: String) {
        let fileManager: FileManager = .default

        #if targetEnvironment(simulator)
            let simulatorDocumentDirUrl = fileManager.urls(
                for: FileManager.SearchPathDirectory.documentDirectory,
                in: .userDomainMask
            )[0]
            let userRootPathComponents = simulatorDocumentDirUrl.pathComponents.prefix(3).dropFirst()
            self.fileUrl = .init(
                fileURLWithPath: "/" + userRootPathComponents.joined(separator: "/") + "/Documents/" + fileName
            )
        #else
            let documentDirUrl = fileManager.urls(
                for: FileManager.SearchPathDirectory.documentDirectory,
                in: .userDomainMask
            )[0]
            self.fileUrl = documentDirUrl.appendingPathComponent(fileName)
        #endif
        write(text: "\n\n---------- New session ----------\n", to: fileUrl)
    }

    public func log(
        level: Log.Level,
        message: String,
        params: [String: Any]?,
        functionName: String,
        lineNum: Int,
        fileName: String
    ) {
        var result = ""
        result += "\(logDate) \(level.description) "
        result += "\(fileName)->\(functionName) \(lineNum): "

        result += message

        params?.forEach { key, value in
            result += "\n\(key): \(value)"
        }

        result += "\n"

        write(text: result, to: fileUrl)
    }

    private func write(text: String, to fileUrl: URL) {
        if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {
            fileHandle.seekToEndOfFile()

            let data = Data(text.utf8)
            fileHandle.write(data)

            fileHandle.closeFile()
        } else {
            try? text.write(to: fileUrl, atomically: false, encoding: .utf8)
        }
    }

    public func clear() {
        try? FileManager.default.removeItem(at: fileUrl)
    }
}
