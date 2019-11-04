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
        _tableView.refreshControl = refreshControl
        return refreshControl
    }()

    // MARK: - Private properties

    private let _disposeBag = DisposeBag()

    private lazy var _dataSourceDelegate: TableDataSourceDelegate = {
        return TableDataSourceDelegate(tableView: _tableView)
    }()

    // MARK: - IBOutlets

    @IBOutlet private weak var _tableView: UITableView! {
        didSet {
            _tableView.tableFooterView = UIView(frame: .zero)
            _tableView.registerClass(cellOfType: PokemonTableViewCell.self)
            if #available(iOS 11.0, *) {
                _tableView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        }
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupPagination()
    }
	
}

// MARK: - Extensions -

private extension RxPagingViewController {


    func _setupPagination() {
        let item = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = item
        
        let sort = item.rx.tap
            .asDriver()
            .scan(false) { (state, _) in !state }
        
        let pullToRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .mapToVoid()

        let willDisplayLastCell = _tableView.rx
            .reachedBottomOnceWith(restart: pullToRefresh)

        let pokemons = _pokemons(
            loadNextPage: willDisplayLastCell,
            reload: pullToRefresh.startWith(()), // Start initial load
            sort: sort
        )

        pokemons
            .map { $0.map(PokemonTableCellItem.init) }
            .map { $0 as [TableCellItem] }
            .do(onNext: { [unowned self] _ in self.endRefreshing() })
            .bind(to: _dataSourceDelegate.rx.items)
            .disposed(by: _disposeBag)
    }

}

private extension RxPagingViewController {

    typealias Container = [Pokemon]
    typealias Page = PokemonsPage
    typealias PagingEvent = Paging.Event<Container>

    func _pokemons(loadNextPage: Driver<Void>, reload: Driver<Void>, sort: Driver<Bool>) -> Observable<[Pokemon]> {
        let sortItems = sort.map { ascending in
            return PagingEvent.update { ascending ? $0.sorted() : $0.sorted().reversed() }
        }

        let events = Driver
            .merge(
                loadNextPage.mapTo(PagingEvent.nextPage),
                reload.mapTo(PagingEvent.reload),
                sortItems
            )

        func nextPage(container: Container, lastPage: Page?) -> Single<PokemonsPage> {
            // Fetch pokemons in batch of 60, no last page represents inital load
            let url = lastPage?.next?.absoluteString ?? "https://pokeapi.co/api/v2/pokemon?limit=60"
            let router = Router(baseUrl: url, path: "")

            return APIService
                .instance
                .rx.request(
                    PokemonsPage.self,
                    router: router,
                    sessionManager: SessionManager.default
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
