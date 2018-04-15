//
//  SpotInfoShort.swift
//  LiveWaves
//
//  Created by Szamódy Zs. Balázs on 2018. 04. 11..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation

struct SpotInfo: Decodable, CustomStringConvertible, Descriptor {
    let air: Float?
    let water: Float?
    let swell: WaveCondition?
    let wave: WaveCondition?
    let wind: WindCondition?
    let time: Date
    
    var description: String {
        
        return "\(time)" + " - " + "Air Temperature: " + getString(air) + " Water Temperature: " + getString(water)  + ", Swell: " + getString(swell) + ", Wave: " + getString(wave) + ", Wind: " + getString(wind) + "\n"
    }
    
    enum CodingKeys: String, CodingKey {
        case airTemperature
        case swellDirection
        case swellHeight
        case swellPeriod
        case time
        case waterTemperature
        case waveDirection
        case waveHeight
        case wavePeriod
        case windDirection
        case windSpeed
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let airTemperatureArray = try container.decode([Entry].self, forKey: .airTemperature)
        let swellDirectionArray = try container.decode([Entry].self, forKey: .swellDirection)
        let swellHeightArray = try container.decode([Entry].self, forKey: .swellHeight)
        let swellPeriodArray = try container.decode([Entry].self, forKey: .swellPeriod)
        self.time = try container.decode(Date.self, forKey: .time)
        let waterTemperatureArray = try container.decode([Entry].self, forKey: .waterTemperature)
        let waveDirectionArray = try container.decode([Entry].self, forKey: .waveDirection)
        let waveHeightArray = try container.decode([Entry].self, forKey: .waveHeight)
        let wavePeriodArray = try container.decode([Entry].self, forKey: .wavePeriod)
        let windDirectionArray = try container.decode([Entry].self, forKey: .windDirection)
        let windSpeedArray = try container.decode([Entry].self, forKey: .windSpeed)
        
        self.air = Entry.getAverage(airTemperatureArray)
        self.water = Entry.getAverage(waterTemperatureArray)
        self.swell = WaveCondition(direction: swellDirectionArray, height: swellHeightArray, period: swellPeriodArray)
        self.wave = WaveCondition(direction: waveDirectionArray, height: waveHeightArray, period: wavePeriodArray)
        self.wind = WindCondition(direction: windDirectionArray, speed: windSpeedArray)
    }
    
    
 }

struct DailySpotInfo: Decodable {
    var hours: [SpotInfo]
}

struct Entry: Codable {
    let source: String
    let value: Float
    
    
    enum CodingKeys: String, CodingKey {
        case source
        case value
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.source = try valueContainer.decode(String.self, forKey: .source)
        self.value = ((Float(try valueContainer.decode(String.self, forKey: .value)) ?? 0) * 100).rounded() / 100
    }
    
    static func getAverage(_ entries: [Entry]) -> Float? {
        guard !entries.isEmpty else {
            return nil
        }
        var value: Float = 0
        for entry in entries {
            value += entry.value
        }
        return value / Float(entries.count)
    }
}


