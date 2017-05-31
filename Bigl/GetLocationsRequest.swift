//
//  GetLocationsRequest.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import APIKit


struct GetLocationsRequest: Request, BackendRequest {
    typealias Response = Array<Location>
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/locations"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Location> {
        var locations = Array<Location>()
        let results = (object as AnyObject).value(forKeyPath: "data") as! [AnyObject]
        for location in results {
            locations.append(try Location(object: location))
        }

        return locations
    }
}

struct Location {
    let id: Int
    let name: String?
    
    init(object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }

        self.id = id
        self.name = name
    }
}
