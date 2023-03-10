//
//  PresenterTests.swift
//  MovieQuizTests
//
//  Created by Regina Yushkova on 05.03.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: UIViewController, MovieQuizViewControllerProtocol {
    
    var showQuizStepModel: QuizStepViewModel?
    
    func show(quiz step: QuizStepViewModel) {
        showQuizStepModel = step
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    
    var viewControllerMock: MovieQuizViewControllerMock!
    var sut: MovieQuizPresenter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        viewControllerMock = MovieQuizViewControllerMock()
        sut = MovieQuizPresenter(viewController: viewControllerMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        viewControllerMock = nil
        sut = nil
    }
    
    func testPresenterConvertModel() throws {
        // Given
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        // When
        let viewModel = sut.convert(model: question)
        
        // Then
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testPresenterDidReceiveNextQuestion() throws {
        // Given
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        sut.didReceiveNextQuestion(question: question)
        DispatchQueue.main.async { expectation.fulfill() }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(viewControllerMock.showQuizStepModel)
    }
    
    func testPresenterSwitchToNextQuestionAndIsLastQuestion() throws {
        // When
        for _ in 0..<9 {
            sut.switchToNextQuestion()
        }
        let isLastQuestion = sut.isLastQuestion()
        
        // Then
        XCTAssertTrue(isLastQuestion)
    }
    
    func testPresenterFailureSwitchToNextQuestionAndIsLastQuestion() throws {
        // When
        let range = 0..<9
        for _ in 0..<(range.randomElement() ?? 0) {
            sut.switchToNextQuestion()
        }
        let isLastQuestion = sut.isLastQuestion()
        
        // Then
        XCTAssertFalse(isLastQuestion)
    }
    
    func testPresenterRestartGame() throws {
        // When
        for _ in 0..<9 {
            sut.switchToNextQuestion()
        }
        let isLastQuestionPreRestart = sut.isLastQuestion()
        sut.restartGame()
        let isLastQuestionPostRestart = sut.isLastQuestion()
        
        // Then
        XCTAssertTrue(isLastQuestionPreRestart)
        XCTAssertFalse(isLastQuestionPostRestart)
    }
}
