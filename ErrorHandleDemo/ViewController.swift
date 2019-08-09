//
//  ViewController.swift
//  ErrorHandler
//
//  Created by kremizask on 09/01/2017.
//  Copyright (c) 2017 kremizask. All rights reserved.
//

import UIKit
import HandyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let errorJsonString = try! String.init(contentsOfFile: Bundle.main.path(forResource: "error", ofType: "json")!, encoding: String.Encoding.utf8)
        print(errorJsonString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   

}

func getArrayFromJSONString(jsonString:String) ->NSArray{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if array != nil {
        return array as! NSArray
    }
    return array as! NSArray
    
}

struct AAa: OptionSet, HandyJSON {
    let rawValue: Int
    
    static let a = AAa(rawValue: 1 << 0)
    static let b = AAa(rawValue: 1 << 1)
    static let c = AAa(rawValue: 1 << 2)
    
    static let all: AAa = [.a, .b, .c]
}
