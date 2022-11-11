//
//  Bundle-Decodable.swift
//  inSociety
//
//  Created by Aleksey Libin on 17.10.2022.
//



//MARK: - Returns structed data from json file
/*
 
 import Foundation
 import UIKit

 extension Bundle {
     func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
         guard let url = self.url(forResource: file, withExtension: nil) else {
             fatalError("Filed with locating \(file) in bundle")
         }
         
         guard let data = try? Data(contentsOf: url) else {
             fatalError("Filed with loading \(file) form bundle")
         }
         
         let decoder = JSONDecoder()
         
         guard let decodedData = try? decoder.decode(T.self, from: data) else {
             fatalError("Filed with decoding \(file) from bundle")
         }
         
         return decodedData
     }
 }
 
 */

