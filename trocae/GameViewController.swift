//
//  GameViewController.swift
//  trocae
//
//  Created by Usuário Convidado on 09/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var game : GameItem!
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    var token:String = "?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NTRiZGNlOThlMGFkYWE3MGI4MTNhMjMiLCJuYW1lIjoiZGVuaXMiLCJ1c2VybmFtZSI6ImRlbmlzZmVsaXBwZSIsInBhc3N3b3JkIjoiMTIzIiwiYWRtaW4iOmZhbHNlLCJ3aXNoX2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZhIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZiIl0sIm15X2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjcwIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZlIl0sImxvY2F0aW9uIjpbeyJsYXQiOi0yMy41NzI4MDEsImxvbiI6LTQ2LjYyMzA2M31dfQ.gr2VGrXDZWMJ_p4wncOP3RRUT9Ow40PUXNCoZWOyOoQ"
    
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lblTituloGame: UILabel!
    @IBOutlet weak var lblPlataforma: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTituloGame.text = game.name
        lblPlataforma.text = game.console
        
        downloadImage(game.urlImage)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addMyList(sender: UIButton) {
        
        let params:[String: AnyObject] = ["_id" : game.id]
        let url = NSURL(string:"http://104.236.107.158:8080/api/my-list" + token)
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "PUT"
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        
        let task = self.session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    println("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                println("error submitting request: \(error)")
                return
            }
            
            // handle the data of the successful response here
            var result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary
            println(result)
        }
        task.resume()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addWhishList(sender: UIButton) {
        
        let params:[String: AnyObject] = ["_id" : game.id]
        let url = NSURL(string:"http://104.236.107.158:8080/api/wish-list" + token)
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "PUT"
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        
        let task = self.session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    println("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                println("error submitting request: \(error)")
                return
            }
            
            // handle the data of the successful response here
            var result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary
        }
        task.resume()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func downloadImage(imageURL : String) {
        
        if(imageURL == "")
        {
            return
        }
        
        let url = NSURL (string: imageURL)
        
        //outra maneira de criar uma sessao
        //retorna um singleton (sessao compartilhada)
        var imageSession = NSURLSession.sharedSession()
        
        //cria uma task do tipo download
        var imageTask = imageSession.downloadTaskWithURL(url!) {
            (url: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            //recebe o binário da imagem
            if let imageData = NSData(contentsOfURL: url){
                
                dispatch_async(dispatch_get_main_queue() , {
                self.imgGame.image = UIImage(data: imageData)
                })
            }
        }
        imageTask.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
