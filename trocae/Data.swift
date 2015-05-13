//
//  Data.swift
//  trocae
//
//  Created by Usuário Convidado on 09/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit
import CoreData

class Data: NSObject, NSFetchedResultsControllerDelegate {

    var session: NSURLSession?
    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultControllerMyList = NSFetchedResultsController()
    var fetchedResultControllerWhishList = NSFetchedResultsController()
    var fetchedResultControllerGames = NSFetchedResultsController()
    
    var primeiraVez = false
    
    override init()
    {
        super.init()
        self.setupCoreDataStack()
        self.getFetchedResultControllers()
    }
    
    func recGames() ->[GameItem]
    {
        var games = [GameItem]()
    
        for gm in fetchedResultControllerGames.fetchedObjects!  as! [Games]
        {
            var gameItem: GameItem
            gameItem = GameItem(category:gm.category, name:gm.name, console:gm.console, urlImage: gm.image, id: gm.id)
            games.append(gameItem)
        }
        
        return games
    }
    
    func recMyList() ->[GameItem]
    {
        var myList = [GameItem]()
        
        for ml in fetchedResultControllerMyList.fetchedObjects! as! [MyList]
        {
            var gameItem: GameItem
            gameItem = GameItem(category:ml.category, name:ml.name, console:ml.console, urlImage: ml.image, id: ml.id)
            myList.append(gameItem)

        }
        
        return myList
    }
    
    func recWhishList() ->[GameItem]
    {
        var whishList = [GameItem]()
        
        for wl in fetchedResultControllerWhishList.fetchedObjects! as! [WhishList]
        {
            var gameItem: GameItem
            gameItem = GameItem(category:wl.category, name:wl.name, console:wl.console, urlImage: wl.image, id: wl.id)
            whishList.append(gameItem)
        }
        
        return whishList
    }
    
    func limparBase()
    {
        limpaGames()
        limpaMyList()
        limpaWhishList()
    }

    func limpaMyList()
    {
        for myList in fetchedResultControllerMyList.fetchedObjects!
        {
            if let ml = myList as? MyList
            {
                managedObjectContext?.deleteObject(ml)
            }
        }
        managedObjectContext!.save(nil)
    }
    
    func limpaWhishList()
    {
        for whishList in fetchedResultControllerWhishList.fetchedObjects!
        {
            if let wl = whishList as? WhishList
            {
                managedObjectContext?.deleteObject(wl)
            }
        }
        managedObjectContext!.save(nil)
    }
    
    func limpaGames()
    {
        for games in fetchedResultControllerGames.fetchedObjects!
        {
            if let gm = games as? Games
            {
                println("deletando Games")
                managedObjectContext?.deleteObject(gm)
            }
        }
        managedObjectContext!.save(nil)
    }
    
    func addMyList(item: GameItem)
    {
        //criar variavel para referenciar a tabela task
        let entityDescritption = NSEntityDescription.entityForName("MyList", inManagedObjectContext: managedObjectContext!)
        
        //criar um "myList", associando com a entidade correta e colocar no contexto
        var myList = Games(entity: entityDescritption!, insertIntoManagedObjectContext: managedObjectContext)
        
        myList.id = item.id
        myList.name = item.name
        myList.image = item.urlImage
        myList.console = item.console
        myList.category = item.category
        
        //salvar alteracao no banco
        managedObjectContext!.save(nil)
    }
    
    func addGame(item: GameItem)
    {
        //criar variavel para referenciar a tabela task
        let entityDescritption = NSEntityDescription.entityForName("Games", inManagedObjectContext: managedObjectContext!)
        
        //criar um "game", associando com a entidade correta e colocar no contexto
        var game = Games(entity: entityDescritption!, insertIntoManagedObjectContext: managedObjectContext)
        
        game.id = item.id
        game.name = item.name
        game.image = item.urlImage
        game.console = item.console
        game.category = item.category
        
        //salvar alteracao no banco
        managedObjectContext!.save(nil)
    }
    
    func addWhishList(item : GameItem)
    {
        println("entrou addwish")
        
        //criar variavel para referenciar a tabela task
        let entityDescritption = NSEntityDescription.entityForName("WhishList", inManagedObjectContext: managedObjectContext!)
        
        //criar um "whishList", associando com a entidade correta e colocar no contexto
        var whishList = Games(entity: entityDescritption!, insertIntoManagedObjectContext: managedObjectContext)
        
        whishList.id = item.id
        whishList.name = item.name
        whishList.image = item.urlImage
        whishList.console = item.console
        whishList.category = item.category
        
        //salvar alteracao no banco
        managedObjectContext!.save(nil)
    }
    
    func setupCoreDataStack() {
        println("setupCoreDataStack")
        
        ///////////////ver nomes
        let modelURL: NSURL? = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        
        // criacao do coordenador
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        //pegar o caminho para a pasta documents do sistema
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let applicationDocumentsDirectory = urls.last as! NSURL
        
        //Criar uma url do caminho da pasta documents + o nome do arquivo de banco de dados
        let url = applicationDocumentsDirectory.URLByAppendingPathComponent("Model.sqlite")
        var error: NSError? = nil
        NSLog("%@", url)
        
        var store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error)
        
        if store == nil {
            NSLog("Unresolved error\(error) \(error!.userInfo)")
            return
        }
        
        // criacao do contexto
        managedObjectContext = NSManagedObjectContext()
        managedObjectContext!.persistentStoreCoordinator = coordinator
        
    }
    
    func getFetchedResultControllers()
    {
        getFetchedResultControllerMyList()
        getFetchedResultControllerWhishList()
        getFetchedResultControllerGames()
    }
    
    private func getFetchedResultControllerMyList() {
        //primeiro inicializamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest(entityName: "MyList")
        
        // ordenando os dados pelo campo nome
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //com o FetchRequest acima definido e sem opcoes de cache
        fetchedResultControllerMyList = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //a controler será o delegate do fetch
        fetchedResultControllerMyList.delegate = self
        
        //executa o fetch
        fetchedResultControllerMyList.performFetch(nil)
        
    }
    
    private func getFetchedResultControllerWhishList() {
        //primeiro inicializamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest(entityName: "WhishList")
        
        // ordenando os dados pelo campo nome
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //com o FetchRequest acima definido e sem opcoes de cache
        fetchedResultControllerWhishList = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //a controler será o delegate do fetch
        //fetchedResultControllerWhishList.delegate = self
        
        //executa o fetch
        fetchedResultControllerWhishList.performFetch(nil)
    }
    
    private func getFetchedResultControllerGames() {
        //primeiro inicializamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest(entityName: "Games")
        
        // ordenando os dados pelo campo nome
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //com o FetchRequest acima definido e sem opcoes de cache
        fetchedResultControllerGames = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //a controler será o delegate do fetch
        fetchedResultControllerGames.delegate = self
        
        //executa o fetch
        fetchedResultControllerGames.performFetch(nil)
        
    }
}
