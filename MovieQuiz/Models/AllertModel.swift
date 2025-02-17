//
//  AllertModel.swift
//  MovieQuiz
//
//  Created by Валерий on 02.02.2025.
//

import Foundation
import UIKit

struct AllertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (UIAlertAction) -> Void
}
