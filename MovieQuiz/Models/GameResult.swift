//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Валерий on 14.02.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        let accuracy = total > 0 ? Double(correct) / Double(total) : 0
        let anotherAccuracy = another.total > 0 ? Double(another.correct) / Double(another.total) : 0
        return accuracy > anotherAccuracy
    }
}
