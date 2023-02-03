//
//  RxPagingViewController.swift
//  Catalog
//
//  Created by Filip Gulan on 13/09/2019.
//  Copyright (c) 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class RxPagingViewController: UIViewController, Refreshable {

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        return refreshControl
    }()

    // MARK: - Private properties

    private let disposeBag = DisposeBag()

    private lazy var tableDataSource: TableDataSourceDelegate = {
        return TableDataSourceDelegate(tableView: tableView)
    }()

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.registerClass(cellOfType: PokemonTableViewCell.self)
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagination()
    }
	
}

// MARK: - Extensions -

private extension RxPagingViewController {

    func setupPagination() {
        let item = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = item
        
        let sort = item.rx.tap
            .asDriver()
            .scan(false) { state, _ in !state }
        
        let pullToRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .mapToVoid()

        let willDisplayLastCell = tableView.rx
            .reachedBottomOnceWith(restart: pullToRefresh)

        let pokemon = pokemonPaging(
            loadNextPage: willDisplayLastCell,
            reload: pullToRefresh,
            sort: sort
        )

        pokemon
            .map { $0.map(PokemonTableCellItem.init) }
            .do(onNext: { [unowned self] _ in self.endRefreshing() })
            .bind(to: tableDataSource.rx.items)
            .disposed(by: disposeBag)
    }

}

private extension RxPagingViewController {

    typealias Container = [Pokemon]
    typealias Page = PokemonPage
    typealias PagingEvent = Paging.Event<Container>

    func pokemonPaging(loadNextPage: Driver<Void>, reload: Driver<Void>, sort: Driver<Bool>) -> Observable<[Pokemon]> {
        let sortItems = sort.map { ascending in
            return PagingEvent.update { ascending ? $0.sorted() : $0.sorted().reversed() }
        }

        let events = Driver
            .merge(
                loadNextPage.mapTo(PagingEvent.nextPage),
                reload.startWith(()).mapTo(PagingEvent.reload), // Start initial load
                sortItems
            )

        func nextPage(container: Container, lastPage: Page?) -> Single<PokemonPage> {
            // Fetch pokemons in batch of 60, no last page represents inital load
            let url = lastPage?.next?.absoluteString ?? "https://pokeapi.co/api/v2/pokemon?limit=60"
            let router = Router(baseUrl: url, path: "")

            return APIService
                .instance
                .rx.request(
                    PokemonPage.self,
                    router: router,
                    session: Session.default
                )
        }

        func accumulator(_ container: Container, _ page: Page) -> Container {
            return container + page.results
        }
        
        func hasNext(container: Container, lastPage: Page) -> Bool {
            return lastPage.next != nil
        }

        let response = Paging
            .page(
                make: nextPage,
                startingWith: [],
                joining: accumulator,
                while: hasNext,
                on: events.asObservable()
            )
        return response.map { $0.container }
    }
}

extension RxPagingViewController: Catalogizable {

    static var title: String {
        return "Rx Paging"
    }

    static var viewController: UIViewController {
        return RxPagingViewController()
    }
}
