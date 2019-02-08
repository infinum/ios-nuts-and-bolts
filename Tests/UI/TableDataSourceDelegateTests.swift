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
            
            beforeEach {
                tableView = UITableView()
                dataSourceDelegate = TableDataSourceDelegate(tableView: tableView)
                dataSourceDelegate.sections = self.createSections()
            }

            it("should return correct number of sections and items") {
                expect(tableView.numberOfSections).to(equal(2))
                expect(tableView.numberOfRows(inSection: 0)).to(equal(3))
            }

            it("should return correct cell size") {
                let indexPath = IndexPath(row: 0, section: 0)
                let delegate = tableView.delegate!
                let height = delegate.tableView!(tableView, heightForRowAt: indexPath)
                let estimatedHeight = delegate.tableView!(tableView, estimatedHeightForRowAt: indexPath)
                
                expect(estimatedHeight).to(equal(44))
                expect(height).to(equal(50))
            }

            it("should return correct section header size") {
                let delegate = tableView.delegate!
                let height = delegate.tableView!(tableView, heightForHeaderInSection: 0)
                let estimatedHeight = delegate.tableView!(tableView, estimatedHeightForHeaderInSection: 0)
                
                expect(estimatedHeight).to(equal(3))
                expect(height).to(equal(1))
            }
            
            it("should return correct section footer size") {
                let delegate = tableView.delegate!
                let height = delegate.tableView!(tableView, heightForFooterInSection: 0)
                let estimatedHeight = delegate.tableView!(tableView, estimatedHeightForFooterInSection: 0)
                
                expect(estimatedHeight).to(equal(4))
                expect(height).to(equal(2))
            }
            
            it("should return correct section titles") {
                let header = tableView.dataSource!.tableView!(tableView, titleForHeaderInSection: 1)
                let footer = tableView.dataSource!.tableView!(tableView, titleForFooterInSection: 1)
                
                expect(header).to(equal("Section2"))
                expect(footer).to(equal("Section2"))
            }
            
            it("should invoke did select item when cell is selected") {
                let indexPath = IndexPath(row: 0, section: 0)
                let delegate = tableView.delegate!
                delegate.tableView!(tableView, didSelectRowAt: indexPath)
                let item = dataSourceDelegate.sections![indexPath] as! TestItem
                expect(item.didSelectCalled).to(beTrue())
            }
            
            it("should return section header/footer view") {
                let delegate = tableView.delegate!
                let header = delegate.tableView!(tableView, viewForHeaderInSection: 0)
                let footer = delegate.tableView!(tableView, viewForFooterInSection: 1)
                
                expect(header).notTo(beNil())
                expect(footer).notTo(beNil())
            }
            
            it("should return correct cell type") {
                let indexPath = IndexPath(row: 0, section: 0)
                let dataSource = tableView.dataSource!
                let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
                
                expect(cell).to(beAKindOf(TestItemTableViewCell.self))
            }
            
            it("getting items should return all") {
                let items = dataSourceDelegate.items as! [TestItem]
                
                expect(items.count).to(equal(5))
                expect(items[0].title).to(equal("Item1"))
                expect(items[1].title).to(equal("Item2"))
                expect(items[3].title).to(equal("Item1"))
            }
            
            it("setting items should set blank section") {
                dataSourceDelegate.items = [TestItem(title: "Item1")]
                
                let sections = dataSourceDelegate.sections!
                
                expect(sections.count).to(equal(1))
                expect(sections.first!.items.count).to(equal(1))
                expect(sections.first).to(beAKindOf(BlankTableSection.self))
            }
            
            it("when sections are nil - all heights should be 0") {
                dataSourceDelegate.sections = nil
                let delegate = dataSourceDelegate!
                let indexPath = IndexPath(row: 0, section: 0)
                
                expect(delegate.numberOfSections(in: tableView)).to(equal(0))
                expect(delegate.tableView(tableView, numberOfRowsInSection: 0)).to(equal(0))
                
                expect(delegate.tableView(tableView, heightForRowAt: indexPath)).to(equal(0))
                expect(delegate.tableView(tableView, estimatedHeightForRowAt: indexPath)).to(equal(0))
                
                expect(delegate.tableView(tableView, heightForFooterInSection: 0)).to(equal(0))
                expect(delegate.tableView(tableView, estimatedHeightForFooterInSection: 0)).to(equal(0))
                
                expect(delegate.tableView(tableView, heightForHeaderInSection: 0)).to(equal(0))
                expect(delegate.tableView(tableView, estimatedHeightForHeaderInSection: 0)).to(equal(0))
            }
            
         }

    }
    
    func createSections() -> [TableSectionItem] {
        let item1 = TestItem(title: "Item1")
        let item2 = TestItem(title: "Item2")
        let section1 = TestSection(title: "Section1", items: [item1, item2, item1])
        let section2 = TestSection(title: "Section2", items: [item1, item2])
        return [section1, section2]
    }
    
}

class TestItemTableViewCell: UITableViewCell { }

class TestItem: TableCellItem {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var didSelectCalled: Bool = false
    
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return TestItemTableViewCell()
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
        return 1
    }
    
    var footerHeight: CGFloat {
        return 2
    }
    
    var estimatedHeaderHeight: CGFloat {
        return 3
    }
    
    var estimatedFooterHeight: CGFloat {
        return 4
    }
    
    func headerView(from tableView: UITableView, at index: Int) -> UIView? {
        return UIView()
    }
    
    func footerView(from tableView: UITableView, at index: Int) -> UIView? {
        return UIView()
    }
    
    func titleForHeader(from tableView: UITableView, at index: Int) -> String? {
        return title
    }
    
    func titleForFooter(from tableView: UITableView, at index: Int) -> String? {
        return title
    }
    
}
