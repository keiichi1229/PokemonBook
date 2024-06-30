//
//  MockApiProvider.swift
//  PokemonBookTests
//
//  Created by Raymondting on 2024/6/29.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON
import Alamofire
@testable import PokemonBook

class MockApiProvider: ApiProvider {
    override init() {}
    var callRequest = false
    var responses: [JSON] = []
    var responseJSON = JSON()
    var responseError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Error Test"])
    var isRequestSuccess: Bool = true
    var requestParameters: [String : Any] = [:]
    private var provider = MoyaProvider<MultiTarget>()
    
    override func request<Request>(_ request: Request) -> Single<Any> where Request : TargetType {
        let target = MultiTarget.init(request)
        getRequestParams(target)
        callRequest = true
        if isRequestSuccess {
            if responses.count > 0 {
                let dict = responses.remove(at: 0)
                return Single.just(dict)
            }
            return Single.just(responseJSON)
        }
        return Single.error(responseJSON.count > 1 ? MoyaError.jsonMapping(Response(statusCode: 200, data: try! responseJSON.rawData())) : responseError)
    }
    
    override func observe<Request>(_ request: Request) -> Observable<Event<Any>> where Request : TargetType {
        callRequest = true
        return self.request(request).asObservable().materialize()
    }
    
    func getRequestParams(_ target: TargetType) {
        switch target.task {
        case let .requestParameters(parameters, _):
            self.requestParameters = parameters
        default:
            break
        }
    }
    
    static func readJSONFromFile(fileName: String) -> JSON {
        let bundle = Bundle(for: MockApiProvider.self)
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSON(data: data)
                return json
            } catch {
                print("Error: \(error)")
                return JSON()
            }
        }
        return JSON()
    }
}
