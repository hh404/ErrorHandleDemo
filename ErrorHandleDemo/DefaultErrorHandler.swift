//
//  DefaultErrorHandler.swift
//  Example-iOS
//
//  Created by Eleni Papanikolopoulou on 05/08/2017.
//  Copyright © 2017 Workable. All rights reserved.
//

import UIKit
//import ErrorHandler

protocol LoggableError: Error {
    var loggableDescripiton: String { get }
}

enum CustomError: Error, LoggableError {
    case unknown
    case parsingError
    
    var loggableDescripiton: String {
        return String(describing: self)
    }
}

extension ErrorHandler {
    static var `default` : ErrorHandler {
        
        return ErrorHandler()
            .onAFError(withStatus: 400..<451, do: { (error) -> MatchingPolicy in
                AlertManager.showAlert(title: "Client error")
                return .continueMatching
            })
            .onAFError(withStatus: 500..<512, do: { (_) -> MatchingPolicy in
                AlertManager.showAlert(title: "Server Error")
                return .continueMatching
            })
            .onAFError(withStatus: 401, do: { (error) -> MatchingPolicy in
                AlertManager.showAlert(title: "Unauthorized errror", message: "You are not authorized for this action.")
                return .stopMatching
            })
            .onNSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, do: { (error) -> MatchingPolicy in
                AlertManager.showAlert(title: "You seem to be offline", message: "Check your connection and try again.")
                return .continueMatching
            })
            .on(CustomError.parsingError, do: { (error) -> MatchingPolicy in
                AlertManager.showAlert(title: "Parsing Error")
                return .continueMatching
            })
            .tag(AFErrorStatusCodeMatcher(400..<512), with: "http")
            .onNoMatch(do: { (error) -> MatchingPolicy in
                AlertManager.showAlert(title: "Unknown error", message: "Oops.. Something went wrong.")
                return .continueMatching
            })
            .always(do: { (error) -> MatchingPolicy in
                print((error as? LoggableError)?.loggableDescripiton ?? error.localizedDescription)
                return .continueMatching
            })
    }
    
    static func defaultHandle(_ code: String) -> ErrorHandler {
        return ErrorHandler().onHansError(apiName: "originError.apiName", status: 400, code: code, do: { (error) -> MatchingPolicy in
            let hanError: HansHttpError? = error as? HansHttpError
            if let hanError = hanError {
                let showType = ErrorMapManager.shared.showType(hanError)
                switch showType {
                case .none:
                    AlertManager.showAlert(title: "none", message: String.init(format: "title:%@content:%@action:%@", ErrorMapManager.shared.titleForError(hanError) ?? "",ErrorMapManager.shared.content(hanError) ?? "",ErrorMapManager.shared.confirmAction(hanError).first?.rawValue ?? ""))
                    break
                case .toast:
                    AlertManager.showAlert(title: "toast",message: String.init(format: "title:%@content:%@action:%@", ErrorMapManager.shared.titleForError(hanError) ?? "",ErrorMapManager.shared.content(hanError) ?? "",ErrorMapManager.shared.confirmAction(hanError).first?.rawValue  ?? ""))
                    break
                case .dialogue:
                    AlertManager.showAlert(title: "dialogue", message: String.init(format: "title:%@content:%@action:%@", ErrorMapManager.shared.titleForError(hanError) ?? "",ErrorMapManager.shared.content(hanError) ?? "",ErrorMapManager.shared.confirmAction(hanError).first?.rawValue  ?? ""))
                    break
                case .custom:
                    AlertManager.showAlert(title: "custom", message: String.init(format: "title:%@content:%@action:%@", ErrorMapManager.shared.titleForError(hanError) ?? "",ErrorMapManager.shared.content(hanError) ?? "",ErrorMapManager.shared.confirmAction(hanError).first?.rawValue  ?? ""))
                    return .stopMatching
                }
            }
            return .continueMatching
        })
    }
}
