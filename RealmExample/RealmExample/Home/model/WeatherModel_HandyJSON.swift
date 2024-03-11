//
//  WeatherModel.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import UIKit
import HandyJSON

class WeatherModel_HandyJSON: NSObject, HandyJSON  {
    ///主键
    var message = ""
    var status = ""
    var date = ""
    var time = ""
    var cityInfo = CityInfo_HandyJSON()
    var data = DataModel_HandyJSON()
    public override required init() {}
}

class CityInfo_HandyJSON:NSObject, HandyJSON{
    var city = ""
    var citykey = ""
    var parent = ""
    var updateTime = ""
    public override required init() {}
}

class DataModel_HandyJSON:NSObject, HandyJSON {
    var shidu = ""
    var pm25 = 0
    var pm10 = 0
    var quality = ""
    var wendu = ""
    var ganmao = ""
    var forecast = [ForecastModel_HandyJSON]()
    var yesterday = ForecastModel_HandyJSON()
    public override required init() {}
}

class ForecastModel_HandyJSON:NSObject, HandyJSON{
    var date = ""
    var high = ""
    var low = ""
    var ymd = ""
    var week = ""
    var sunrise = ""
    var sunset = ""
    var aqi = 0
    var fx = ""
    var fl = ""
    var type = ""
    var notice = ""
    public override required init() {}
}


