//
//  ViewController.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
    }
    @IBAction func delegateAll(_ sender: UIButton) {
        RealmManager.share.deleteAll()
    }
    
    @IBAction func printWeather(_ sender: UIButton) {
        let model2 = RealmManager.getFirstObject(WeatherModel.self)
        BTPrint.print(RealmManager.share.findObjects(withType: WeatherModel.self))
        titleLab.text = model2.data!.ganmao
    }
    @IBAction func getWeather(_ sender: UIButton) {
        getWeather()
    }
    
    func getWeather() {
        ServiceProxy.share.wylGetmodel(target: HomeTarget.weather(cityCode: "101010100"), type: WeatherModel_HandyJSON.self) { msg in
            BTPrint.print(msg)
        } complish: { model in
            let weatherModel = WeatherModel().create(by: model)
            RealmManager.share.updateObject(weatherModel)
            BTPrint.print(model)
        }
    }
}

