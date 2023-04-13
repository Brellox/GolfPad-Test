//
//  MainPresenter.swift
//  GolfPad-Test
//
//  Created by Иван Суслов on 13.04.2023.
//

import Foundation

class MainPresenter{
    
    private let constantValue: Double = 113
    
    let message = "Please, enter correct information"
    
    func calculateTheHandicap (index: String?, rating: String?) -> (String)? {
        
        if let index = index, let rating = rating {
            if let i = Double (index), let r = Double (rating) {
                let result = i * r / constantValue
                return String(format: "%.1f", floor(result * 10) / 10) + " (\(lround (result)))" 
            }
        }
        return nil
    }
}
