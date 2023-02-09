//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 08.02.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

// MARK: - Comparable

extension GameRecord: Comparable {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.correct < rhs.correct
    }
}
