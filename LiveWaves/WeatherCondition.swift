//
//  WeatherCondition.swift
//  LiveWaves
//
//  Created by Szamódy Zs. Balázs on 2018. 04. 14..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation


struct WaveCondition: DirectionalCondition, Descriptor, CustomStringConvertible{
    var description: String {
        return "(Direction: " + getString(direction) + ", Height: " + getString(height) + ", Period: " + getString(period) + ")"
    }
    
    
    var direction: Float?
    var height: Float?
    var period: Float?
    
    init(direction: Float?, height: Float?, period: Float?) {
        self.direction = direction
        self.height = height
        self.period = period
    }
    
    init(direction: [Entry], height: [Entry], period: [Entry]) {
        self.init(direction: Entry.getAverage(direction), height: Entry.getAverage(height), period: Entry.getAverage(period))
    }
}

struct WindCondition: DirectionalCondition, Descriptor, CustomStringConvertible {
    var direction: Float?
    var speed: Float?
    
    var description: String {
        return "(Direction: " + getString(direction) + ", Speed: " + getString(speed) + ")"
    }
    
    init(direction: Float?, speed: Float?) {
        self.direction = direction
        self.speed = speed
    }
    
    init(direction: [Entry], speed: [Entry]) {
        self.init(direction: Entry.getAverage(direction), speed: Entry.getAverage(speed))
    }
}

protocol DirectionalCondition{
    var direction: Float? {get set}
}
