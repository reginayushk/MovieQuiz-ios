//
//  ResultAlertModel.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 09.02.2023.
//

import Foundation

struct ResultAlertModel {
    let correctAnswers: Int
    let questionsAmount: Int
    let completion: () -> Void
}
