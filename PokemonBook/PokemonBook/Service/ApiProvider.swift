//
//  ApiProvider.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

public class ApiProvider {
    
    public static let shared = ApiProvider()
    internal init() {}
    
    private var provider = MoyaProvider<MultiTarget>()
    
    func request<Request: TargetType>(_ request: Request) -> Single<Any> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .catch { error in
                #if DEBUG
                if let moyaErr = error as? MoyaError, let response = moyaErr.response {
                    print("API Fail: \(request.baseURL.absoluteString + request.path)")
                    print("\(JSON(try response.mapJSON()))")
                    print("=================================")
                }
                #endif
                return Single.error(error)
            }
    }
    
    // for zip
    func observe<Request: TargetType>(_ request: Request) -> Observable<Event<Any>> {
        let target = MultiTarget(request)
        return self.request(target)
            .asObservable()
            .materialize()
    }
}
