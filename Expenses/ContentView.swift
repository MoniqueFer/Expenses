//
//  ContentView.swift
//  Expenses
//
//  Created by Monique Ferrarini on 26/03/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
	var id = UUID()
	let name: String
	let type: String
	let amount: Double
}

@Observable
class Expenses {
	var items = [ExpenseItem]() {
		didSet {
			if let encoded = try?JSONEncoder().encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}
	
	init() {
		if let savedItems = UserDefaults.standard.data(forKey: "Items") {
			if let decodedItems = try?JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
				items = decodedItems
				return
			}
		}
		
		items = []
	}
	
}

struct ContentView: View {
	@State private var expenses = Expenses()
		
	@State private var addNewExpense = false
	
	var body: some View {
		NavigationStack {
			List {
				Section ("Personal") {
					ForEach(expenses.items.filter{$0.type == "Personal"}) { item in
						HStack {
							VStack (alignment: .leading) {
								Text(item.name)
									.font(.headline)
								
								Text(item.type)
							}
							
							Spacer()
							
							Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
								.foregroundStyle (expenseColor(amount: item.amount))
								.font(.title2)
								.fontWeight(expenseFontWeight(amount: item.amount))
							
							
						}
						
						
						
					}
					.onDelete(perform: deleteItem)
				}
				
				Section ("Business") {
					
					ForEach(expenses.items.filter{$0.type == "Business"}) { item in
						HStack {
							VStack (alignment: .leading) {
								Text(item.name)
									.font(.headline)
								
								Text(item.type)
							}
							
							Spacer()
							
							Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
								.foregroundStyle (expenseColor(amount: item.amount))
								.font(.title2)
								.fontWeight(expenseFontWeight(amount: item.amount))
							
							
						}
						
						
						
					}
					.onDelete(perform: deleteItem)
						
					
						
				}
				
			}
			.navigationTitle("Expenses")
			.toolbar {
				Button("Add Expense", systemImage: "plus") {
					addNewExpense = true
				}
			}
		}
		.sheet(isPresented: $addNewExpense) {
			AddView(expenses: expenses)
		}
		
	}
	
	func deleteItem(at offsets: IndexSet) {
		expenses.items.remove(atOffsets: offsets)
		
		
	}
	
	func expenseColor(amount: Double) -> Color {
		if amount <= 10 {
			.green
		} else if amount > 10 && amount < 999 {
			.yellow
		} else {
			.red
		}
	}
	
	func expenseFontWeight(amount: Double) -> Font.Weight {
		if amount <= 10 {
			.regular
		} else if amount > 10 && amount < 999 {
			.medium
		} else {
			.semibold
		}
	}
	
}
		
	

#Preview {
    ContentView()
}
