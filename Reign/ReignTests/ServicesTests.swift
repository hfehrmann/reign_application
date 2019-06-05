//
//  ios_recruiting_hsaTests.swift
//  ios-recruiting-hsaTests
//
//  Created by Hans Fehrmann on 5/27/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import XCTest
import Moya
@testable import Reign

class ReignApiClientTests: XCTestCase {

    func testDefaultApiClientConstruction() {
        let defaulApiClient = apiClientDefault()
        XCTAssertNotNil(defaulApiClient)
    }

    func testErrorReponseApiClient() {
        let domain = "custom"
        let code = 400
        let endpointClosure = { (target: ReignEndpoint) -> Endpoint in
            let error = NSError(domain: domain, code: code, userInfo: nil)
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: {.networkError(error)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let provider = MoyaProvider(
            endpointClosure: endpointClosure,
            stubClosure: { _ in .immediate }
        )
        let apiClient = ApiClientImpl(provider: provider)

        apiClient.request(endpoint: .search) { maybeData, maybeError in
            XCTAssertNil(maybeData)
            XCTAssertNotNil(maybeError)
            let error = maybeError!
            if case .failedRequest(let underlyingError) = error {
                XCTAssertNotNil(underlyingError)
                let nsError = underlyingError! as NSError
                XCTAssertEqual(nsError.code, code)
                XCTAssertEqual(nsError.domain, domain)
            } else {
                XCTFail("Given an NSError, this branch should never be executed")
            }
        }
    }

    func testGoodReponseBadStatusCodeApiClient() {
        let responseCode = 400
        let endpointClosure = { (target: ReignEndpoint) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: {.networkResponse(responseCode, target.sampleData)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let provider = MoyaProvider(
            endpointClosure: endpointClosure,
            stubClosure: { _ in .immediate }
        )
        let apiClient = ApiClientImpl(provider: provider)
        apiClient.request(endpoint: .search) { maybeData, maybeError in
            XCTAssertNil(maybeData)
            XCTAssertNotNil(maybeError)
            let error = maybeError!
            if case .statusCode(let code) = error {
                XCTAssertEqual(code, responseCode)
            } else {
                XCTFail("Given an an error response, this branch should never be executed")
            }
        }
    }

    func testGoodReponseGoodStatusCodeApiClient() {
        let responseCode = 200
        let endpointClosure = { (target: ReignEndpoint) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: {.networkResponse(responseCode, target.sampleData)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let provider = MoyaProvider(
            endpointClosure: endpointClosure,
            stubClosure: { _ in .immediate }
        )
        let apiClient = ApiClientImpl(provider: provider)
        apiClient.request(endpoint: .search) { maybeData, maybeError in
            XCTAssertNil(maybeError)
            XCTAssertNotNil(maybeData)
        }
    }

}
