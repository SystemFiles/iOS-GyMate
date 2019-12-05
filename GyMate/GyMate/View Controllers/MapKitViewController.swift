//
//  MapKitViewController.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-30.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapKitViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let locationManger = CLLocationManager()
    var initalLocation = CLLocation()
    var routeSteps = ["Enter a destination to see steps"] as NSMutableArray

    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblView: UITableView!
    

    func centerMapOnLocation(location : CLLocation)
      {
          let regionRadius : CLLocationDistance = 2000
          let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
          mapView.setRegion(coordinateRegion, animated: true)

      }
    @IBAction func dissmissView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findDestination(){
        if (searchBar.text != ""){
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchBar.text!){ (placemarks, error)
                in
                //Which search result comes first, pick that
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

                    self.centerMapOnLocation(location: newLocation)
                    
                    //Remove any existing map annotions except the user location
                    let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
                    self.mapView.removeAnnotations( annotationsToRemove )
                    let dropPin = MKPointAnnotation()
            
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.mapView.addAnnotation(dropPin)
                    self.mapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initalLocation.coordinate))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile

                    let directions = MKDirections(request: request)
                    
                    directions.calculate(completionHandler: { (response, error) in
                        for route in (response?.routes)!{
                            
                            //Remove any pre-exisitng overlays
                            for overlay in self.mapView.overlays{
                                self.mapView.removeOverlay(overlay)
                            }
                            
                            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                            
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                            //Refresh route
                            self.routeSteps.removeAllObjects()
                            for step in route.steps{
                                self.routeSteps.add(step.instructions)
                            }
                            self.tblView.reloadData()
                        }
                    })
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Create a renderer to render the directed path
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        return renderer
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Clear default table color and change text color
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return routeSteps.count
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 30
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        tableCell.textLabel?.text = (routeSteps[indexPath.row] as! String)
        //Fix table cell seperator insets
        tableCell.separatorInset = UIEdgeInsets.zero
        tableCell.layoutMargins = UIEdgeInsets.zero
        
        return tableCell
      }



}
extension MapKitViewController : CLLocationManagerDelegate {
    //Ask user for location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManger.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //Find userlocation
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.initalLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            mapView.setRegion(region, animated: true)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:\(error)")
    }
    
    
}
extension MapKitViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Search for entered location
        findDestination()
        self.searchBar.endEditing(true)
    }
}
