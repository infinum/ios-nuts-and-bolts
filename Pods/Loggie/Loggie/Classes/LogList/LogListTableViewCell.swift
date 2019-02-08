//
//  LogListTableViewCell.swift
//  Pods
//
//  Created by Filip Bec on 13/03/2017.
//
//

import UIKit

class LogListTableViewCell: UITableViewCell {

    private static let successStatusCodes = Array(200..<300)

    @IBOutlet weak private var statusCodeLabel: UILabel!
    @IBOutlet weak private var httpMethodLabel: UILabel!
    @IBOutlet weak private var pathLabel: UILabel!
    @IBOutlet weak private var hostLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!

    private var allLabels: [UILabel] {
        return [statusCodeLabel, httpMethodLabel, pathLabel, hostLabel, timeLabel, durationLabel]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        clearData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearData()
    }

    private func clearData() {
        allLabels.forEach { $0.text = nil }
    }

    func configure(with log: Log) {
        httpMethodLabel.text = log.request.httpMethod
        pathLabel.text = log.request.url?.path
        hostLabel.text = log.request.url?.host

        if let startTime = log.startTime {
            timeLabel.text = DateFormatter.localizedString(from: startTime, dateStyle: .none, timeStyle: .medium)
        }

        durationLabel.text = log.durationString

        if let statusCode = log.response?.statusCode {
            statusCodeLabel.text = String(statusCode)
            if LogListTableViewCell.successStatusCodes.contains(statusCode) {
                statusCodeLabel.textColor = UIColor(red: 55.0/255.0, green: 188.0/255.0, blue: 155.0/255.0, alpha: 1.0)
            } else {
                statusCodeLabel.textColor = UIColor(red: 218.0/255.0, green: 68.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
        }
    }
}
