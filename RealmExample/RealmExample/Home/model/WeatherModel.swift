//
//  WeatherModel.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import UIKit
import HandyJSON
import RealmSwift

class WeatherModel:Object  {
    ///主键
    @objc dynamic var id = 0
    @objc dynamic var message = ""
    @objc dynamic var status = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var custom_Value = ""
    @objc dynamic var cityInfo: CityInfo? = CityInfo()
    @objc dynamic var data: DataModel? = DataModel()
    override static func primaryKey() -> String? {
        return "id"
    }
    override required init() {}
}

class CityInfo:Object{
    @objc dynamic var city = ""
    @objc dynamic var citykey = ""
    @objc dynamic var parent = ""
    @objc dynamic var updateTime = ""
    override required init() {
    }
}

class DataModel:Object {
    @objc dynamic var shidu = ""
    @objc dynamic var pm25 = 0
    @objc dynamic var pm10 = 0
    @objc dynamic var quality = ""
    @objc dynamic var wendu = ""
    @objc dynamic var ganmao = ""
    var forecast = List<ForecastModel>()
    @objc dynamic var yesterday: ForecastModel? = ForecastModel()
    override required init() {
    }
}

extension DataModel{
    @objc override func configListValue(models:[Any],key: String) {
        for item in models {
            if key == "forecast" {
                self.forecast.append(ForecastModel().create(by: item as! HandyJSON) as! ForecastModel)
            }
        }
    }
}
class ForecastModel:Object{
    @objc dynamic var date = ""
    @objc dynamic var high = ""
    @objc dynamic var low = ""
    @objc dynamic var ymd = ""
    @objc dynamic var week = ""
    @objc dynamic var sunrise = ""
    @objc dynamic var sunset = ""
    @objc dynamic var aqi = 0
    @objc dynamic var fx = ""
    @objc dynamic var fl = ""
    @objc dynamic var type = ""
    @objc dynamic var notice = ""
    override required init() {
    }
}
