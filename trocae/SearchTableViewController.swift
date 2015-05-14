//
//  SearchTableViewController.swift
//  search
//
//  Created by Denis Felippe da Rocha on 08/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, ENSideMenuDelegate, UISearchBarDelegate, JsonDelegate {
    
    var searchActive : Bool = false
    var games = [GameItem]()
    
    var filteredGames = [GameItem]()
    
    override func viewDidLoad() {
        self.sideMenuController()?.sideMenu?.delegate = self
        self.title = "Buscar Jogos"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu_ico"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleSideMenuView")
        self.navigationItem.leftBarButtonItem = leftButton
        self.loadJson()
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    func loadJson() {
        var data: Data = Data()
        data.limpaGames()
        
        var json: Json = Json(type: "games")
        json.delegate = self
        json.insertGame()
    }
    
    func atualizaTabela()
    {
        var data: Data = Data()
        games = data.recGames()
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredGames = games.filter({ (text) -> Bool in
            let tmp: NSString = text.name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredGames.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
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
        if(searchActive) {
            return filteredGames.count
        }
        return games.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var game : GameItem
        let cell = tableView.dequeueReusableCellWithIdentifier("cellSearch") as! UITableViewCell;
        
        if(searchActive){
            game = filteredGames[indexPath.row]
        } else {
            game = games[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = game.name
        cell.detailTextLabel?.text = game.console
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gameDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var game:GameItem
        
        if segue.identifier == "gameDetail" {
            let gameDetailViewController = segue.destinationViewController as! GameViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            
            if searchActive {
               game = self.filteredGames[indexPath.row]
            } else {
               game = self.games[indexPath.row]
            }
            
            gameDetailViewController.game = game
            gameDetailViewController.title = game.name
        }
    }
}