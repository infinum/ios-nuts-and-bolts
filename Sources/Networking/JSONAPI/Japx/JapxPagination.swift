//
//  JapxPagination.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Japx

public enum Pagination {

    public struct Response<T: JapxCodable>: Codable {
        public let data: [T]
        public let meta: Meta

        public init(data: [T], meta: Meta) {
            self.data = data
            self.meta = meta
        }
    }

    public struct Meta: Codable {
        public let currentPage: Int
        public let totalPages: Int
        public let totalCount: Int
        public let maxPageSize: Int

        enum CodingKeys: String, CodingKey {
            case currentPage = "current_page"
            case totalPages = "total_pages"
            case totalCount = "total_count"
            case maxPageSize = "max_page_size"
        }
    }
    
}

public extension Pagination.Response where T: JapxCodable {

    var isFirstPage: Bool {
        // 0 and 1 represents first page on API side
        return meta.currentPage < 2
    }

    func append(page: Pagination.Response<T>) -> Pagination.Response<T> {
        return Pagination.Response(data: data + page.data, meta: page.meta)
    }

    func hasNext() -> Bool {
        return meta.currentPage < meta.totalPages
    }

}

public extension Pagination.Response where T: JapxCodable {

    static func empty() -> Pagination.Response<T> {
        return Pagination.Response(data: [], meta: .firstPage())
    }

    static func join(container: Pagination.Response<T>, page: Pagination.Response<T>) -> Pagination.Response<T> {
        return container.append(page: page)
    }

    static func hasNext(container: Pagination.Response<T>, lastPage: Pagination.Response<T>) -> Bool {
        return lastPage.hasNext()
    }

}

public extension Pagination.Meta {

    static func firstPage(totalCount: Int = 0) -> Pagination.Meta {
        return Pagination.Meta(
            currentPage: 1,
            totalPages: 1,
            totalCount: totalCount,
            maxPageSize: max(totalCount, 1)
        )
    }

    func nextPage() -> Int {
        return currentPage + 1
    }

}
