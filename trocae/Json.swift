//
//  Json.swift
//  trocae
//
//  Created by Denis Felippe da Rocha on 09/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

protocol JsonDelegate:class{
    
    func atualizaTabela()
}
class Json: NSObject {
    let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var games = [GameItem]()
    var type:String
    var urlApi:String = "http://localhost:8080/api"
    var token:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NTRiZGNlOThlMGFkYWE3MGI4MTNhMjMiLCJuYW1lIjoiZGVuaXMiLCJ1c2VybmFtZSI6ImRlbmlzZmVsaXBwZSIsInBhc3N3b3JkIjoiMTIzIiwiYWRtaW4iOmZhbHNlLCJ3aXNoX2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZhIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZiIl0sIm15X2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjcwIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZlIl0sImxvY2F0aW9uIjpbeyJsYXQiOi0yMy41NzI4MDEsImxvbiI6LTQ2LjYyMzA2M31dfQ.gr2VGrXDZWMJ_p4wncOP3RRUT9Ow40PUXNCoZWOyOoQ"
    var url:NSURL
    var endpoints:[String:String] = [
        "games": "/games",
        "wish_list": "/wish-list",
        "my_list": "/my-list",
        "users": "/users"
    ]
    
    weak var delegate: JsonDelegate?
    
    init(type: String) {
        self.type = type
        self.url = NSURL(string: urlApi + endpoints[type]! + "?token=" + token)!
    }
    
    func insertGame() {
        println(self.url)
        var coreData: Data = Data()
        
        var games = session.dataTaskWithURL(self.url, completionHandler: {
            (data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
            
            if let rows = self.getContent(data) as? [AnyObject] {
                dispatch_async(dispatch_get_main_queue() , {
                    for gamesJson in rows {
                        
//                        var game = ["name": "(vazio)", "category": "(vazio)", "console": 0]
                        var game = [String: AnyObject]()
                        
                        if let console: String = gamesJson["console"] as? String {
                            game["console"] = console
                        }
                        
                        if let name: String = gamesJson["name"] as? String {
                            game["name"] = name
                        }
                        
                        if let category: String = gamesJson["category"] as? String {
                            game["category"] = category
                        }
                        
                        if let image: String = gamesJson["image"] as? String {
                            game["urlImage"] = image
                        }
                        
                        if let id: String = gamesJson["_id"] as? String {
                            game["id"] = id
                        }
                        
                        var gameItem = GameItem(category:game["category"] as! String, name:game["name"] as! String, console:game["console"] as! String, urlImage:game["urlImage"] as! String, id:game["id"] as! String)
                        
                        switch (self.type) {
                            case "my_list":
                                coreData.addMyList(gameItem)
                                break
                            case "wish_list":
                                coreData.addWhishList(gameItem)
                                break
                            default:
                                coreData.addGame(gameItem)
                                break
                        }
                        
                    }
                    self.delegate?.atualizaTabela()
                })
            }
        })
        
        games.resume()
    }
    
    func getContent(data: NSData) -> AnyObject {
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
            return json
        }
        
        return []
    }
}
