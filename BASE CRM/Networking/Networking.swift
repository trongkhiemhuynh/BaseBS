//
//  Networking.swift
//  BaseDemo
//
//  Created by macOS on 8/31/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
//import PromiseKit
//import Alamofire
//import RealmSwift
import ObjectMapper
//import RxSwift

typealias Handler = (_ data: [Any]?,_ error: Error?) -> Void
typealias MappableHandler = (Mappable?, Error?) -> Void

let BearerAuth = "Bearer "

protocol AppAPIList {
    func checkToken(completion: @escaping Handler)
}

class Networking: NSObject, AppAPIList {
    static let shared = Networking()
//    weak var delegate: LoginPresenterOutput?
    
    var authorization: String {
        if let objLogin = RealmManager.shared.onGetLoginObject() as? LoginObj {
            let auth = BearerAuth + objLogin.token!
            return auth
        }
        
        return ""
    }

    func checkToken(completion: @escaping Handler) {
        let headers = ["Authorization": authorization]
        let request = CheckTokenRequest(params: nil, headers: headers).asURLRequest()
        onUrlSession(request: request) { (dict, error) in
            if error != nil {
                completion(nil, NSError.sessionExpired())
            } else {
                guard let dict = dict else { completion(nil, NSError.unknownError()); return }
                //                    guard let d = dict["data"] as? [String: Any]  else { completion(nil, NSError.unknownError()); return }
                
                if let data = dict["data"] as? String {
                    if !data.isEmpty {
                        completion([data], nil)
                    } else {
                        completion(nil, NSError.sessionExpired())
                    }
                } else {
                    completion(nil, NSError.sessionExpired())
                }
            }
        }
        
    }
    
    func fetchLogin(with username: String, password: String, completion: @escaping (Bool)->()) {
        
        let params = ["email":username, "pass":password]
        
        let request = FetchLoginRequest(params: params, headers: nil).asURLRequest()
        
        onUrlSession(request: request) { (dictData, error) in
            if let dict = dictData {
                let login = LoginObj(JSON: dict)
                print("debug")
                print(login?.tenant)
                print(login?.name)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: login!)
                
                let user = UserDefaults.standard
                user.set(data, forKey: "KLOGIN")
                user.synchronize()
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    func fetchMenu(completion: @escaping Handler) {
        let headers = ["Authorization": authorization]
        let request = FetchMenuRequest(params: nil, headers: headers).asURLRequest()
        
        onUrlSession(request: request) { (dict, error) in
            if error != nil {
                completion(nil, NSError.unknownError())
            } else {
                
                guard let dict = dict else { completion(nil, NSError.unknownError()); return }
                
                Logger.info(dict)
                
                guard let d = dict["data"] as? [String: Any]  else { completion(nil, NSError.sessionExpired()); return }
                
                let arrKeys = d.keys
                var arrMenu: Array<[String:String]> = []
                
                for key in arrKeys {
                    let value = d[key]
                    
                    if let val = value as? String {
                        let dict = [key:val]
                        
//                        let obj = MenuObject()
//                        obj.key = val
//                        obj.value = key
//                        //save all object menu
//                        RealmManager.shared.onModifiedObject(object: obj)
                        
                        arrMenu.append(dict)
                    }
                }
                
                //handler array of dictionary
                completion(arrMenu,nil)
            }
        }
    }

    func fetchObjectList(id: String, completion: @escaping Handler) {
        //update search 
        let params: [String: Any] = ["object_id":id, "search_with": ["meta":[], "data":[]]]
        let headers = ["CurrentPage": String(1),"RecordPerPage": String(20),"Authorization": authorization]
        let request = FetchObjectListRequest(params: params, headers: headers).buildURLRequest()
        
        print("debug_khiemht_authorization \(authorization)")
        onUrlSession(request: request) { (dict, err) in
            guard let dic = dict else { completion([], nil); return }
            
            Logger.info(dic)
            
            let list = ObjectList(JSON: dic)
            
            if let arrList = list?.dataList {
                var arrStringName: [Any] = []
                
                for obj in arrList {
                    if let ob = obj as? [String: Any] {
                        if let objSub = ObjectSubList(JSON: ob) {
                            arrStringName.append(objSub)
                        }
                    }
                }
                
                completion(arrStringName, nil)
            } else {
                completion(nil, NSError.sessionExpired())
            }
        }
    }
    
    func onCreatedForm(id: String , completion: @escaping MappableHandler) {
        let headers = ["ID": id, "Authorization": authorization]
        let request = LoadFormRequest(params: nil, headers: headers).asURLRequest()
        
        onUrlSession(request: request) { (dictJson, err) in
            
            guard let dic = dictJson else { completion(nil, NSError.sessionExpired()); return }
            if let loadFormList = LoadFormList(JSON: dic) {
                //                        Logger.info(loadFormList?.arrForm?.count)
                completion(loadFormList, nil)
            } else {
                completion(nil, NSError.sessionExpired())
            }
        }
    }
    
    func onInsertRecord(idObject: String, arr: [Any], completion: @escaping (Bool) -> ()) {
        let idObj = idObject
        guard let idOwner = UserDefaults.standard.value(forKey: "kIdOwner") as? String else {completion(false); return}
        
        let headers = ["Authorization":authorization,"ID":idObj,"Owner":idOwner]
        let params = ["key":arr]
        
        let request = InsertRecordRequest(params: params, headers: headers).buildURLRequest()
        
        onUrlSession(request: request) { (dict, error) in
            //                Logger.info(dict)
            
            if error != nil {
                completion(false)
                return
            } else {
                if dict != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func getOwnerInfo(completion: @escaping ([Codable]?)->()) {
        if let objLogin = RealmManager.shared.onGetLoginObject() as? LoginObj {
            
            let token = objLogin.token
            let authorization = BearerAuth + token!
            
            let strUrl = Constants.App.BaseURL + Constants.APIEndPoint.IdOwner
            let requestURL = URL(string: strUrl)
            
            var request = URLRequest(url: requestURL!)
            
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            onUrlSession(request: request) { (dict, error) in
//                Logger.info(dict)
                
                if let arrOwner = dict!["data"] as? Array<[String: Any]> {
                    
                    let data = try? JSONSerialization.data(withJSONObject: arrOwner, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    let arrOwner = try? decoder.decode([OwnerModel].self, from: data!)
                    
                    completion(arrOwner)
                }
            }
        }
    }
    
    func deleteObject(objectId: String, recordId: String, completion: @escaping (Bool) -> ()) {
        let dict = ["object_id": objectId, "id": recordId]
        let headers = ["Authorization": authorization]
        let request = DeleteRecordRequest(params: dict, headers: headers).buildURLRequest()
        
        onUrlSession(request: request) { (dict, error) in
//            Logger.info(dict)
            
            if let data = dict {
                if let code = data["status_code"] as? Int, code == 200 {
                    print(code)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func updateRecord( dict: [String: Any], completion: @escaping (Bool)->Void) {
        let params =  ["key":dict]
        let headers = ["Authorization": authorization]
        let request = UpdateRecordRequest(params: params, headers: headers).asURLRequest()
        
        onUrlSession(request: request) { (dict, error) in
//            print(dict)
            if (error != nil) {
                completion(false)
            } else {
                if dict?.keys.count ?? 0 > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
        }
    }
    
    func loadRecord(idObject: String, idRecord: String, completion: @escaping (String?)->()) {
        let headers = ["Authorization": authorization]
        
        let request = LoadRecordRequest(params: nil, headers: headers, object_id: idObject, id: idRecord).asURLRequest()
        
        print(headers)
        
        onUrlSession(request: request) { (dictData, err) in
            guard let data = dictData?["data"] as? [String: Any] else {completion(nil); return}
            
            guard let idOwner = data["owner"] as? String else {completion(nil); return}
            
            completion(idOwner)
            
        }
        
    }
    
    func onLoadAllCustomView(idObject: String, completion: @escaping ([Codable]) -> () ) {
        let headers = ["Authorization": authorization]
        let params = ["object_id": idObject]

        let request = LoadAllCustomViewRequest(params: params, headers: headers).asURLRequest()
        
        onUrlSession(request: request) { (dict, err) in
            guard let d = dict else {completion([]); return }
            guard let da = d["data"] as? [String: Any] else {completion([]); return }
            guard let array = da["custom_views"] as? [Any] else {completion([]); return }
            
            guard let data = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) else {completion([]); return}
            
            let decoder = JSONDecoder()
            guard let arr = try? decoder.decode([CustomViewModel].self, from: data) else {completion([]); return }
            
            completion(arr)
        }
        
    }
    
    func fetchCustomViewList(idObject: String, idCustom: String,completion: @escaping Handler) {
        //update search
        let params: [String: Any] = ["object_id":idObject, "custom_view_id": idCustom, "search_with": ["meta":[], "data":[]]]
        let headers = ["CurrentPage": String(1),"RecordPerPage": String(20),"Authorization": authorization]
        
        let request = FetchCustomViewListRequest(params: params, headers: headers).buildURLRequest()
        
        onUrlSession(request: request) { (dict, err) in
            guard let dic = dict else { completion([], nil); return }
            
            Logger.info(dic)
            
            let list = ObjectList(JSON: dic)
            
            if let arrList = list?.dataList {
                var arrStringName: [Any] = []
                
                for obj in arrList {
                    if let ob = obj as? [String: Any] {
                        if let objSub = ObjectSubList(JSON: ob) {
                            arrStringName.append(objSub)
                        }
                    }
                }
                
                completion(arrStringName, nil)
            } else {
                completion(nil, NSError.sessionExpired())
            }
        }
    }
    
    func fetchFieldsCustomView(objectId: String, completion: @escaping Handler) {
        let headers = ["CurrentPage": String(1),"RecordPerPage": String(20),"Authorization": authorization]
        let params: [String: Any] = ["object_id":objectId]
        
        let request = LoadFieldsCustomView(params: params, headers: headers).asURLRequest()
        
        onUrlSession(request: request) { (dictData, error) in
            //            print(dictData)
            guard let array = dictData?["data"] as? [Any] else {completion(nil,nil); return}
            let decode = JSONDecoder()
            
            var arrayModel: [FieldCustomView] = []
            
            array.forEach { (item) in
                guard let it = item as? [String: Any] else {return}
                
                guard let i = it["Field_Data"] as? [String: Any] else {return}
                
                let data = try? JSONSerialization.data(withJSONObject: i, options: .prettyPrinted)
                
                if let model = try? decode.decode(FieldCustomView.self, from: data ?? Data()) {
                    arrayModel.append(model)
                } else {
                    //                    completion(nil,nil)
                }
                
            }
            
            completion(arrayModel,nil)
        }
        
    }
    
    func deleteCustomView(objectId: String, customeViewId: String) {
        let headers = ["CurrentPage": String(1),"RecordPerPage": String(20),"Authorization": authorization]
        let params: [String: Any] = ["object_id":objectId,"custom_view_id": customeViewId]
        
        let request = DeleteCustomView(params: params, headers: headers).asURLRequest()
            
        onUrlSession(request: request) { (dictData, err) in
            if err != nil {
                NotificationCenter.default.post(name: Notification.Name("DELETE_CV"), object: nil, userInfo: ["data":false])
            } else {
                NotificationCenter.default.post(name: Notification.Name("DELETE_CV"), object: nil, userInfo: ["data":true])
            }
        }
    }
    
    func creatCustomView() {
        
    }
    
    /// call api
    /// - Parameters:
    ///   - request: api request
    ///   - completion: completion handler
    private func onUrlSession(request: URLRequest, completion: @escaping (_ js: [String:Any]?, _ err: Error?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, error)
//                    self.delegate?.presentError(NSError.unknownError())
                } else {
                    if let dat = data {
                        if let json = try? JSONSerialization.jsonObject(with: dat, options: []) as? [String: Any] {
                            Logger.info(json)
                            
                            completion(json, nil)
                            
                        } else {
                            completion(nil, error)
//                            self.delegate?.presentError(NSError.unknownError())
                        }
                    } else {
                        completion(nil, error)
//                        self.delegate?.presentError(NSError.unknownError())
                    }
                }
            }
        }.resume()
    }
}

extension Networking: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        
        completionHandler(.useCredential, urlCredential)
    }
}
