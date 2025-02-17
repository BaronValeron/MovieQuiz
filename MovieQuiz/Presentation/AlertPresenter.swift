//
//  AllertPresenter.swift
//  MovieQuiz
//
//  Created by Валерий on 02.02.2025.
//

import Foundation
import UIKit

class AlertPresenter {
    weak var delegate: UIViewController?
    
    func showAlert(model: AllertModel) {
        guard let delegate else { return }
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        alert.addAction(action)
        delegate.present(alert, animated: true, completion: nil)
    }
}
