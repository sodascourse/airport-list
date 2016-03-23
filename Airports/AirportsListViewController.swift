//
//  AirportsListViewController.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import UIKit

class AirportsListViewController: UITableViewController {

    var airportsData: AirportsSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataPath = NSBundle.mainBundle().pathForResource("airports", ofType: "plist")!
        guard let airportsSource = try? AirportsSource(contentsOfFile: dataPath) else {
            fatalError()
        }
        self.airportsData = airportsSource
    }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.airportsData.countries.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.airportsData.countries[section].airports.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AirportCell", forIndexPath: indexPath)
        let airport = self.airportsData.countries[indexPath.section].airports[indexPath.row]

        cell.textLabel?.text = airport.name
        cell.detailTextLabel?.text = airport.IATA

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.airportsData.countries[section].name
    }

    // MARK: - Segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }

        if segueIdentifier == "ShowDetail" {
            guard let detailViewController = segue.destinationViewController as? AirportDetailViewController else {
                return
            }
            guard let cell = sender as? UITableViewCell else { return }
            let indexPath = self.tableView.indexPathForCell(cell)!
            let airport = self.airportsData.countries[indexPath.section].airports[indexPath.row]
            detailViewController.airport = airport
        }
    }

}
