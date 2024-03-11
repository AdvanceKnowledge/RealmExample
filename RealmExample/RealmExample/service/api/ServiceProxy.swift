//
//  ServiceProxy.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import UIKit
import Moya
import HandyJSON
///网络请求超时设置
fileprivate func defaultRequestMapping(for endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) {
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 20 //超时设置
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

class ServiceProxy: NSObject {
    let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
        
        do {
            var urlRequest = try endpoint.urlRequest()
            urlRequest.timeoutInterval = 2 //超时设置
            done(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            done(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            done(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    private let provider: MoyaProvider<MultiTarget>
    var cancelable: Cancellable?
    static let share = ServiceProxy()
    /**:
     > # IMPORTANT: 初始化方法
     参数说明：
     1. plugins 网络请求的配置项 目前的默认值是为每个请求添加令牌
     ---
     [More info - ——](——)
     */
    override init() {
        self.provider = MoyaProvider<MultiTarget>()
    }
    
    
    func wylGetmodel<E: HandyJSON>(target: TargetType, needCheckNull: Bool = false, type: E.Type, error: ((String?) -> Void)? = nil, complish: @escaping (E) -> Void) {
        self.request(target: target, needCheckNull: needCheckNull, error: { message in
            error?(message)
        }, complish: { (response) in
            guard let r = response else {
                error?("暂无数据")
                return
            }
            let dic = self.dataToDictionary(data: r.data) ?? Dictionary<String, Any>()
            let model = E.deserialize(from: dic) ?? E()
            complish(model)
        })
    }
    
    /**
     * 数据请求方法，方便配置
     */
    private func request(target: TargetType, needCheckNull: Bool = false, error: ((String?) -> Void)? = nil, complish: @escaping (Moya.Response?) -> Void) {
        self.cancelable = provider.request(MultiTarget(target)) { [] (result) in
            
            switch result {
            case .success(let response):
                self.printServiceInfo(target: target, data: response, error: nil)
                switch response.statusCode {
                case 200:
                    complish(response)
                case 401, 400:
                    error?("服务错误\(response.statusCode)")
                case 500:
                    error?("服务错误\(response.statusCode)")
                case 502:
                    error?("网络超时\(response.statusCode)")
                default:
                    error?("服务错误\(response.statusCode)")
                }
            case .failure(let e):
                self.printServiceInfo(target: target, data: nil, error: e)
                error?(e.localizedDescription)
            }
        }
    }
    
    /// data转字典
    /// - Parameter data:
    /// - Returns:
    func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch _ {
            print("失败")
            return nil
        }
    }
    
    /// 打印请求信息
    /// - Parameters:
    ///   - target: 请求接口
    ///   - data: 返回数据
    ///   - error: 错误信息
    func printServiceInfo(target: TargetType, data: Moya.Response?, error: Error?) {
        var url = "\(target.baseURL)\(target.path)"
        if data != nil {
            url = data?.request?.url?.absoluteString ?? ""
        }
        var result: Any = "暂无数据"
        var errorMsg = ""
        
        if data != nil {
            do {
                result = try JSONSerialization.jsonObject(with: data!.data, options: .mutableContainers)
            } catch {
                result = String(data:data!.data, encoding: .utf8)!
            }
        }
        if url == "https://ttt.ebanktest.com.cn:39022/geyModel" {
            if data != nil {
                BTPrint.print(String(data:data!.data, encoding: .utf8)!)
            }
        }
        let dic = [
            "1、链接地址": url,
            "2、返回数据": result,
            "3、请求头": self.provider.plugins as Any,
            "4、target": target,
            "5、错误信息": error?.localizedDescription ?? ""
        ] as [String : Any]
        BTPrint.printBeforeLine(content: "请求接口信息---START")
        BTPrint.print(dic)
//        BTPrint.print(data?.request?.allHeaderFields)
        BTPrint.printAfterLine(content: "请求接口信息---END")
    }
}
