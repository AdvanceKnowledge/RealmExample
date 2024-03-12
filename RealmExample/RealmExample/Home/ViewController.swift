//
//  ViewController.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLab: UILabel!
    
    @IBOutlet weak var activity_view: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity_view.isHidden = true
        getWeather()
    }
    @IBAction func delegateAll(_ sender: UIButton) {
        RealmManager.share.deleteAll()
    }
    
    @IBAction func printWeather(_ sender: UIButton) {
        let model2 = RealmManager.getFirstObject(WeatherModel.self)
        BTPrint.print(model2)
        titleLab.text = model2.data!.ganmao
    }
    @IBAction func getWeather(_ sender: UIButton) {
        getWeather()
    }
    
    func getWeather() {
    
        self.activity_view.startActivityView()
        ServiceProxy.share.wylGetmodel(target: HomeTarget.weather(cityCode: "101010100"), type: WeatherModel_HandyJSON.self) { msg in
            BTPrint.print(msg)
        } complish: { model in
            var weatherModel = WeatherModel().create(by: model) as! WeatherModel
            weatherModel.custom_Value = "自定义数据"
            RealmManager.share.updateObject(weatherModel)
            BTPrint.print(model)
        } finally: {
            self.activity_view.stopActivityView()
        }
    }
}

