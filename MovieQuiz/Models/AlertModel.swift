//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 03.02.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
