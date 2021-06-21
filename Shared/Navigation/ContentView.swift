//
//  ContentView.swift
//  Shared
//
//  Created by zack on 6/19/21.
//

import SwiftUI
import BBRefreshableScrollView

struct ContentView: View {
    @State var isPresentingAddModal = false
    @State var timestamps: [Timestamp] = [];
    @State var currentTime: Date = Date.init()
    
    var body: some View {
        NavigationView() {
            DashboardView(timestamps: $timestamps, currentTime: $currentTime)
                .navigationTitle("Timestamps")
                .navigationBarItems(trailing: HStack {
                    Button( action: {
                            self.isPresentingAddModal.toggle()
                        }
                    ) {
                        Image(systemName: "plus.app")
                            .font(.title2)
                            .padding(8)
                    }
                    Button( action: {
                            loadData()
                        }
                    ) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                    }
                })
                .sheet(isPresented: $isPresentingAddModal, content: {
                    AddModal(isPresented: $isPresentingAddModal)
                })
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        Api().getTimestamps { timestamps in
            self.timestamps = timestamps
        }
        self.currentTime = Date.init()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
