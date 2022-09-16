//
//  ASAuthorizationController+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineCocoa
import AuthenticationServices

@available(iOS 13.0, *)
public extension ASAuthorizationController {

    // MARK: - Public properties -

    /// Publisher which emits merged values from **didCompleteWithAuthorizationPublisher** and **didCompleteWithAuthorizationPublisher**
    var didCompleteAuthorizationPublisher: AnyPublisher<Result<ASAuthorization, Error>, Never> {
        Publishers
            .Merge(didCompleteWithAuthorizationPublisher, didCompleteWithErrorPublisher)
            .eraseToAnyPublisher()
    }

    /// Publisher which emits a value from **authorizationController(controller:didCompleteWithAuthorization:)**
    var didCompleteWithAuthorizationPublisher: AnyPublisher<Result<ASAuthorization, Error>, Never> {
        let selector = #selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:))
        return delegateProxy.interceptSelectorPublisher(selector)
            .map { $0[1] as! ASAuthorization }
            .map { .success($0) }
            .eraseToAnyPublisher()
    }

    /// Publisher which emits a value from **authorizationController(controller:didCompleteWithError:)**
    var didCompleteWithErrorPublisher: AnyPublisher<Result<ASAuthorization, Error>, Never> {
        let selector = #selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithError:))
        return delegateProxy.interceptSelectorPublisher(selector)
            .map { $0[1] as! Error }
            .map { .failure($0) }
            .eraseToAnyPublisher()
    }

    // MARK: - Private properties -

    private var delegateProxy: ASAuthorizationControllerDelegateProxy {
        .createDelegateProxy(for: self)
    }
}

// MARK: - Delegate proxy -

@available(iOS 13.0, *)
private class ASAuthorizationControllerDelegateProxy: DelegateProxy, ASAuthorizationControllerDelegate, DelegateProxyType {
    func setDelegate(to object: ASAuthorizationController) {
        object.delegate = self
    }
}
