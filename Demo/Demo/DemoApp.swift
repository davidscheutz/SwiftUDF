//
//  DemoApp.swift
//  Demo
//
//  Created by David's MBP16 on 09.06.24.
//

import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView.create(using: CounterLoop())
        }
    }
}
