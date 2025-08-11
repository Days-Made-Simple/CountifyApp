//
//  countifyApp.swift
//  countify
//
//  Created by Ye Zonglin Isaac on 2/8/25.
//

import SwiftUI

@main
struct countifyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CountdownView()
            }
        }
    }
}
