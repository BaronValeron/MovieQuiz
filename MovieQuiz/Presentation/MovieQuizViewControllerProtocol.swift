//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Валерий on 06.03.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func enableButton()
    func disableButton()
}
