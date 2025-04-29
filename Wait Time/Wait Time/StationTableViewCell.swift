//
//  StationTabViewCell.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/24/25.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationLabel: UILabel!
    
    @IBOutlet weak var etaOneImage: UIImageView!
    @IBOutlet weak var etaOneLabel: UILabel!
    
    @IBOutlet weak var etaTwoImage: UIImageView!
    @IBOutlet weak var etaTwoLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        stationLabel.font = UIFont.boldSystemFont(ofSize: 18)
        etaOneLabel.font = UIFont.systemFont(ofSize: 14)
        etaTwoLabel.font = UIFont.systemFont(ofSize: 14)
    }

    // MARK: - Configuration

    func configure(with station: StationInfo) {
        stationLabel.text = station.name

        // Flatten all arrivals and sort by soonest
        let allArrivals = station.arrivalsByLine.flatMap { $0.value }
        let sortedArrivals = allArrivals.sorted {
            Int($0.waitingSeconds) ?? 9999 < Int($1.waitingSeconds) ?? 9999
        }

        let firstArrival = sortedArrivals.first
        let secondArrival = sortedArrivals.dropFirst().first
        print("First arrival: \(String(describing: firstArrival))")
        // ETA 1
        if let arrival = firstArrival {
            etaOneLabel.text = arrival.waitingTime
            etaOneImage.image = imageFor(line: arrival.line, direction: arrival.direction)
        } else {
            etaOneLabel.text = "No ETA"
            etaOneImage.image = UIImage(named: "placeholder_image") // Replace with your placeholder image name
        }

        // ETA 2
        if let arrival = secondArrival {
            etaTwoLabel.text = arrival.waitingTime
            etaTwoImage.image = imageFor(line: arrival.line, direction: arrival.direction)
        } else {
            etaTwoLabel.text = "No ETA"
            etaTwoImage.image = UIImage(named: "placeholder_image") // Replace with your placeholder image name
        }

    }

    // MARK: - Helper

    private func imageFor(line: String, direction: String) -> UIImage? {
        let imageName = "\(line.capitalized)_\(direction.uppercased())" // E.g. "Red_N"
        print("Image name: \(imageName)")
        return UIImage(named: imageName)
    }
}
