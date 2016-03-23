//
//  AirportsData.swift
//  Airports
//
//  Created by sodas on 3/23/16.
//  Copyright © 2016 sodas. All rights reserved.
//

import Foundation

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

    var imagePath: String? {
        return NSBundle.mainBundle().pathForResource(self.imageName, ofType: nil)
    }

    init?(fromDictionary dict: NSDictionary) {
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

enum AirportsSourceErrorType: ErrorType {
    case FileNotFound
    case InvalidContent
}

struct AirportsSource {

    let countries: [Country]

    init(contentsOfFile path: String) throws {
        guard let rawData = NSArray(contentsOfFile: path) as? [NSDictionary] else {
            throw AirportsSourceErrorType.FileNotFound
        }

        var countryAirportMap = [String: [Airport]]()
        for airportDict in rawData {
            guard let airport = Airport(fromDictionary: airportDict) else {
                throw AirportsSourceErrorType.InvalidContent
            }
            if countryAirportMap[airport.countryName] == nil {
                // Create an array to put airport by country name
                countryAirportMap[airport.countryName] = []
            }
            countryAirportMap[airport.countryName]!.append(airport)
        }

        var _countries = [Country]()
        for (countryName, airports) in countryAirportMap {
            let country = Country(name: countryName, airports: airports)
            _countries.append(country)
        }
        self.countries = _countries.sort { (countryA: Country, countryB: Country) -> Bool in
            return countryA.name < countryB.name
        }
    }
}
