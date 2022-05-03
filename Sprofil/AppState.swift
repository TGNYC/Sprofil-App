//
//  AppState.swift
//  Memorize
//
//  Created by Tejas Gupta on 5/3/22.
//

import Foundation
// AppState.swift

final class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}
