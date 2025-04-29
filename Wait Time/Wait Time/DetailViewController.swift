//
//  DetailViewController.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/24/25.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var station: StationInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station?.name ?? "Station Detail"
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return station?.arrivalsByLine.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let line = station?.arrivalsByLine.keys.sorted()[section] else { return nil }
        return "Line: \(line)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let line = station?.arrivalsByLine.keys.sorted()[section],
              let arrivals = station?.arrivalsByLine[line] else { return 0 }
        return min(2, arrivals.count) // Show only 2 shortest waits
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        let line = station?.arrivalsByLine.keys.sorted()[indexPath.section] ?? ""
        let arrivals = station?.arrivalsByLine[line]?.sorted {
            Int($0.waitingSeconds) ?? 9999 < Int($1.waitingSeconds) ?? 9999
        } ?? []

        let arrival = arrivals[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "Destination: \(arrival.destination)"
        content.secondaryText = "Arrives in: \(arrival.waitingTime)"
        cell.contentConfiguration = content
        
        return cell
    }
}
