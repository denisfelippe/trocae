//
//  MapViewController.swift
//  trocae
//
//  Created by Usuário Convidado on 07/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, ENSideMenuDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var token:String = "?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NTRiZGNlOThlMGFkYWE3MGI4MTNhMjMiLCJuYW1lIjoiZGVuaXMiLCJ1c2VybmFtZSI6ImRlbmlzZmVsaXBwZSIsInBhc3N3b3JkIjoiMTIzIiwiYWRtaW4iOmZhbHNlLCJ3aXNoX2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZhIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZiIl0sIm15X2xpc3QiOlsiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjcwIiwiNTU0ZTBhYTEzNDFhMWJmMDgxODhiZjZlIl0sImxvY2F0aW9uIjpbeyJsYXQiOi0yMy41NzI4MDEsImxvbiI6LTQ2LjYyMzA2M31dfQ.gr2VGrXDZWMJ_p4wncOP3RRUT9Ow40PUXNCoZWOyOoQ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.title = "Mapa"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu_ico"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleSideMenuView")
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.loadUsers()
        
        //let defaultLocation:CLLocationCoordinate2D  = CLLocationCoordinate2DMake(-23.573978,-46.623272)
        //self.mapView.region = MKCoordinateRegionMakeWithDistance(defaultLocation, 8000, 8000)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[0] as! CLLocation
        
        self.mapView.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func loadUsers() {
        var url = NSURL(string: "http://localhost:8080/api/users" + token)!
        
        let ibiraAnnotation:MKPointAnnotation = MKPointAnnotation()
        
        ibiraAnnotation.coordinate = CLLocationCoordinate2DMake(-23.587416, -46.657634)
        
        ibiraAnnotation.title = "Parque do Ibirapuera"
        
        var users:[MKPointAnnotation]?
        
        var games = session.dataTaskWithURL(url, completionHandler: {
            (data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
            
            if let rows = self.getContent(data) as? [AnyObject] {
                dispatch_async(dispatch_get_main_queue() , {
                    for gamesJson in rows {
                        var user: [String: AnyObject] = ["lat": 0, "lon": 0, "phone": "", "name": ""]
                        if let location: AnyObject = gamesJson["location"]! {
                            
                            println(gamesJson["location"])
                            
                            if let location: AnyObject = gamesJson["location"] {
                                if let lat = location["lat"] as? CLLocationDegrees {
                                    user["lat"] = lat
                                }
                                
                                if let lon = location["lon"] as? CLLocationDegrees {
                                    user["lon"] = lon
                                }
                                
                                if let name = gamesJson["name"] as? String {
                                    user["name"] = name
                                }
                                
                                if let phone = gamesJson["phone"] as? String {
                                    user["phone"] = phone
                                }
                                
                                var userAnnotation:MKPointAnnotation = MKPointAnnotation()
                                userAnnotation.coordinate = CLLocationCoordinate2DMake(user["lat"] as! CLLocationDegrees, user["lon"] as! CLLocationDegrees)
                                
                                var nome:String = user["name"] as! String
                                var phone:String = user["phone"] as! String
                                userAnnotation.title = "\(nome) - \(phone)"
                                
                                self.mapView.addAnnotations([userAnnotation])
                            }
                        }
                    }
                })
            }
        })

        games.resume()
    }
    
    func getContent(data: NSData) -> AnyObject {
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
            return json
        }
        
        return []
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