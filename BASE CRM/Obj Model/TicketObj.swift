//
//  TicketObj.swift
//  BaseDemo
//
//  Created by macOS on 8/31/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import ObjectMapper

class TicketObj: Mappable {
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    // Mappable
    func mapping(map: Map) {
        usrName         <- map[Constants.Obj.Ticket.UserName]
        usrID           <- map[Constants.Obj.Ticket.UserId]
        usrTitleStatus  <- map[Constants.Obj.Ticket.UserTitleStatus]
    }
    
    var usrName : String?
    var usrID : String?
    var usrTitleStatus : String?
}
