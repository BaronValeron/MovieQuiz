//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Валерий on 04.03.2025.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    let questionsAmount = 10
    var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenter?
    private var statisticService = StatisticService()
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        questionFactory?.delegate = self
        
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == isYes
        proceedWithAnswer(isCorrect: isCorrect)
    }
    
    func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let result = AllertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers)/\(questionsAmount)\n" +
                         "Количество сыгранных квизов: \(statisticService.gamesCount)\n" +
                         "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n" +
                "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%",
                buttonText: "Сыграть еще раз",
                completion: newGame)
            alertPresenter?.showAlert(model: result)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func newGame(_ : UIAlertAction) {
        resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let networkError = AllertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] _ in
                guard let self else { return }
                self.viewController?.showLoadingIndicator()
                self.questionFactory?.loadData()
            }
        alertPresenter?.showAlert(model: networkError)
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        viewController?.disableButton()
        
        correctAnswers += isCorrect ? 1 : 0
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.proceedToNextQuestionOrResults()
            self.viewController?.enableButton()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadImage() {
        let networkError = AllertModel(
            title: "Ошибка",
            message: "Не удалось загрузить постер фильма",
            buttonText: "Попробовать еще раз") { [weak self] _ in
                guard let self else { return }
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.showAlert(model: networkError)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
