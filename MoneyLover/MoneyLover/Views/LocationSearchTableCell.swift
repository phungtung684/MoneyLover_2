//
//  LocationSearchTableCell.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/9/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableCell: UITableViewCell {

    func configCellWithContent(selectedItem: MKPlacemark) {
        self.textLabel?.text = selectedItem.name
        self.detailTextLabel?.text = parseAddress(selectedItem)
    }
    
    private func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(format: "%@%@%@%@%@%@%@", selectedItem.subThoroughfare ?? "", firstSpace, selectedItem.thoroughfare ?? "", comma, selectedItem.locality ?? "", secondSpace, selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}
