//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Валерий on 02.02.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage()
}
