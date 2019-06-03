//
//  MovieClient.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/29/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation

enum ReignClientError: Error {
    case decoded(description: String)
    case underlying(error: Error)
    case apiError(error: ApiError)
}

protocol Client {
    func articlesSearch(
        onSuccess: ((ArticlesApiRepsonse) -> Void)?,
        onError: ((ReignClientError) -> Void)?
    )
}

func clientDefault() -> Client {
    return ClientImpl(apiClient: apiClientDefault())
}

// MARK: - Implementation

class ClientImpl {

    let apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}

extension ClientImpl: Client {

    func articlesSearch(
        onSuccess: ((ArticlesApiRepsonse) -> Void)? = nil,
        onError: ((ReignClientError) -> Void)? = nil
    ) {
        apiClient.request(endpoint: .search) { [weak self] data, error in
            self?.decode(
                for: ArticlesApiRepsonse.self,
                withData: data,
                onSuccess: onSuccess,
                withError: error,
                onError: onError
            )
        }
    }

    private func decode<T: Decodable>(
        for type: T.Type,
        withData data: Data?,
        onSuccess: ((T) -> Void)?,
        withError error: ApiError?,
        onError: ((ReignClientError) -> Void)?
    ) {
        if let data = data {
            do {
                let movies = try JSONDecoder().decode(type, from: data)
                onSuccess?(movies)
            } catch DecodingError.dataCorrupted(let context) {
                onError?(.decoded(description: context.debugDescription))
            } catch {
                onError?(.underlying(error: error))
            }
        } else if let error = error {
            onError?(.apiError(error: error))
        }
    }
}
