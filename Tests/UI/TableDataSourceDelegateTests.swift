//
//  TableDataSourceDelegateTests.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class TableDataSourceDelegateTests: QuickSpec {

    override func spec() {

        describe("table data source delegate tests") {

            var tableView: UITableView!
            var dataSourceDelegate: TableDataSourceDelegate!
            var sections: [TableSectionItem] = []
            
            beforeEach {
                tableView = UITableView()
                dataSourceDelegate = TableDataSourceDelegate(tableView: tableView)
                let item1 = TestItem(title: "Item1")
                let item2 = TestItem(title: "Item2")
                let section1 = TestSection(title: "Section1", items: [item1, item2])
                let section2 = TestSection(title: "Section2", items: [item1, item2])
                sections = [section1, section2]
            }

            it("should return correct number of sections") {
                dataSourceDelegate.sections = sections
                expect(tableView.numberOfSections).to(equal(2))
            }

         }

    }
}

class TestItem: TableCellItem {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var didSelectCalled: Bool = false
    
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    var height: CGFloat {
        return 50
    }
    
    var estimatedHeight: CGFloat {
        return 44
    }
    
    func didSelect(at indexPath: IndexPath) {
        didSelectCalled = true
    }
    
}

struct TestSection: TableSectionItem {
    
    let title: String
    let items: [TableCellItem]
    
    var headerHeight: CGFloat {
        return 10
    }
    
    var footerHeight: CGFloat {
        return 10
    }
    
    var estimatedHeaderHeight: CGFloat {
        return 10
    }
    
    var estimatedFooterHeight: CGFloat {
        return 10
    }
    
    func headerView(from tableView: UITableView, at index: Int) -> UIView? {
        return nil
    }
    
    func footerView(from tableView: UITableView, at index: Int) -> UIView? {
        return nil
    }
    
    func titleForHeader(from tableView: UITableView, at index: Int) -> String? {
        return title
    }
    
    func titleForFooter(from tableView: UITableView, at index: Int) -> String? {
        return title
    }
    
}
