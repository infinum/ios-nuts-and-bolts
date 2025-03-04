//
//  CombinePagingInteractor.swift
//  Catalog
//
//  Created by Zvonimir Medak on 02.11.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import Combine
import Alamofire

final class CombinePagingInteractor {
    private let service: APIServiceable
    private let sessionManager: SessionManager

    init(service: APIServiceable = APIService.instance, sessionManager: SessionManager = .default) {
        self.service = service
        self.sessionManager = sessionManager
    }
}

// MARK: - Extensions -

@available(iOS 13, *)
extension CombinePagingInteractor: CombinePagingInteractorInterface {
    func getPokemons(router: Routable) -> AnyPublisher<PokemonsPage, AFError> {
        service
            .requestPublisher(
                PokemonsPage.self,
                router: router,
                session: Session.default
            )
    }

}
