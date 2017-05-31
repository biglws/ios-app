//
//  BackendRequest.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//


import APIKit

protocol BackendRequest: Request {
    
}

extension BackendRequest {
    var baseURL: URL {
        return URL(string: Constants.backend.baseUri)!
    }
}
