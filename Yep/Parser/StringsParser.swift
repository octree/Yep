//
//  StringsParser.swift
//  Yep
//
//  Created by Octree on 2019/7/5.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

public class Parser {
    /// current position
    var pos: Int = 0
    /// source code
    var input: ContiguousArray<Character>
    /// is current position end of file
    var eof: Bool {
        return pos >= input.count
    }

    public init(input: String) {
        self.input = ContiguousArray(input)
    }

    func parse() throws -> [(String, String)] {
        var result = [(String, String)]()
        while !eof {
            try skip()
            if eof {
                break
            } else if startWith("\"") {
                try result.append(parsePair())
            } else {
                throw ParseError.notMatch
            }
        }
        return result
    }
}

public extension Parser {
    func startWith(_ str: String) -> Bool {
        guard str.count <= input.count - pos else { return false }
        let list = ContiguousArray(str)
        for (offset, ch) in list.enumerated() {
            if ch != input[offset + pos] { return false }
        }
        return true
    }

    func nextChar() -> Character {
        return input[pos]
    }

    @discardableResult
    func consumeChar() -> Character {
        defer {
            pos += 1
        }
        return input[pos]
    }

    func consumeWhiteSpace() {
        consumeWhile { $0.isWhitespace }
    }

    func parsePair() throws -> (String, String) {
        try skip()
        let key = try parseString()
        try skip()
        try eat("=")
        try skip()
        let val = try parseString()
        try skip()
        try eat(";")
        return (key, val)
    }

    func skip() throws {
        while !eof {
            if nextChar().isWhitespace {
                consumeWhiteSpace()
            } else if startWith("//") {
                try skipSingleLineComment()
            } else if startWith("/*") {
                try skipMultiLineComment()
            } else {
                return
            }
        }
    }

    @discardableResult
    func consumeWhile(_ test: (Character) -> Bool) -> String {
        var chars = [Character]()
        while !eof, test(nextChar()) {
            chars.append(consumeChar())
        }
        return String(chars)
    }

    func eat(_ text: String) throws {
        guard startWith(text) else {
            throw ParseError.notMatch
        }
        (0 ..< text.count).forEach { _ in consumeChar() }
    }

    func parseString() throws -> String {
        try eat("\"")
        var chs = [Character]()
        while !eof, nextChar() != "\"" {
            if nextChar() == "\\" {
                consumeChar()
                if !eof {
                    try chs.append(escaped(consumeChar()))
                }
            } else {
                chs.append(consumeChar())
            }
        }
        try eat("\"")
        return String(chs)
    }

    func skipMultiLineComment() throws {
        try eat("/*")
        consumeWhile { _ in !self.startWith("*/") }
        try eat("*/")
    }

    func skipSingleLineComment() throws {
        try eat("//")
        consumeWhile { !$0.isNewline }
    }

    private func escaped(_ char: Character) throws -> Character {
        switch char {
        case "\"":
            return "\""
        case "\'":
            return "\'"
        case "n":
            return "\n"
        case "t":
            return "\t"
        case "\\":
            return "\\"
        default:
            throw ParseError.notMatch
        }
    }
}

extension Parser {
    func parseToTree() throws -> Namespace {
        let root = Namespace(name: "I18n")
        root.isRoot = true
        let result = try parse()
        for (key, _) in result {
            let components = key.split(separator: ".").map { String($0) }
            let name = components.last!
            let namespace = root.findOrCreateNamespace(for: components.dropLast())
            namespace.assets.append(.init(name: name, type: .string))
        }
        return root
    }
}
