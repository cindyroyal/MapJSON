//
//  ViewController.swift
//  NewMap
//
//  Created by Cindy Royal on 5/3/18.
//  Copyright © 2018 Cindy Royal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    struct Events: Decodable {
       
        let title: String
        let subtitle: String
        let lat: Double
        let long: Double
    }

    
    
    @IBOutlet weak var mapV: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let json = "https://cindyroyal.name/json/latlong.json"
        
        mapV.mapType = MKMapType.hybrid
        
        
        let location = CLLocationCoordinate2D(latitude: 30.2672,longitude: -97.7431)
        
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapV.setRegion(region, animated: false)
        
        // declare points
        let annotation = MKPointAnnotation()
        let ann2 = MKPointAnnotation()
        
        // guard statements protect the app if there is no response
        guard let url = URL(string: json)
            else { return }
        
        // this area sets up a urlsession with the json
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data
                else { return }
            
            // use do, try, catch to deal with errors
            do {
                
                // JSONDecoder decodes json array
                let events = try JSONDecoder().decode([Events].self, from: data)
                //enumerated adds the index to the array
                for (i, event) in events.enumerated() {
                    if(event.title == "UT") {
                        //must use this to change the ui element outside of the urlsession. Use of += to append to the TextView
                        DispatchQueue.main.sync {
                           annotation.coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
                            annotation.title = event.title
                            annotation.subtitle = event.subtitle
                        }
                    }
                    if(event.title == "Amys Ice Cream"){
                        ann2.coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
                        ann2.title = event.title
                        ann2.subtitle = event.subtitle
                    
                    
                    }
                    
                }
            }
                
            catch let jsonErr {
                print("Error", jsonErr)
            }
            }.resume()

        
        
        mapV.addAnnotation(annotation)
        mapV.addAnnotation(ann2)
        
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



