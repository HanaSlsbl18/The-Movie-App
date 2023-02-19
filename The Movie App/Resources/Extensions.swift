//
//  Extension.swift
//  The Movies App
//
//  Created by Hana Salsabila on 17/02/23.
//

import Foundation

extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
