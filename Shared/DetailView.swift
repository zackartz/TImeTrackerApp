//
//  DetailView.swift
//  TimeTracker
//
//  Created by zack on 6/21/21.
//

import SwiftUI

struct DetailView: View {
    @State var ts: Timestamp
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(ts.project)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            Text((ts.category != nil) ? ts.category! : "Uncategorized")
            HStack {
                Text(Format().formatDateShort(date: ts.startTime))
                    .font(.title)
                Spacer()
                Image(systemName: "arrow.forward")
                    .font(.system(size: 26, weight: .bold, design: .default))
                Spacer()
                Text(Format().formatDateShort(date: Date.init()))
                    .font(.title)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 15)
            .padding([.top, .leading, .trailing])
            
            Text(ts.active ? "Started \(Format().getTime(start: ts.startTime, end: Date.init())) ago" : "Lasted \(Format().getTime(start: ts.startTime, end: Date.init()))")
            
            if (ts.comment != nil) && (ts.comment != "") {
                Text(ts.comment!)
                    .padding(.all)
                    .frame(width: UIScreen.main.bounds.width - 18*2)
                    .background(Color.gray.opacity(0.2))
                    .font(.system(.body, design: .monospaced))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            HStack {
                Button(action: {
                    Api().stopTimestamp(id: ts.id)
                    ts.active = false
                }, label: {
                    Text("Stop")
                        .font(.system(.title2, design: .default))
                        .bold()
                })
                .frame(width: UIScreen.main.bounds.width/2-18*3)
                .padding()
                .background(ts.active ? Color.red : Color("GrayedOut"))
                .foregroundColor(ts.active ? Color("HighlightGray") : Color("TextColor"))
                .font(.system(.title2, design: .default))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                Button(action: {}, label: {
                    Image(systemName: "pause.fill")
                        .font(.system(.title, design: .default))
                })
                .frame(width: UIScreen.main.bounds.width/2-18*3)
                .padding()
                .background(ts.active ? Color.green : Color("GrayedOut"))
                .foregroundColor(ts.active ? Color.white : Color("TextColor"))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            if !ts.active {
                Button(action: {
                    let e = Api().deleteTimestamp(id: ts.id)
                    if !e {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Delete")
                        .bold()
                })
                .frame(width: UIScreen.main.bounds.width - 18*4)
                .transition(.opacity)
                .animation(.easeIn)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.system(.title2, design: .default))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(ts: Timestamp(id: "18ed6422-5fe0-4c5e-b4e6-df83aef7cf07", endTime: Date.init(), startTime: Date.init(timeIntervalSinceNow: -3700), active: false, comment: "this is a comment", category: "category", project: "Start iOS App Development"))
    }
}
