//
//  AirportDetailViewController.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import UIKit

class AirportDetailViewController: UIViewController {

    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var airport: Airport? {
        didSet {
            // Update when the model is changed.
            self.updateLablesAndImages()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update when the view is loaded.
        self.updateLablesAndImages()
    }

    func updateLablesAndImages() {
        // If the view is not loaded yet, don't update
        guard self.isViewLoaded else {
            return
        }

        // Update title of the navigation bar
        self.navigationItem.title = self.airport?.IATA

        // Update labels
        self.airportNameLabel.text = self.airport?.name
        self.countryLabel.text = self.airport?.countryName
        self.cityLabel.text = self.airport?.servedCity

        // Update images
        var image: UIImage? = nil
        if let imageName = self.airport?.imageName {
             image = UIImage(named: imageName)
        }
        self.imageView.image = image
    }
}
