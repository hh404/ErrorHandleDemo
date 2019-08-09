//
//  ErrorMapManager.swift
//  SwiftErrorHandleDemo
//
//  Created by chinaSoft on 2019/8/6.
//  Copyright © 2019 wangcenttest. All rights reserved.
//

import Foundation
import HandyJSON

struct ErrorMapItem: HandyJSON {

    var apiName: String!
    var status: Int?
    var errorCode: String?
    var title: String?
    var content: String?
    var btnTitle: String?
    var showType: ErrorShowType = .none
    var confirmAction: [ErrorConfirmActionType] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.apiName <-- "APIName"
        mapper <<< self.status <-- "Status"
        mapper <<< self.errorCode <-- "code"
        mapper <<< self.confirmAction <-- "action"
    }
}

enum ErrorShowType: String, HandyJSONEnum {
    
    case none = "none"
    case toast = "toast"
    case dialogue = "dialogue"
    case custom = "custom"
}

enum ErrorConfirmActionType: String, HandyJSONEnum {
    
    case none = "none"
    case dismiss = "dismiss"
    case back = "back"
    case logout = "logout"
    case custom = "custom"
}

class ErrorMapManager: NSObject {
    static let shared = ErrorMapManager()
     private var errorMapArray: [ErrorMapItem] = []
    
    override init() {
        super.init()
        let errorJsonString = try! String.init(contentsOfFile: Bundle.main.path(forResource: "error", ofType: "json")!, encoding: String.Encoding.utf8)
        let array: [Dictionary<String,Any>]? = getArrayFromJSONString(jsonString: errorJsonString) as? [Dictionary<String, Any>]
        if let array = array {
            for item in array {
                let errorItem = ErrorMapItem.deserialize(from: item)
                if let errorItem = errorItem {
                    errorMapArray.append(errorItem)
                }
            }
        }
        print(errorMapArray)
    }
    
    private func errorMapItem(_ error: HansHttpError) -> ErrorMapItem? {
        let errorItem = errorMapArray.filter { (item) -> Bool in
            if item.errorCode == error.errorCode {
                return true
            }
            else {
                return false
            }
        }
        return errorItem.first
    }
    
    func titleForError(_ error: HansHttpError) -> String? {
        return self.errorMapItem(error)?.title
    }
    
    func content(_ error: HansHttpError) -> String? {
        return self.errorMapItem(error)?.content
    }
    
    func btnTitle(_ error: HansHttpError) -> String? {
        return self.errorMapItem(error)?.btnTitle
    }
    
    func showType(_ error: HansHttpError) -> ErrorShowType {
        return self.errorMapItem(error)?.showType ?? .none
    }
    
    func confirmAction(_ error: HansHttpError) -> [ErrorConfirmActionType] {
        return self.errorMapItem(error)?.confirmAction ?? []
    }
}



