//
//  SearchTableViewController.swift
//  search
//
//  Created by Denis Felippe da Rocha on 08/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, ENSideMenuDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var games = [GameItem]()
    
    var filteredGames = [GameItem]()
    
    override func viewDidLoad() {
        self.sideMenuController()?.sideMenu?.delegate = self
        self.title = "Buscar Jogos"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu_ico"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleSideMenuView")
        self.navigationItem.leftBarButtonItem = leftButton        
        
        self.games = [GameItem(category:"PS3/PS4", name:"God of War 3", console:"PS3", urlImage: "http://cdn.trocajogo.net/files/gameplataforma/capa/20100712153603_ps3-god-of-war-3.jpg", id: "1"),
            GameItem(category:"PS3/PS4", name:"Call of Dutty Ghosts", console:"PS3", urlImage: "http://cdn.trocajogo.net/files/gameplataforma/capa/20131105173807_ps3_call-of-duty-ghosts.jpg", id: "2"),
            GameItem(category:"Xbox", name:"Forza Horizon 2", console:"Xbox One", urlImage: "", id: "3"),
            GameItem(category:"Xbox", name:"Darksiders", console:"Xbox 360", urlImage: "", id: "4"),
            GameItem(category:"Other", name:"Mario Kart 8", console:"Wii", urlImage: "", id: "5"),
            GameItem(category:"Other", name:"Mario U", console:"Wii U", urlImage: "", id: "6"),
            GameItem(category:"Other", name:"The SIMS 4", console:"PC", urlImage: "", id: "7")]
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredGames.count
        } else {
            return self.games.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cellSearch") as UITableViewCell
        
        var game : GameItem
        // Check to see whether the normal table or search results table is being displayed and set the Game object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredGames = self.games.filter({( game : GameItem) -> Bool in
            var categoryMatch = (scope == "All") || (game.category == scope)
            var stringMatch = game.name.uppercaseString.rangeOfString(searchText.uppercaseString)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gameDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var game:GameItem
        
        if segue.identifier == "gameDetail" {
            let gameDetailViewController = segue.destinationViewController as GameViewController
            
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                game = self.filteredGames[indexPath.row]
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                game = self.games[indexPath.row]
            }
            
            gameDetailViewController.title = game.name
            gameDetailViewController.plataforma = game.console
            gameDetailViewController.tituloGame = game.name
            gameDetailViewController.urlImagem = game.urlImage
            gameDetailViewController.idGame = game.id
            //gameDetailViewController.delegate = self
            
        }
    }
}