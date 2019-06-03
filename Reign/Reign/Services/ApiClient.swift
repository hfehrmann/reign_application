//
//  APIClient.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/27/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import Moya

enum ReignEndpoint {
    case search
}

enum ApiError {
    case statusCode(Int)
    case failedRequest(Error?)
    case unknown(Error)
}

typealias Callback = (Data?, ApiError?) -> Void

protocol ApiClient {
    func request(endpoint: ReignEndpoint, callback: @escaping Callback)
}

func apiClientDefault() -> ApiClient {
    let provider = MoyaProvider<ReignEndpoint>()
    return ApiClientImpl(provider: provider)
}

// MARK: - Implementation

extension ReignEndpoint: TargetType {

    var baseURL: URL { return URL(string: "http://hn.algolia.com" )! }

    var path: String {
        switch self {
        case .search: return "api/v1/search_by_date"
        }
    }

    var method: Moya.Method { return .get }

    var sampleData: Data { return Data() }

    var task: Task {
        return .requestParameters(parameters: ["query": "ios"], encoding: JSONEncoding.default)
    }

    var headers: [String: String]? { return nil }
}

class ApiClientImpl {

    let provider: MoyaProvider<ReignEndpoint>

    init(provider: MoyaProvider<ReignEndpoint>) {
        self.provider = provider
    }
}

extension ApiClientImpl: ApiClient {

    func request(endpoint: ReignEndpoint, callback: @escaping Callback) {
        provider.request(endpoint) { result in
            switch result {
            case .success(let response):
                if let filteredResponse = try? response.filterSuccessfulStatusCodes() {
                    callback(filteredResponse.data, nil)
                } else {
                    callback(nil, .statusCode(response.statusCode))
                }
            case .failure(let error):
                let error = error.errorUserInfo[NSUnderlyingErrorKey] as? Swift.Error
                callback(nil, .failedRequest(error))
            }
        }
    }
}
