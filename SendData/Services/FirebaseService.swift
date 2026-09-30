//
//  FirebaseService.swift
//  SendData
//
//  Created by Christian-SDGKU on 26/09/26.
//

import Foundation


//SERVICE
// The service is the only part of the app that talks to the server.
// It sends and recives data but knows nothing about the screen.
class FirebaseService {
    
    // base string url
    let baseURL:String = "https://christian-server-cd9cd-default-rtdb.firebaseio.com/cohort11.json"
    
    
    // MARK: FUNCTION THAT SENDS DATA TO THE SERVER
    
    //ASYNC => Takes time to complete
    //THROWS => If there is an error do something
    func sendStudent(student:Student) async throws{
//        let first:Student = Student(name: "Christian", hobby: "Test", location: "tEST")
        
        //STEP 1.- CREATE URL using our string url
        guard let url:URL = URL(string: baseURL) else{
            throw URLError(URLError.Code.badURL)
        }
        
        //STEP 2.- CREATE THE REQUEST WITH ALL THE SETTINGS
        var request:URLRequest = URLRequest(url: url)
        
        //METHOD
        request.httpMethod = "POST"
        
        //HEADERS
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //BODY
        //2.1.- Create the encoder
        let encoder: JSONEncoder = JSONEncoder()
        
        //2.2.- TRY and DECODE our SwiftModel into a JSON
        let jsonData:Data = try encoder.encode(student)
        
        //2.3.- Set the request body to the jsonData variable
        request.httpBody = jsonData
        
        //URLSession
        let (data,response) : (Data, URLResponse) = try await URLSession.shared.data(for: request)
        
        try self.checkStatusCode(response:response)
        
    }
    
    func fetchStudents() async throws -> [StudentEntry]{
        guard let url:URL = URL(string: baseURL) else{
            throw URLError(URLError.Code.badURL)
        }
        
        let (data,response): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        
        try self.checkStatusCode(response: response)
        
        let decoder: JSONDecoder = JSONDecoder()
        
        let dictionary = try decoder.decode([String:Student]?.self, from: data)
        
        guard let studentByID = dictionary else {
            return []
        }
        
        var entries : [StudentEntry] = []
        
        for (id,student) in studentByID {
            let entry:StudentEntry = StudentEntry(id: id, student: student)
            entries.append(entry)
        }
        
        return entries
    }
    
    //MARK: HELPER FUNCTION
    private func checkStatusCode(response:URLResponse)throws {
        
        guard let httpResponse:HTTPURLResponse = response as? HTTPURLResponse else{
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200{
            print("Server status code: " + String(httpResponse.statusCode))
            throw URLError(.badServerResponse)
        }
    }
}
