//
//  GetLocationsRequest.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import APIKit


struct DeleteLocationRequest: Request, BackendRequest {
    typealias Response = Void
    let id: Int

    var method: HTTPMethod {
        return .delete
    }
    
    var path: String {
        return "/api/location/\(self.id)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Void {
    }
}
