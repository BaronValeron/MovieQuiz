//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Валерий on 04.03.2025.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex = 0
    let questionsAmount = 10
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenter?
    private var statisticService = StatisticService()
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
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
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
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
        viewController?.correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
