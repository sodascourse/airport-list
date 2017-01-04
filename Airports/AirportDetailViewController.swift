//
//  AirportDetailViewController.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import UIKit
import AlamofireImage
import Async

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
        if let imageName = self.airport?.imageName {
            let imageUrl = URL(string: "https://course.sodas.tw/assets/airports/\(imageName)")!
            /*
            let data = try! Data(contentsOf: imageUrl)
            self.imageView.image = UIImage(data: data)
            */
            /*
            Async.userInteractive { () -> UIImage? in
                guard let data = try? Data(contentsOf: imageUrl) else {
                    return nil
                }
                return UIImage(data: data)
            }.main { image in
                self.imageView.image = image
            }
            */
            self.imageView.af_setImage(withURL: imageUrl)
        }
    }
}
