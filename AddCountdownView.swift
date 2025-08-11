//
//  AddCountdownView.swift
//  countify
//
//  Created by Ye Zonglin Isaac on 2/8/25.
//

import SwiftUI
import UserNotifications

struct AddCountdownView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var date = Date().addingTimeInterval(60) // default 1 minute from now
    @State private var description = ""
    @State private var notificationsEnabled = false
    
    // Selected days for notifications, 1=Mon ... 7=Sun
    @State private var selectedDays: Set<Int> = []
    @State private var notificationTime: Date = Date()  // Time of day for notifications
    
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]

    var onAdd: (CountdownItem) -> Void

    var body: some View {
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
            
            Section {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                
                if notificationsEnabled {
                    // Weekday selector bar
                    HStack(spacing: 12) {
                        ForEach(1...7, id: \.self) { index in
                            let dayLabel = weekDays[index - 1]
                            Button(action: {
                                toggleDay(index)
                            }) {
                                Text(dayLabel)
                                    .fontWeight(selectedDays.contains(index) ? .bold : .regular)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(selectedDays.contains(index) ? .white : .primary)
                                    .background(selectedDays.contains(index) ? Color.blue : Color(UIColor.systemGray5))
                                    .cornerRadius(15)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    
                    // Time picker for notification time
                    DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .padding(.top, 8)
                }
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
                        createdDate: Date(),
                        notificationsEnabled: notificationsEnabled,
                        notificationDays: Array(selectedDays).sorted(),
                        notificationTime: notificationTime
                    )
                    
                    if newCountdown.notificationsEnabled {
                        requestNotificationPermission()
                        scheduleNotifications(for: newCountdown)
                    }
                    
                    onAdd(newCountdown)
                    dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    private func toggleDay(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notifications permission granted")
            } else {
                print("Notifications permission denied")
            }
        }
    }
    
    func scheduleNotifications(for countdown: CountdownItem) {
        let center = UNUserNotificationCenter.current()
        
        // Remove previous notifications with this countdown's id
        for weekday in countdown.notificationDays {
            center.removePendingNotificationRequests(withIdentifiers: ["\(countdown.id.uuidString)-\(weekday)"])
        }
        
        guard countdown.notificationsEnabled else { return }
        
        for weekday in countdown.notificationDays {
            var dateComponents = DateComponents()
            
            // Your weekdays: 1=Mon, 7=Sun
            // iOS weekday: 1=Sun, 2=Mon, ..., 7=Sat
            let iosWeekday = (weekday % 7) + 1
            dateComponents.weekday = iosWeekday
            
            let calendar = Calendar.current
            let timeComponents = calendar.dateComponents([.hour, .minute], from: countdown.notificationTime)
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            
            let content = UNMutableNotificationContent()
            content.title = countdown.title
            content.body = countdown.description ?? "Countdown Reminder"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "\(countdown.id.uuidString)-\(weekday)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    }
}
