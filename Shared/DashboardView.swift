//
//  DashboardView.swift
//  TimeTracker
//
//  Created by zack on 6/20/21.
//

import SwiftUI

struct DashboardView: View {
    @Binding var timestamps: [Timestamp]
    @Binding var currentTime: Date
    
    var body: some View {
        if timestamps.count == 0 {
            Text("Looks like you don't have any timestamps, hit the plus on the top right to make one!")
                .padding()
        } else {
            List(timestamps) { item in
                NavigationLink(destination: DetailView(ts: item)) {
                    HStack() {
                        Text(item.project)
                            .bold()
                            .textCase(.uppercase)
                        Text("•")
                        Text(Format().getTime(start: item.startTime, end: currentTime))
                        Spacer()
                        
                        Text(item.active ? "A" : "N")
                            .foregroundColor(item.active ? Color.blue : Color.gray)
                            .bold()
                            .padding(.horizontal, 16.0)
                            .padding(.vertical, 4)
                            .background(item.active ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(
                                cornerRadius: 8, style: .continuous
                            ))
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(timestamps: .constant([
            Timestamp(id: "id", endTime: Date.init(timeIntervalSinceNow: -3600), startTime: Date.init(timeIntervalSinceNow: -3750), active: false, comment: "A comment", category: "Category", project: "Project"),
            Timestamp(id: "id", endTime: Date.init(timeIntervalSinceNow: -3600), startTime: Date.init(timeIntervalSinceNow: -3750), active: false, comment: "A comment", category: "Category", project: "Example"),
        ]), currentTime: .constant(Date.init()))
    }
}
