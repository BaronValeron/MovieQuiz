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
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == true
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func noButtonClicked() {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == false
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}
