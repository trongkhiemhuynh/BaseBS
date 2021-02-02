//
//  TicketState.swift
//  BaseDemo
//
//  Created by macOS on 8/31/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

//import Foundation
//import ReSwift
//import RxSwift
//import RxCocoa
//
//struct TicketState : StateType {
//    //FIXME
//    var ticketList = BehaviorRelay<[TicketObj]>(value: [])
//}
//
//extension TicketState {
//    static func reducer(action: Action, state: TicketState?) -> TicketState {
//        
//        // get state
//        let state = state ?? TicketState()
//        
//        switch action {
//        case let action as UpdateTicketListAction:
//            state.ticketList.accept(action.ticketList ?? [])
//            break
//        default:
//            break
//        }
//        
//        return state
//    }
//}
