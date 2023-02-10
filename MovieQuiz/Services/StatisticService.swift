//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 08.02.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
    // Dependencies
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    // MARK: - StatisticService
    
    func store(correct count: Int, total amount: Int) {
        let lastGame = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < lastGame {
            bestGame = lastGame
        }
        
        let lastAccuracy = Double(lastGame.correct) / Double(lastGame.total)
        
        totalAccuracy = (totalAccuracy / 100 * Double(gamesCount) + lastAccuracy) / Double(gamesCount+1) * 100
        
        gamesCount += 1
    }
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}
