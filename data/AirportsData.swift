//
//  AirportsData.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import Foundation
import Alamofire
import Async

// MARK: Properties
// ---------------------------------------------------------------------------------------------------------------------

class AirportsSource {
    var countries: [Country]

    init(countries: [Country] = []) {
        self.countries = countries
    }
}

struct Country {
    let name: String
    let airports: [Airport]
}

struct Airport {
    let name: String
    let countryName: String
    let IATA: String
    let servedCity: String
    let shortName: String
    let imageName: String
}

extension AirportsSource {
    func fetchFromNetwork(with completionHandler: @escaping (_ success: Bool) -> Void) {
        let url = "https://course.sodas.tw/assets/airports/data.json"
        Alamofire.request(url).responseJSON { response in
            Async.userInteractive { () -> [Country]? in
                sleep(1)
                guard let JSON = response.result.value as? [[String: Any]] else {
                    return nil
                }
                guard let countries = try? AirportsSource.organize(airportsDict: JSON) else {
                    return nil
                }
                return countries
            }.main { (countries: [Country]?) in
                let success = countries != nil
                if success {
                    self.countries = countries!
                }
                completionHandler(success)
            }
        }
    }
}

// MARK: - Loaders
// ---------------------------------------------------------------------------------------------------------------------

extension Airport {

    /**
     Convert a dictionary into object instances.
     */
    init?(fromDictionary dict: [String: Any]) {
        guard let name = dict["Airport"] as? String else {
            return nil
        }
        self.name = name

        guard let countryName = dict["Country"] as? String else {
            return nil
        }
        self.countryName = countryName

        guard let IATA = dict["IATA"] as? String else {
            return nil
        }
        self.IATA = IATA

        guard let servedCity = dict["ServedCity"] as? String else {
            return nil
        }
        self.servedCity = servedCity

        guard let shortName = dict["ShortName"] as? String else {
            return nil
        }
        self.shortName = shortName

        guard let imageName = dict["Image"] as? String else {
            return nil
        }
        self.imageName = imageName
    }
}

enum AirportsSourceErrorType: Error {
    case fileNotFound
    case invalidContent
}

extension AirportsSource {

    convenience init(contentsOfFile path: String) throws {
        // Read plist into arrray of dictionaries
        guard let airportDictionaries = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            throw AirportsSourceErrorType.fileNotFound
        }
        let countries = try AirportsSource.organize(airportsDict: airportDictionaries)
        self.init(countries: countries)
    }

    static func organize(airportsDict airportDictionaries: [[String: Any]]) throws -> [Country] {
        // Create a dictionary which keys are contry name and values are airports list
        var dictOfCountryAndAirports = [String: [Airport]]()
        for airportDict in airportDictionaries {
            guard let airport = Airport(fromDictionary: airportDict) else {
                throw AirportsSourceErrorType.invalidContent
            }
            if dictOfCountryAndAirports[airport.countryName] == nil {
                // Create an array to put airport by country name
                dictOfCountryAndAirports[airport.countryName] = []
            }
            dictOfCountryAndAirports[airport.countryName]!.append(airport)
        }

        // Create a countries array and convert previous dictionary
        var countries = [Country]()
        for (countryName, airports) in dictOfCountryAndAirports {
            // Sort airports by their name
            let sortedAirports = airports.sorted(by: { (airport1: Airport, airport2: Airport) -> Bool in
                return airport1.IATA < airport2.IATA
            })
            // Create the country object
            let country = Country(name: countryName, airports: sortedAirports)
            countries.append(country)
        }
        // Sort countries by their name
        return countries.sorted { (countryA: Country, countryB: Country) -> Bool in
            return countryA.name < countryB.name
        }
    }
}
