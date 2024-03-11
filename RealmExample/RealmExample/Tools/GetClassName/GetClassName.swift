//
//  GetClassName.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/8.
//

import Foundation
extension NSObject{
    var className1: String {
        return NSStringFromClass(type(of: self))
    }
    
    var className2: String {
        return String(describing: type(of: self))
    }
    
    static func className3(_ obj: Any) -> String {
        // prints more readable results for dictionaries, arrays, Int, etc
        return String(describing: type(of: obj))
    }
    
    
}
