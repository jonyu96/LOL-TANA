//
//  ChampDataModel.swift
//  LOL:TANA
//
//  Created by Jonathan Yu on 12/2/18.
//  Copyright © 2018 Jonathan Yu. All rights reserved.
//
//  Return specific champion code for each ADC champion

import UIKit

class ChampDataModel {
    
    func retrieveChampID(name: String) -> Int {
        
        switch (name) {
            
        case "Ashe" :
            return 22
        case "Caitlyn" :
            return 51
        case "Corki" :
            return 42
        case "Draven" :
            return 119
        case "Ezreal" :
            return 81
        case "Jhin" :
            return 202
        case "Jinx" :
            return 222
        case "Kai'Sa" :
            return 145
        case "Kalista" :
            return 429
        case "Kog'Maw" :
            return 96
        case "Lucian" :
            return 236
        case "Miss Fortune" :
            return 21
        case "Quinn" :
            return 133
        case "Sivir" :
            return 15
        case "Tristana" :
            return 18
        case "Twitch" :
            return 29
        case "Varus" :
            return 110
        case "Vayne" :
            return 67
        case "Xayah" :
            return 498
        
        default:
            return 22
        }
    }
}
