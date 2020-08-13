//
//  EmojiHelper.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/13/20.
//

import Foundation

enum iconPresets: String, CaseIterable, Codable {
    case 👨🏻‍💻, 🍩, 📱, 🍕, 🌊, 🏀, 📚, 🏔, 🥂, 🍟
    var id: String { name }
    var name: String { rawValue.lowercased() }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    
    func getFirst() -> String {
        
        guard self != "" else {
            return self
        }
        
        return String(self.strip[self.strip.index(before: startIndex)])
    }
    
    func getLast() -> String {
        
        guard self.strip != "" else {
            return ""
        }
        
        return String(self.strip[self.strip.index(before: endIndex)])
    }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
}

struct RandomEmoji {
    
    var emoji: String = ""
    var name: String = ""
    
    init(from icon: String = "", default defaultName: String = "random emoji", suffix: String = "") {
        
        self.emoji = icon.containsOnlyEmoji ? icon : getRandomEmoji()
        self.name = getEmojiName(of: emoji, default: defaultName, suffix: suffix)
    }
    
    private func getRandomEmoji() -> String {
        return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
    }
    
    private func getEmojiName(of icon: String, default defaultName: String = "NoName", suffix: String = "") -> String {
        
        var emojiName: String? = icon
        
        for scalar in self.emoji.unicodeScalars {
            emojiName = (scalar.properties.name?.capitalized ?? defaultName)
        }
        
        return (emojiName ?? defaultName) + (suffix == "" ? suffix : " "+suffix )
    }
}
