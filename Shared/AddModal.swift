//
//  AddModal.swift
//  TimeTracker
//
//  Created by zack on 6/20/21.
//

import SwiftUI

struct AddModal: View {
    @Binding var isPresented: Bool
    
    @State var project: String = ""
    @State var category: String = ""
    @State var comment: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("Create a new Timestamp")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                VStack {
                    TextField("Project", text: $project)
                        .padding([.top, .leading, .trailing])
                        .padding(.bottom, 8)
                    Rectangle()
                        .padding(.horizontal)
                        .foregroundColor(Color("DefaultGray"))
                        .frame(height: 1)
                    TextField("Category", text: $category)
                        .padding([.leading, .bottom, .trailing])
                        .padding(.top, 8)
                }
                .background(Color("HighlightGray"))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                TextField("Comment", text: $comment)
                    .padding()
                    .background(Color("HighlightGray"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            Button("Create", action: {
                if createTimestamp() == true {
                    isPresented.toggle()
                }
            })
            .accentColor(Color("HighlightGray"))
            .padding(.horizontal, 50)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0.0, y: 8)
            Spacer()

        }
        .padding()
        .background(Color("DefaultGray"))
        
    }
    
    func createTimestamp() -> Bool {
        let url = URL(string: "http://localhost:6969/api/v1/create")
        guard let requestURL = url else {
            return false
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let postString = Api().createTimestampJsonData(project: project, category: category, comment: comment)
        
        request.httpBody = postString;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if data != nil {
                print("we did it!")
                return
            }
        }
        task.resume()
        
        
        return true
    }
}

struct AddModal_Previews: PreviewProvider {
    static var previews: some View {
        AddModal(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
