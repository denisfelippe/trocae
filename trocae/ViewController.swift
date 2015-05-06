//
//  ViewController.swift
//  trocae
//
//  Created by Denis Felippe da Rocha on 05/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

}