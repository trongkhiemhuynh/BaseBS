//
//  LoginState.swift
//  BaseDemo
//
//  Created by macOS on 9/7/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

//import Foundation
//import ReSwift
//import RxSwift
//import RxCocoa
//
//struct LoginState : StateType {
//    //FIXME
//    var loginObj = BehaviorRelay<LoginObj>(value: LoginObj())
////    var loginObj = Variable<LoginObj>(LoginObj(map: ))
////    var strLogin = BehaviorRelay<String>(value: "hello world!")
//}
//
//extension LoginState {
//    static func reducer(action: Action, state: LoginState?) -> LoginState {
//        let state = state ?? LoginState()
//        
//        switch action {
//        case let action as UpdateLoginAction:
//            state.loginObj.accept(action.login!)
//        default:
//            break
//        }
//        
//        return state
//    }
//}
