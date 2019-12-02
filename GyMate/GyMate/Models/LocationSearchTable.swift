//
//  LocationSearchTable.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-30.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController{
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
}

extension LocationSearchTable : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSe
        
        
    }
}
