//
//  StationETAGroupCell.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/29/25.
//

import UIKit

class StationETAGroupCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!

    @IBOutlet weak var etaStackRow1: UIStackView!
    @IBOutlet weak var etaStackRow2: UIStackView!
    @IBOutlet weak var etaStackRow3: UIStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear previous ETA views
        [etaStackRow1, etaStackRow2, etaStackRow3].forEach { row in
            row?.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
    }

    func configure(with destination: String, arrivals: [TrainArrival]) {
        destinationLabel.text = "To \(destination)"

        let rows = [etaStackRow1, etaStackRow2, etaStackRow3]

        for (i, arrival) in arrivals.prefix(3).enumerated() {
            let imageView = UIImageView()
            imageView.image = imageFor(line: arrival.line, direction: arrival.direction)
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

            let label = UILabel()
            label.text = arrival.waitingTime
            label.font = UIFont.systemFont(ofSize: 14)

            let pair = UIStackView(arrangedSubviews: [imageView, label])
            pair.axis = .horizontal
            pair.spacing = 4
            pair.alignment = .center

            rows[i]?.addArrangedSubview(pair)
        }
    }

    private func imageFor(line: String, direction: String) -> UIImage? {
        let imageName = "\(line.capitalized)_\(direction.uppercased())"
        return UIImage(named: imageName) ?? UIImage(systemName: "tram.fill")
    }
}
