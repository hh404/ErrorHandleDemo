//
//  HansHttpError.swift
//  ErrorHandleDemo
//
//  Created by chinaSoft on 2019/8/6.
//  Copyright © 2019 hans. All rights reserved.
//

import Foundation

struct HansHttpError: Error {
    let apiName: String!
    var status: Int?
    var errorCode: String?
}

extension HansHttpError: DialogueDatasource {
    func dialogueTitle() -> String? {
        return ErrorMapManager.shared.titleForError(self)
    }
    
    func dialogueContent() -> String? {
        return ErrorMapManager.shared.content(self)
    }
    
    func dialogueButtonTitle() -> String? {
        return ErrorMapManager.shared.btnTitle(self)
    }
}
