//
//  OAuthAuthenticator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Alamofire
import Combine
import Foundation

final class OAuthAuthenticator: Authenticator {
    typealias Credential = OAuthCredential

    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.requestId(UUID().uuidString))
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        switch credential {
        case .user(let userCredential):
            Self.refresh(userCredential: userCredential, for: session, completion: completion)
        case .client(let clientCredential):
            Self.refresh(clientCredential: clientCredential, for: session, completion: completion)
        }
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}

// MARK: - Extensions -

// MARK: - Token refreshing

extension OAuthAuthenticator {

    static func refresh(
        userCredential: OAuthUserCredential,
        for session: Session,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        // Set the proper user model on AFDataResponse or modify the example one
        let requestHandler: (AFDataResponse<UserAuthenticatedModel>) -> Void = { response in
            switch response.result {
            case .success(let value):
                Self.handle(userTokenRefreshUsing: value, completion: completion)
            case .failure(let error):
                Self.handle(tokenRefreshFailureUsing: error, completion: completion)
            }
        }

        // Request the token refresh using the provided session, and call the requestHandler for the completionHandler on responseDecodable
        // Don't forget to validate the request
    }

    static func refresh(
        clientCredential: OAuthClientCredential,
        for session: Session,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        // Set the proper client model on AFDataResponse or modify the example one
        let requestHandler: (AFDataResponse<ClientAuthenticatedModel>) -> Void = { response in
            switch response.result {
            case .success(let value):
                Self.handle(clientTokenRefreshUsing: value, completion: completion)
            case .failure(let error):
                Self.handle(tokenRefreshFailureUsing: error, completion: completion)
            }
        }

        // Request the client token refresh using the provided session, and call the requestHandler for the completionHandler on responseDecodable
        // Don't forget to validate the request
    }
}

// MARK: - Refresh handlers

private extension OAuthAuthenticator {

    // Modify the UserAuthenticatedModel to suit your needs
    static func handle(
        userTokenRefreshUsing model: UserAuthenticatedModel,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        let credential = OAuthUserCredential(
            accessToken: model.accessToken,
            refreshToken: model.refreshToken,
            expiration: Date(timeIntervalSinceNow: model.expiresIn)
        )
        completion(.success(.user(credential)))

        // Notify and save the new model/required properties in sessionManager
        let object = ["AccessTokenRefreshed": model]
        NotificationCenter.default.post(name: .init(rawValue: "AccessTokenRefreshed"), object: object)
    }

    // Modify the ClientAuthenticatedModel to suit your needs
    static func handle(
        clientTokenRefreshUsing model: ClientAuthenticatedModel,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        let credential = OAuthClientCredential(
            accessToken: model.accessToken,
            expiration: Date(timeIntervalSinceNow: model.expiresIn)
        )
        completion(.success(.client(credential)))

        // Notify and save the new model/required properties in sessionManager
        let object = ["ClientTokenRefreshed": model]
        NotificationCenter.default.post(name: .init(rawValue: "ClientTokenRefreshed"), object: object)
    }

    static func handle(
        tokenRefreshFailureUsing error: Error,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        completion(.failure(error))

        // Notify that the session has expired
        // No actual model to send here, we just want to notify any concerning observers that we didn't manage to restore the session
        // So that we get to clean up any potential related resources
        NotificationCenter.default.post(name: .init(rawValue: "SessionExpired"), object: nil)
    }
}

