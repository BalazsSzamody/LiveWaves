//
//  SpotInfoController.swift
//  LiveWaves
//
//  Created by Szamódy Zs. Balázs on 2018. 04. 12..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation

struct SpotInfoController {
    func fetchSpotInfo(completion: @escaping(DailySpotInfo?) -> Void) {
        
        let baseURL = URL(string: "https://api.stormglass.io/forecast?")
        
        let query: [String:String] = ["lat" : "-33.806",
                                      "lng" : "151.2861"]
        guard let url = baseURL?.withQueries(query) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("bdc9b098-3d80-11e8-97db-0242ac120006-bdc9b246-3d80-11e8-97db-0242ac120006", forHTTPHeaderField: "Authentication-Token")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error)
                print(response)
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard let data = data else {
                print("no data")
                completion(nil)
                return
            }
            guard let spotInfo = try? decoder.decode(DailySpotInfo.self, from: data) else {
                print("Data decoding failed")
                completion(nil)
                return
            }
            
            completion(spotInfo)
        }
        
        task.resume()
    }
}
