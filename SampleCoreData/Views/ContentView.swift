//
//  ContentView.swift
//  SampleCoreData
//
//  Created by Federico on 18/02/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(food) { food in
                        VStack(alignment: .leading) {
                            Text(food.name!)
                                .bold()
                            Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                            Text("\(Int(-food.date!.timeIntervalSinceNow)/60) minutes ago")
                        }
                        .onTapGesture {
                            // Edit item in here
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add food", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            
            try? managedObjContext.save()
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
