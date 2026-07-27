//
//  AppLanguage.swift
//  The Vivle
//
//  Created by Lowen on 4/29/26.
//


//
//  AppLanguage.swift
//  The Vivle
//
//  Created by Lowen on 4/29/26.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Español"
        }
    }
}
