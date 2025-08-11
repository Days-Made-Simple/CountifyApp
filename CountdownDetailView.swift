//
//  CountdownDetailView.swift
//  countify
//
//  Created by Ye Zonglin Isaac on 2/8/25.
//


import SwiftUI

struct CountdownDetailView: View {
    let countdown: CountdownItem
    var body: some View {
        VStack {
            Text("Detail for \(countdown.title)")
                .font(.largeTitle)
                .padding()
            Text("Event Date: \(countdown.date.formatted(date: .long, time: .shortened))")
                .padding()
            if let desc = countdown.description {
                Text(desc)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle("Countdown Detail")
    }
}

#Preview {
    CountdownView()
}
