//
//  String+HTML.swift
//  TriviaGame
//
//  Created by Remberto Silva on 3/19/26.
//

import Foundation
import UIKit

import Foundation

extension String {
    var htmlDecoded: String {
        var result = self
        let replacements = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#039;": "'",
            "&ldquo;": "\u{201C}",
            "&rdquo;": "\u{201D}",
            "&lsquo;": "\u{2018}",
            "&rsquo;": "\u{2019}",
            "&hellip;": "…",
            "&ndash;": "–",
            "&mdash;": "—"
        ]
        for (encoded, decoded) in replacements {
            result = result.replacingOccurrences(of: encoded, with: decoded)
        }
        return result
    }
}
