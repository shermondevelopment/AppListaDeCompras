//
//  ContentView.swift
//  ListaDeCompraIos
//
//  Created by VITOR SHERMON on 23/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: Product.nameSort) private var items: [Product]
    
    @State private var newItem: String = ""
    @State private var showDuplicateItemAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Lista de Compra")
                .font(.largeTitle)
                .bold()
            
            HStack {
                TextField("Adicionar Item", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .onSubmit(addItem)
                Button(action: {
                    addItem()
                }, label: {
                    Label("Adicionar", systemImage: "plus.circle.fill")
                })
                .buttonStyle(.borderedProminent)
                .disabled(newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            List(items) { item in
                Button {
                    toggle(item)
                } label: {
                    HStack {
                        Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.completed ? .green : .gray).font(.title3)
                        
                        Text(item.name).foregroundColor(item.completed ? .secondary : .primary).font(.title3)
                            .strikethrough(item.completed, color: .secondary)
                            .lineLimit(2)
                    }
                }.swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete(id: item.id)
                    } label: {
                        Label("Excluir", systemImage: "trash")
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showDuplicateItemAlert) {
            Alert(title: Text("Item já existe"), message: Text("Este item já está na lista"), dismissButton: .default(Text("Ok")))
        }
    }
    
    private func toggle(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.id == product.id }) else {
            return
        }
        do {
           items[index].completed.toggle()
           try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
    
    private func addItem() {
        
        let itemTrimmed = newItem
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !itemTrimmed.isEmpty else {
            return
        }
        
        let productExist = items.first { $0.name == newItem }
        
        if productExist != nil {
            self.showDuplicateItemAlert.toggle()
            return
        }
        
        let product = Product(
            name: itemTrimmed,
            completed: false
        )
        
        modelContext.insert(product)
        do {
            try modelContext.save()
            newItem = ""
        } catch {
            modelContext.rollback()
            print("deu erro aqui")
        }

    }
    
    private func delete(id: UUID) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        
        modelContext.delete(item)
        
        do {
            try modelContext.save()
        } catch {
           print("Não foi possível deletar item")
        }
    }
    
}

#Preview {
    ContentView().modelContainer(for: Product.self, inMemory: true)
}
