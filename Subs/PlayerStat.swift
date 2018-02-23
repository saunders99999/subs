//
//  Player.swift
//  Subs
//
//  Created by Mark Saunders on 2/6/18.
//  Copyright © 2018 Jenark. All rights reserved.
//

import Foundation

struct PlayerStat {
    var name: String
    var totalField: Int
    var onTheField: Int
    var subbed: Int
    var enabled: Bool
    
    func subCount() -> String {
//        let totalField = self.totalFieldTime()
        return String(subbed)
    }
    
    func fieldTime() -> String {
        var count = ":"
        
        for _ in stride(from: 1, through: onTheField, by: 1) {
            count += "--"
        }
        return count
    }
    
    func totalFieldTime() -> String {
        var count = ":"
        
        for _ in stride(from: 1, through: totalField, by: 1) {
            count += "--"
        }
        return count
    }

}

