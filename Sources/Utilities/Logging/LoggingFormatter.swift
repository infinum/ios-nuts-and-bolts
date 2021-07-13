//
//  LoggingFormatter.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//  Idea taken from: https://github.com/SwiftyBeaver/SwiftyBeaver
//

import Foundation
import os

// MARK: - Print -

enum LoggingFormatter {

    /// Returns the current thread name.
    static var threadName: String {
        if Thread.isMainThread {
            return ""
        } else {
            let threadName = Thread.current.name
            if let threadName = threadName, !threadName.isEmpty {
                return threadName
            } else {
                return String(format: "%p", Thread.current)
            }
        }
    }

    /// Internal helper which prepares and prints message
    static func prepareAndPrint(
        for level: LogConfigurator.Level,
        message: @autoclosure () -> Any,
        thread: String = threadName,
        file: String,
        function: String,
        line: Int,
        context: Any?,
        category: OSLog? = nil
    ) {

        guard let configurator = Log.configurator else { return }

        let function = stripParams(function: function)
        let message = formatMessage(
            configurator.format,
            level: level,
            msg: "\(message())",
            thread: thread,
            file: file,
            function: function,
            line: line,
            context: context
        )

        guard configurator.isLoggingEnabled else { return }

        if let category = category {
            os_log("%{public}s", log: category, type: level.osLogType, message)
        } else {
            os_log("%{public}s", type: level.osLogType, message)
        }
    }
}

// MARK: - Format -

private extension LoggingFormatter {

    /// Returns the log message based on the format pattern.
    // swiftlint:disable:next cyclomatic_complexity
    static func formatMessage(
        _ format: String,
        level: LogConfigurator.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String {

        var text = ""
        // Prepend a $I for 'ignore' or else the first character is interpreted as a format character
        // even if the format string did not start with a $.
        let phrases: [String] = ("$I" + format).components(separatedBy: "$")

        for phrase in phrases where !phrase.isEmpty {
            let (padding, offset) = parsePadding(phrase)
            let formatCharIndex = phrase.index(phrase.startIndex, offsetBy: offset)
            let formatChar = phrase[formatCharIndex]
            let rangeAfterFormatChar = phrase.index(formatCharIndex, offsetBy: 1)..<phrase.endIndex
            let remainingPhrase = phrase[rangeAfterFormatChar]

            switch formatChar {
            case "I":  // ignore
                text += remainingPhrase
            case "L":
                text += paddedString(level.stringRepresentation, padding) + remainingPhrase
            case "M":
                text += paddedString(msg, padding) + remainingPhrase
            case "T":
                text += paddedString(thread, padding) + remainingPhrase
            case "N":
                // name of file without suffix
                let fileName = fileNameWithoutSuffix(file)
                let remainingPhrase = fileName.isBlank ? "" : remainingPhrase
                text += paddedString(fileName, padding) + remainingPhrase
            case "n":
                // name of file with suffix
                let fileName = fileNameOfFile(file)
                let remainingPhrase = fileName.isBlank ? "" : remainingPhrase
                text += paddedString(fileName, padding) + remainingPhrase
            case "F":
                text += paddedString(function, padding) + remainingPhrase
            case "l":
                text += paddedString(String(line), padding) + remainingPhrase
            case "D":
                // start of datetime format
                text += paddedString(formatDate(String(remainingPhrase)), padding)
            case "d":
                text += remainingPhrase
            case "Z":
                // start of datetime format in UTC timezone
                text += paddedString(formatDate(String(remainingPhrase), timeZone: "UTC"), padding)
            case "z":
                text += remainingPhrase
            case "X":
                // add the context
                if let cx = context {
                    text += paddedString(String(describing: cx).trimmingCharacters(in: .whitespacesAndNewlines), padding) + remainingPhrase
                } else {
                    text += paddedString("", padding) + remainingPhrase
                }
            default:
                text += phrase
            }
        }
        // right trim only
        return text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }

    /// returns the filename without suffix (= file ending) of a path
    static func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)
        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }

    /// returns the filename of a path
    static func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }

    /// returns a formatted date string
    /// optionally in a given abbreviated timezone like "UTC"
    static func formatDate(_ dateFormat: String, timeZone: String = "") -> String {

        guard let configurator = Log.configurator else { return "" }

        if !timeZone.isEmpty {
            configurator.formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        configurator.formatter.dateFormat = dateFormat
        // let dateStr = formatter.string(from: NSDate() as Date)
        let dateStr = configurator.formatter.string(from: Date())
        return dateStr
    }

    /// returns (padding length value, offset in string after padding info)
    static func parsePadding(_ text: String) -> (Int, Int) {
        // look for digits followed by a alpha character
        var string: String!
        var sign: Int = 1
        if text.first == "-" {
            sign = -1
            string = String(text.suffix(from: text.index(text.startIndex, offsetBy: 1)))
        } else {
            string = text
        }
        let numStr = string.prefix { $0 >= "0" && $0 <= "9" }
        if let num = Int(String(numStr)) {
            return (sign * num, (sign == -1 ? 1 : 0) + numStr.count)
        } else {
            return (0, 0)
        }
    }

    static func paddedString(_ text: String, _ toLength: Int, truncating: Bool = false) -> String {
        if toLength > 0 {
            // Pad to the left of the string
            if text.count > toLength {
                // Hm... better to use suffix or prefix?
                return truncating ? String(text.suffix(toLength)) : text
            } else {
                return "".padding(toLength: toLength - text.count, withPad: " ", startingAt: 0) + text
            }
        } else if toLength < 0 {
            // Pad to the right of the string
            let maxLength = truncating ? -toLength : max(-toLength, text.count)
            return text.padding(toLength: maxLength, withPad: " ", startingAt: 0)
        } else {
            return text
        }
    }

    /// removes the parameters from a function because it looks weird with a single param
    static func stripParams(function: String) -> String {
        var tempFunction = function
        if let indexOfBrace = tempFunction.firstIndex(of: "(") {
            tempFunction = String(tempFunction[..<indexOfBrace])
        }
        tempFunction += "()"
        return tempFunction
    }
}
