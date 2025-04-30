//
//  DetailViewController.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/24/25.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var station: StationInfo?

    private var arrivalsByDirection: [String: [TrainArrival]] = [:]
    private var directionList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station?.name ?? "Station Details"
        tableView.dataSource = self
        tableView.delegate = self

        organizeArrivalsByDirection()
    }

    private func organizeArrivalsByDirection() {
        guard let station = station else { return }

        var grouped: [String: [TrainArrival]] = [:]

        for (_, arrivals) in station.arrivalsByLine {
            for arrival in arrivals {
                grouped[arrival.direction, default: []].append(arrival)
            }
        }

        // Sort each direction group by ETA ascending and limit to 3
        for (direction, arrivals) in grouped {
            let sorted = arrivals.sorted {
                Int($0.waitingSeconds) ?? 9999 < Int($1.waitingSeconds) ?? 9999
            }
            grouped[direction] = Array(sorted.prefix(3))
        }

        self.arrivalsByDirection = grouped
        self.directionList = grouped.keys.sorted()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return directionList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Direction: \(directionList[section])"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let direction = directionList[section]
        let arrivals = arrivalsByDirection[direction] ?? []
        let groupedByDestination = Dictionary(grouping: arrivals) { $0.destination }
        return groupedByDestination.keys.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let direction = directionList[indexPath.section]
        let grouped = Dictionary(grouping: arrivalsByDirection[direction] ?? []) { $0.destination }
        let destination = grouped.keys.sorted()[indexPath.row]
        let arrivals = (grouped[destination] ?? []).sorted {
            Int($0.waitingSeconds) ?? 9999 < Int($1.waitingSeconds) ?? 9999
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationETAGroupCell", for: indexPath) as? StationETAGroupCell else {
            return UITableViewCell()
        }

        cell.configure(with: destination, arrivals: Array(arrivals.prefix(4)))
        return cell
    }



    private func imageFor(line: String, direction: String) -> UIImage? {
        let imageName = "\(line.capitalized)_\(direction.uppercased())"
        return UIImage(named: imageName) ?? UIImage(systemName: "tram.fill")
    }
}
