//
//  AirportsListViewController.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import UIKit

class AirportsListViewController: UITableViewController {

    var airportsData = AirportsSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.airportsData.fetchFromNetwork { success in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.airportsData.countries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.airportsData.countries[section].airports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell by reuse identifier.
        // This identifier should be set via the Storyboard.
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportCell", for: indexPath)

        // Get airport object from the index path
        let airport = self.airportsData.countries[indexPath.section].airports[indexPath.row]

        // Setup the cell
        cell.textLabel?.text = airport.name
        cell.detailTextLabel?.text = airport.IATA
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.airportsData.countries[section].name
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the identifier of the segue
        // Here, we only handle segue we know
        if segue.identifier == "ShowDetail" {
            // Get the destination view controller and cast it to our detail view controller class
            guard let detailViewController = segue.destination as? AirportDetailViewController else {
                return
            }
            // Check whether the sender is cell or not, and get its index path
            guard let cell = sender as? UITableViewCell else {
                return
            }
            let indexPath = self.tableView.indexPath(for: cell)!

            // Get airport object from the index path
            let airport = self.airportsData.countries[indexPath.section].airports[indexPath.row]
            // Tell the detail view controller which airport to show
            detailViewController.airport = airport
        } else {
            // Ask the super class to handle segues we don't know
            super.prepare(for: segue, sender: sender)
        }
    }

}
