//
//  ContentView.swift
//  Shared
//
//  Created by zack on 6/19/21.
//

import SwiftUI

struct ContentView: View {
    @State var isPresentingAddModal = false
    @State var currentTime: Date = Date.init()
    @State var timestamps: [Timestamp] = [];
    
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
                .sheet(isPresented: $isPresentingAddModal, onDismiss: {
                    loadData()
                }, content: {
                    AddModal(isPresented: $isPresentingAddModal)
                })
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        Api().getTimestamps { ts in
            self.timestamps = ts
        }
        self.currentTime = Date.init()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
