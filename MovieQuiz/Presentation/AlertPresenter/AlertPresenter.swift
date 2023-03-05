//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 03.02.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    // Dependencies
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialize
    
    init(transitionHandler: UIViewController) {
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - AlertPresenterProtocol
    
    func show(alertModel: AlertModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .cancel) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        transitionHandler?.present(alert, animated: true)
    }
}
