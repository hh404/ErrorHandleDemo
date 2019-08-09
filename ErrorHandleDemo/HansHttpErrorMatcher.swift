//
//  HansHttpErrorMatcher.swift
//  ErrorHandleDemo
//
//  Created by chinaSoft on 2019/8/6.
//  Copyright © 2019 hans. All rights reserved.
//

import Foundation
//import ErrorHandler

struct HansHttpErrorMatcher: ErrorMatcher {
    var status: Int?
    var errorCode: String?
    let apiName: String!
    func matches(_ error: Error) -> Bool {
        let customError: HansHttpError? = error as? HansHttpError
        if let customError = customError, let  customErrorCode = customError.errorCode {
            
            if self.errorCode == customErrorCode {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
}

extension ErrorHandler {
    public func onHansError(apiName: String, status: Int?, code: String? = nil, do action: @escaping ErrorAction) -> ErrorHandler {
        return self.on(HansHttpErrorMatcher(status: status, errorCode: code, apiName: apiName), do: action)
    }
}
