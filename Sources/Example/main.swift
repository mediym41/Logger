//
//  File.swift
//  
//
//  Created by Дмитрий Пащенко on 24.09.2023.
//

import Logger

// Inject out loggers to core class
Log.loggers = [ConsoleLogger(), FileLogger(fileName: "logs")]

func run() {
    Log.debug(message: "Debug message")
    Log.info(message: "Info message")
    Log.warning(message: "Warning message", params: ["id": 102, "kind": "test"])
    Log.error(message: "Error message")
}

run()

// Results:

/*
 
💙 2023-09-24 16:02:18.814 DEBUG main->run():14 💙
    Debug message

💜 2023-09-24 16:02:18.816 INFO main->run():15 💜
    Info message

💛 2023-09-24 16:02:18.817 WARNING main->run():16 💛
    Warning message
    id: 102
    kind: test

❤️ 2023-09-24 16:02:18.817 ERROR main->run():17 ❤️
    Error message

*/
