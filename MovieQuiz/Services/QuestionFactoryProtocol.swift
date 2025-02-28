//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Валерий on 02.02.2025.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
    func loadData()
}
