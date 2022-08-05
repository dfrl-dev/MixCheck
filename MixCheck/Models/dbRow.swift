//
//  dbRow.swift
//  MixCheck
//
//  Created by Dylan Lauzon on 2022-07-18.
//

import Foundation
import UIKit
import SwiftyDropbox

struct dbRow {
    var image: UIImage?
    var type: String
    var name: String
    var added: Bool?
    var downloaded: Bool?
    var metadata : Files.Metadata
}
