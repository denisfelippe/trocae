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
    }
    
    @IBAction func addWhishList(sender: UIButton) {
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
