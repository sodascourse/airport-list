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
            self.updateValues()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateValues()
    }

    func updateValues() {
        guard self.isViewLoaded() else {
            return
        }

        self.airportNameLabel.text = airport?.name
        self.countryLabel.text = airport?.countryName
        self.cityLabel.text = airport?.servedCity

        if let imagePath = airport?.imagePath {
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        } else {
            self.imageView.image = nil
        }
    }
}
