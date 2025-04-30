//
//  ViewController.swift
//  Wait Time
//
//  Created by Isaac Lara on 4/23/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrivals: [TrainArrival] = []
    var stations: [StationInfo] = []
    var refreshTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        startRefreshTimer()
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.fetchData()
        }
    }
    
    func fetchData() {
        let urlString = "https://developerservices.itsmarta.com:18096/itsmarta/railrealtimearrivals/developerservices/traindata?apiKey=7cee6274-46d4-412d-ab76-45b368e2afc5"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Fetch error: \(String(describing: error))")
                return
            }

            do {
                let decoder = JSONDecoder()
                let arrivals = try decoder.decode([TrainArrival].self, from: data)
                DispatchQueue.main.async {
                    self.arrivals = arrivals
                    self.stations = self.groupArrivalsByStation(arrivals)
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON decode error: \(error)")
            }
        }.resume()
    }
    
    func groupArrivalsByStation(_ arrivals: [TrainArrival]) -> [StationInfo] {
        var grouped: [String: [String: [TrainArrival]]] = [:]
        
        for arrival in arrivals {
            grouped[arrival.station, default: [:]][arrival.line, default: []].append(arrival)
        }
        
        return grouped.map { (stationName, lineDict) in
            StationInfo(name: stationName, arrivalsByLine: lineDict)
        }.sorted { $0.name < $1.name }
    }


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }

    //shows plain text in the cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let station = stations[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
//        
//        var content = cell.defaultContentConfiguration()
//        content.text = station.name
//        
//        let lineSummaries = station.arrivalsByLine.map { (line, arrivals) in
//            arrivals.map { arrival in
//                let wait = arrival.waitingTime
//                let direction = arrival.direction
//                return "\(line) (\(direction)): \(wait)"
//            }.joined(separator: " | ")
//        }.joined(separator: " | ")
//        
//        content.secondaryText = lineSummaries
//        cell.contentConfiguration = content
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as? StationTableViewCell else {
            fatalError("Could not dequeue a StationTableViewCell")
        }

        let station = stations[indexPath.row]
        cell.configure(with: station)

        return cell
    }

    

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let detailVC = segue.destination as? DetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.station = stations[indexPath.row]
        }
    }
}
