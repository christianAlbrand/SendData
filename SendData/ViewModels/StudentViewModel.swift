//
//  StudentViewModel.swift
//  SendData
//
//  Created by Christian-SDGKU on 26/09/26.
//

import Foundation
import Combine


@MainActor
class StudentViewModel: ObservableObject {
    
    // Input Fields
    @Published var name: String = ""
    @Published var hobby: String = ""
    @Published var location: String = ""
    
    // Helper or status
    @Published var statusMessage: String = ""
    
    //Collection of students
    @Published var students: [StudentEntry] = []
    
    
    //Calls the serveer
    let service : FirebaseService = FirebaseService()
    
    func sendStudent() async {
        if self.name.isEmpty || self.hobby.isEmpty || self.location.isEmpty {
            statusMessage = "Please fill in all fields"
            return
        }
        
        let student:Student = Student(name: name, hobby: hobby, location: location)
        
        do {
            try await service.sendStudent(student: student)
            statusMessage = "Student sent ✅"
            
            name = ""
            hobby = ""
            location = ""
        }catch let error{
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
    
    func loadStudents() async {
        do {
            let loadedStudents: [StudentEntry] = try await service.fetchStudents()
            students = loadedStudents
        }catch let error {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
}
