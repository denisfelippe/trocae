//
//  WhishListTableViewController.swift
//  trocae
//
//  Created by Usuário Convidado on 07/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit
import CoreData


class WhishListTableViewController: UITableViewController, ENSideMenuDelegate, JsonDelegate {

    var whishList = [GameItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.title = "Interesse"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu_ico"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleSideMenuView")
        self.navigationItem.leftBarButtonItem = leftButton
        
        // limpa os dados da base
        var data: Data = Data()
        data.limpaWhishList()

        var json: Json = Json(type: "wish_list")
        json.delegate = self
        // recupera dados do json e grava no core data
        json.insertGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return whishList.count

    }
    
    @IBAction func addGame(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("segueAddGameWhishList", sender: nil)
    }

//    @IBAction func toggleMenu(sender: UIBarButtonItem) {
//        toggleSideMenuView()
//    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wishListIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        cell.textLabel?.text = whishList[indexPath.row].name
        return cell
    }
    
    func atualizaTabela()
    {
        println("Atualizando tabela")
        
        // Consulta do banco
        var data: Data = Data()
        whishList = data.recWhishList()

        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
