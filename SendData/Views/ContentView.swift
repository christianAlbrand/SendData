//
//  ContentView.swift
//  SendData
//
//  Created by Christian-SDGKU on 26/09/26.
//

import SwiftUI

struct ContentView: View {
    
    // @StateObject creates the Viewmodel once and keeps it alive
    // for as long as this screen exists.
    @StateObject private var viewModel:StudentViewModel = StudentViewModel()
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                Form{
                    Section(header: Text("Your Info")) {
                        TextField("Name", text: $viewModel.name)
                        TextField("Hobby", text: $viewModel.hobby)
                        TextField("Loction (City or Country", text: $viewModel.location)
                        
                        Button("Send"){
                            Task {
                                await viewModel.sendStudent()
                            }
                        }
                        
                        Text(viewModel.statusMessage)
                    }
                    
                    Section(header: Text("Classmates")){
                        Button("Load Data"){
                            Task{
                                await viewModel.loadStudents()
                            }
                        }
                        ForEach(viewModel.students){ student in
                            VStack(alignment: .leading){
                                Text(student.student.name).font(.headline)
                                Text("Likes " + student.student.hobby  + " from " + student.student.location)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
