//
//  Service.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import Foundation

let REF_SERVER = "https://fetch-hiring.s3.amazonaws.com/hiring.json"


struct Service {
    static let shared = Service()
    
    func fetchList(completion: @escaping(Bool, [List]?) -> Void) {
        guard let url = URL(string: REF_SERVER) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, res, error) in
            if let _ = error {
                completion(false, nil)
                return
            }
            
            guard let res = res as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: res))")
                completion(false, nil)
                return
              }
            
            guard let data = data else { return }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {

                    var fetchedLists = [String: List]()
                    
                    for data in jsonData {
                        guard let name = data["name"] as? String, name != "" else { continue }
                        guard let itemId = data["id"] as? Int, let listId = data["listId"] as? Int else { continue }
                        
                        let item = Item(id: itemId, name: name)
                        
                        if fetchedLists[listId.description] != nil {
                            guard let list = fetchedLists[listId.description] else { continue }
                            list.items.append(item)
                        } else {
                            let list = List(id: listId, items: [item])
                            fetchedLists[listId.description] = list
                        }
                    }
                    
                    completion(true, Array(fetchedLists.values))
                }
            } catch {
                print("DEBUG:- \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}
