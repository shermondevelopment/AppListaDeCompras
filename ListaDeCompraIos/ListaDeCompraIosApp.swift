//
//  ListaDeCompraIosApp.swift
//  ListaDeCompraIos
//
//  Created by VITOR SHERMON on 23/05/26.
//

import SwiftUI
import SwiftData

@main
struct ListaDeCompraIosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Product.self)
    }
}
