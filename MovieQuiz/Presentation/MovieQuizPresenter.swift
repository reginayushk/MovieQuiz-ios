//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Regina Yushkova on 03.03.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    // Dependencies
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol
    private let statisticService: StatisticService
    private let resultAlertPresenter: ResultAlertPresenterProtocol
    private let alertPresenter: AlertPresenterProtocol
    
    // MARK: - Initialize
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        alertPresenter = AlertPresenter(transitionHandler: viewController)
        
        statisticService = StatisticServiceImplementation()
        
        resultAlertPresenter = ResultAlertPresenter(alertPresenter: alertPresenter, statisticService: statisticService)
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        self.questionFactory = questionFactory
        questionFactory.delegate = self
    }
    
    // MARK: - Public Functions
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        didAnswer(isCorrectAnswer: true)
    }
    
    func noButtonClicked() {
        didAnswer(isCorrectAnswer: false)
    }
    
    func fetchData() {
        questionFactory.loadData()
        viewController?.showLoadingIndicator()
    }
    
    // MARK: - Private Functions
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            showResults()
        } else {
            switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isCorrectAnswer
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func showResults() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let resultAlertModel = ResultAlertModel(correctAnswers: correctAnswers, questionsAmount: questionsAmount) { [weak self] in
            guard let self = self else { return }
            self.restartGame()
        }
        
        resultAlertPresenter.show(resultAlertModel: resultAlertModel)
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            
            self.restartGame()
            
            self.fetchData()
        }
        
        alertPresenter.show(alertModel: model)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)
        }
    }
}
