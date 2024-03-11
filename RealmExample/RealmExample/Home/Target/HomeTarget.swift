//
//  HomeTarget.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import Foundation
import Moya
enum HomeTarget {
    case weather(cityCode: String)
}


extension HomeTarget: TargetType{
    var baseURL: URL {
        return URL(string: "http://t.weather.itboy.net")!
    }
    
    var path: String {
        switch self {
        case .weather(let cityCode):
            return AppApi().weather + cityCode
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .weather:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
