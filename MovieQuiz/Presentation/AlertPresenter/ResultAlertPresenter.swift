//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 09.02.2023.
//

import Foundation

final class ResultAlertPresenter: ResultAlertPresenterProtocol {
    
    // Dependencies
    private let alertPresenter: AlertPresenterProtocol
    private let statisticService: StatisticService
    
    // MARK: - Initialize
    
    init(alertPresenter: AlertPresenterProtocol, statisticService: StatisticService) {
        self.alertPresenter = alertPresenter
        self.statisticService = statisticService
    }
    
    // MARK: - ResultAlertPresenterProtocol
    
    func show(resultAlertModel: ResultAlertModel) {
        let bestGame = statisticService.bestGame
        
        let message = "Ваш результат: \(resultAlertModel.correctAnswers)/\(resultAlertModel.questionsAmount)\n"
        + "Количество сыгранных квизов: \(statisticService.gamesCount)\n"
        + "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)\n"
        + "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз") {
                resultAlertModel.completion()
            }
        
        alertPresenter.show(alertModel: alertModel)
    }
}
