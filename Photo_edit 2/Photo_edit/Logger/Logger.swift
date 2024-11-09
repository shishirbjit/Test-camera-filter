//
//  Logger.swift
//  Photo_edit
//
//  Created by 10791-Zulfiker-Ali on 9/11/24.
//

import Foundation

final class Logger {
    // Singleton instance
    static let shared = Logger()
    
    private let fileManager = FileManager.default
    private let dateFormatter: DateFormatter
    private let logFileName = "app.log"
    private var logFileURL: URL?
    
    private init() {
        // Setup date formatter for timestamps
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        // Setup log file URL
        if let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            logFileURL = documentsPath.appendingPathComponent(logFileName)
            createLogFileIfNeeded()
        }
    }
    
    private func createLogFileIfNeeded() {
        guard let logFileURL = logFileURL,
              !fileManager.fileExists(atPath: logFileURL.path) else { return }
        
        fileManager.createFile(atPath: logFileURL.path, contents: nil)
    }
    
    // Main logging methods
    func log(_ message: String, level: LogLevel = .info, fileName: String = #file, line: Int = #line, function: String = #function) {
        let timestamp = dateFormatter.string(from: Date())
        let fileNameWithoutPath = (fileName as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(fileNameWithoutPath):\(line)] \(function): \(message)\n"
        
        writeToFile(logMessage)
        
        #if DEBUG
        print(logMessage)
        #endif
    }
    
    private func writeToFile(_ message: String) {
        guard let logFileURL = logFileURL,
              let data = message.data(using: .utf8) else { return }
        
        if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            try? fileHandle.close()
        }
    }
    
    // Clear logs
    func clearLogs() {
        guard let logFileURL = logFileURL else { return }
        try? fileManager.removeItem(at: logFileURL)
        createLogFileIfNeeded()
    }
    
    // Get logs content
    func getLogs() -> String? {
        guard let logFileURL = logFileURL else { return nil }
        return try? String(contentsOf: logFileURL, encoding: .utf8)
    }
}

// Log levels enum
enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}
