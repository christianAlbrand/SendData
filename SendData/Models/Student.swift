//
//  Student.swift
//  SendData
//
//  Created by Christian-SDGKU on 26/09/26.
//

import Foundation

struct Student: Codable {
    let name:String
    let hobby:String
    let location:String
}


struct StudentEntry:Identifiable{
    let id:String
    let student:Student
}


