//
//  RegisterViewController.swift
//  trocae
//
//  Created by Usuário Convidado on 07/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

protocol RegisterViewControllerDelegate:class{
    
    func usuarioCadastrado()
}

class RegisterViewController: UIViewController {
    
    weak var delegate: RegisterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: UIButton) {
        //faz o cadastro
        
        println("register")
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.usuarioCadastrado()
        
        
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
