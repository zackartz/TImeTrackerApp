//
//  DetailView.swift
//  TimeTracker
//
//  Created by zack on 6/21/21.
//

import SwiftUI

struct DetailView: View {
    @State var ts: Timestamp
    
    var body: some View {
        VStack {
            Text("")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(ts: Timestamp(id: "18ed6422-5fe0-4c5e-b4e6-df83aef7cf07", endTime: <#T##Date#>, startTime: <#T##Date#>, active: <#T##Bool#>, comment: <#T##String?#>, category: <#T##String?#>, project: <#T##String#>))
    }
}
