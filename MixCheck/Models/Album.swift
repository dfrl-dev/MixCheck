//
//  Album.swift
//  MixCheck
//
//  Created by Dylan Lauzon on 2022-07-14.
//

import Foundation

struct Album {
    var name: String
    var image: String
    var songs: [Song]
}

extension Album {
    static func get() -> [Album]
    {
        return [
            Album(name: "album1", image: "album1", songs:
                 [
                    Song(name: "bullet", image:"album1", artist: "dfrl", fileName: "bullet"),
                    Song(name: "alone", image:"album1", artist: "dfrl", fileName: "alone")
                 ]),
            Album(name: "album2", image: "album2", songs:
                 [
                    Song(name: "get that", image:"album2", artist: "dfrl", fileName: "getThat"),
                    Song(name: "off brand", image:"album2", artist: "dfrl", fileName: "offBrand")
                 ]),
            Album(name: "album3", image: "album3", songs:
                 [
                    Song(name: "outta the loop", image:"album3", artist: "dfrl", fileName: "ootl"),
                    Song(name: "swallow me whole", image:"album3", artist: "dfrl", fileName: "swallowMe"),
                    Song(name: "trial and error", image: "album3", artist: "dfrl", fileName: "trialAndError")
                 ])
        ]
    }
}
