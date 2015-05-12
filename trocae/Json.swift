//
//  Json.swift
//  trocae
//
//  Created by Denis Felippe da Rocha on 09/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit
class Json: NSObject {
    let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var games = [GameItem]()
    var type:String
    var url:NSURL
    var endpoints = [
        "games": "http://localhost/games.json",
        "wish_list": "http://localhost/games-wishlist.json",
        "my_list": "http://localhost/games-mylist.json"
    ]
    
    init(type: String) {
        self.type = type
        self.url = NSURL(string: endpoints[type]!)!
    }
    
    func insertGame() {
        println("entrou insert")
        var pontoTuristico = session.dataTaskWithURL(self.url, completionHandler: {
            (data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
            println("entrou ponto")
            println(self.url)
            println(self.getContent(data))
            if let rows = self.getContent(data) as? [AnyObject] {
                dispatch_async(dispatch_get_main_queue() , {
                    for gamesJson in rows {
                        
                        var game = ["name": "(vazio)", "category": "(vazio)", "console": 0]
                        
                        if let console: String = gamesJson["console"] as? String {
                            game["console"] = console
                        }
                        
                        if let name: String = gamesJson["name"] as? String {
                            game["name"] = name
                        }
                        
                        if let category: String = gamesJson["category"] as? String {
                            game["category"] = category
                        }
                        
                        if let category: String = gamesJson["category"] as? String {
                            game["category"] = category
                        }
                        
                        if let image: String = gamesJson["image"] as? String {
                            game["urlImage"] = image
                        }
                        
                        if let id: String = gamesJson["id"] as? String {
                            game["id"] = id
                        }
                        
                        self.games += [GameItem(category:game["category"] as String, name:game["name"] as String, console:game["console"] as String, urlImage:game["urlImage"] as String, id:game["id"] as String)]
                        
                        switch (self.type) {
                            case "my_list":
                                //insere na tabela my list
                                break
                            case "wish_list":
                                //insere na tabela wish list
                                break
                            default:
                                //insere na tabela games
                                break
                        }
                    }
                })
            }
        })
        
        pontoTuristico.resume()
    }
    
    func getContent(data: NSData) -> AnyObject {
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
            return json
        }
        
        return []
    }
}
