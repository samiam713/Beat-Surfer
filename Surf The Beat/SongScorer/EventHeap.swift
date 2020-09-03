//
//  EventHeap.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

// EVENTS:
// PLAY BACKGROUND TRACK
// SPAWN NOTE
// DELETE NOTE

// HOW DOES THIS HAPPEN? BY LOOPING THROUGH ALL NOTES OF A SONG AND USING SOME FUNCTION TO DETERMINE WHEN THEY SHOULD BE SPAWNED AND STUFF
// TIME IS RELATIVE TO START OF SONG... IF THERE'S A NOTE THAT SPAWNS BEFORE THE SONG STARTS MAKE NOTE OF IT AND SET THE INITIAL VALUE OF TIME TO THAT NEGATIVE VALUE

struct MusicEvent {
    let time: Double
    let action: ()->()
}

struct MusicEventHeap {
    
    var nodes: [MusicEvent] // imagine a binary tree where soonest event is stored at zero
    
    init(originalEvents: [MusicEvent]) {
        nodes = originalEvents
        for i in nodes.indices.reversed() {
            trickleDown(from: i)
            
        }
    }
    
    func top() -> MusicEvent? {
        return nodes.first
    }
    
    mutating func pop() {
        if nodes.count > 1 {
            nodes.swapAt(nodes.startIndex, nodes.endIndex-1)
            _ = nodes.popLast()
            trickleDown(from: 0)
        } else {
            _ = nodes.popLast()
        }
    }
}

extension MusicEventHeap {
    private mutating func trickleDown(from: Int) {
        var soonest = from
        let children = getChildren(of: from)
        if let left = children.left {
            if nodes[soonest].time > nodes[left].time {
                soonest = left
            }
            if let right = children.right {
                if nodes[soonest].time > nodes[right].time {
                    soonest = right
                }
            }
            if soonest != from {
                nodes.swapAt(from, soonest)
                trickleDown(from: soonest)
            }
        }
    }
    
    private func getChildren(of: Int) -> (left: Int?, right: Int?) {
        let left = 2*of+1
        
        if nodes.indices.contains(left) {
            let right = left+1
            return (left: left, right: right == nodes.count ? nil : right)
        } else {
            return (left: nil, right: nil)
        }
    }
}
