//
//  BackendResponse.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import Himotoki

extension GitHubRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}
