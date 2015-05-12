//
//  LoginViewController.swift
//  trocae
//
//  Created by Usuário Convidado on 07/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RegisterViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //
    }
    
    func temp() {
        self.performSegueWithIdentifier("segueLogin", sender: nil)
    }
    
    func usuarioCadastrado()
    {
        println("Usuario cadastrado")
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "temp", userInfo: nil, repeats: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueCadastro"
        {
            println("segueCadastro")
            var vc = segue.destinationViewController as RegisterViewController

                println("c.delegate = self")
                vc.delegate = self

        }
    }
    
    @IBAction func realizarCadastro(sender: UIButton) {
        self.performSegueWithIdentifier("segueCadastro", sender: nil)
    }

    @IBAction func realizarLogin(sender: UIButton) {
        self.performSegueWithIdentifier("segueLogin", sender: nil)
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
