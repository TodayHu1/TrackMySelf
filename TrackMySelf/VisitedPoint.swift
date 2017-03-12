//
//  VisitedPoint.swift
//  TrackMySelf
//
//  Created by Dragos Neagu on 12/03/2017.
//  Copyright © 2017 Dragos Neagu. All rights reserved.
//

import Foundation

class VisitedPoint {
    var latitude : String
    var longitude : String
    
    init(latCoordinate: String, longCoordinate: String){
        self.latitude = latCoordinate
        self.longitude = longCoordinate
    }
}
