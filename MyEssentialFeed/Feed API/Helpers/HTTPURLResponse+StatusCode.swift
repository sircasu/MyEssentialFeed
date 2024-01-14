//
//  HTTPURLResponse+StatusCode.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 14/01/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
