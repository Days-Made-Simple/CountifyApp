//
//  AddCountdownView.swift
//  countify
//
//  Created by Ye Zonglin Isaac on 2/8/25.
//


import SwiftUI

struct AddCountdownView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var date = Date().addingTimeInterval(60) // default to 1 minute from now
    @State private var description = ""

    var onAdd: (CountdownItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter countdown title", text: $title)
                }
                
                Section(header: Text("Event Date")) {
                    DatePicker("Select date & time", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Description (optional)")) {
                    TextField("Enter description", text: $description)
                }
            }
            .navigationTitle("New Countdown")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newCountdown = CountdownItem(
                            id: UUID(),
                            title: title,
                            date: date,
                            description: description.isEmpty ? nil : description,
                            createdDate: Date()
                        )
                        onAdd(newCountdown)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CountdownView()
}
