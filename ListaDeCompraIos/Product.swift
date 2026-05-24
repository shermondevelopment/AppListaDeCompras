//
//  Product.swift
//  ListaDeCompraIos
//
//  Created by VITOR SHERMON on 23/05/26.
//
import Foundation
import Playgrounds
import SwiftData

@Model
class Product: Identifiable {
    var id: UUID = UUID()
    var name: String
    var completed: Bool
    
    init(name: String, completed: Bool = false) {
        self.name = name
        self.completed = completed
    }
}

extension Product {
    static var nameSort: [SortDescriptor<Product>] {
        [SortDescriptor(\.name, order: .forward)]
    }
}

#Playground {
    let product = Product(name: "Arroz", completed: false)
    print(product)
}
