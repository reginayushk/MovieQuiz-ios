//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 02.02.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
