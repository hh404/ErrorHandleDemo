//
//  DialogueDatasourceProtocol.swift
//  ErrorHandleDemo
//
//  Created by chinaSoft on 2019/8/6.
//  Copyright © 2019 hans. All rights reserved.
//

import Foundation

protocol DialogueDatasource {
    func dialogueTitle() -> String?
    func dialogueContent() -> String?
    func dialogueButtonTitle() -> String?
}
