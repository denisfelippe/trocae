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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.title = "Mapa"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu_ico"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleSideMenuView")
        self.navigationItem.leftBarButtonItem = leftButton
        self.locationManager.requestWhenInUseAuthorization()
        
        let defaultLocation:CLLocationCoordinate2D  = CLLocationCoordinate2DMake(-23.573978,-46.623272)
        self.mapView.region = MKCoordinateRegionMakeWithDistance(defaultLocation, 8000, 8000)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[0] as! CLLocation
        
        self.mapView.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 8000, 8000)
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