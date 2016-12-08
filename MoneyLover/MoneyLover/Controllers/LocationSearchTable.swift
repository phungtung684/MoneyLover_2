//
//  LocationSearchTable.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/8/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearchDelegate: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class LocationSearchTable: UITableViewController {
    
    var matchingItems = [MKMapItem]()
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LocationSearchTable {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? LocationSearchTableCell {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.configCellWithContent(selectedItem)
            return cell
        }
        return UITableViewCell()
    }
}

extension LocationSearchTable {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
