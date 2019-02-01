//
//  LogDetailsViewController.swift
//  Pods
//
//  Created by Filip Bec on 14/03/2017.
//
//

import UIKit

class LogDetailsViewController: UIViewController {

    private enum Kind: Int {
        case overview = 0
        case request = 1
        case response = 2
    }

    private var kind: Kind = .overview {
        didSet {
            switch kind {
            case .overview:
                sections = log.overviewDataSource
            case .request:
                sections = log.requestDataSource
            case .response:
                sections = log.responseDataSource
            }
            tableView.reloadData()
        }
    }

    fileprivate var sections = [LogDetailsSection]()

    var log: Log!

    @IBOutlet weak var optionsBar: UINavigationBar!
    @IBOutlet weak private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        kind = .overview

        setupOptionsBar()
        setupShareButton()
        setupTableView()

        let titleComponents = [log.request.httpMethod, log.request.url?.path]
        title = titleComponents
            .compactMap { $0 }
            .joined(separator: " ")
    }

    // MARK: - Private

    private func setupOptionsBar() {
        optionsBar.tintColor = navigationController?.navigationBar.tintColor
        optionsBar.barTintColor = navigationController?.navigationBar.barTintColor
    }

    private func setupShareButton() {
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonActionHandler(_:))
        )
        navigationItem.rightBarButtonItem = shareButton
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
    }

    // MARK: - Actions

    @objc private func shareButtonActionHandler(_ sender: UIBarButtonItem) {
        let activityItems: [Any] = [log.shareRepresentation]
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        present(activityController, animated: true, completion: nil)
    }

    @IBAction func segmentedControlActionHandler(_ sender: UISegmentedControl) {
        guard let _kind = Kind(rawValue: sender.selectedSegmentIndex) else { return }
        kind = _kind
    }

}

extension LogDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]

        switch item {
        case .subtitle(let title, let subtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath) as! LogDetailsTableViewCell
            cell.titleLabel.text = title
            cell.subtitleLabel.text = subtitle
            return cell

        case .text(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! LogDetailsTextTableViewCell
            cell.textView.text = text
            return cell

        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! LogDetailsImageTableViewCell
            cell.customImageView.image = image
            return cell
        }
    }
}
