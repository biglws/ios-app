//
//  GetConfiguredLocationByIdRequest.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

//
//  GetLocationsRequest.swift
//  Bigl
//
//  Created by Roquie on 25/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import APIKit

struct GetConfiguredLocationByIdRequest: Request, BackendRequest {

    typealias Response = ConfiguredLocation
    let id: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/location/\(self.id)"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ConfiguredLocation {
        return ConfiguredLocation(object: object)
    }
}

struct ConfiguredLocation {
    let id: Int
    let name: String
    let description: String?
    let boundaryPoints: Array<BoundaryPoint?>
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        let id = dictionary?["id"] as? Int
        let name = dictionary?["name"] as? String
        let description = dictionary?["description"] as? String
        var points = Array<BoundaryPoint>()
        for boundaryPoint in (dictionary?["boundary_points"] as? Array<Any>)! {
            points.append(BoundaryPoint(object: boundaryPoint))
        }

        self.id = id!
        self.name = name!
        self.description = description
        self.boundaryPoints = points
    }
}

struct BoundaryPoint {
    let id: Int
    let locationId: Int
    let x: Double
    let y: Double
    let boundarySegments: Array<BoundarySegment?>
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        self.id = (dictionary?["id"] as? Int)!
        self.locationId = (dictionary?["location_id"] as? Int)!
        self.x = (dictionary?["x"] as? Double)!
        self.y = (dictionary?["y"] as? Double)!

        var segments = Array<BoundarySegment>()
        for boundarySegment in (dictionary?["boundary_segments"] as? Array<Any>)! {
            segments.append(BoundarySegment(object: boundarySegment))
        }

        self.boundarySegments = segments
    }
}

struct BoundarySegment {
    let id: Int
    let beaconId: Int
    let boundaryPointId: Int
    let segmentNo: UInt
    let distance: Double
    let fromSide: EILLocationBuilderSide
    let beacon: Beacon
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        self.id = (dictionary?["id"] as? Int)!
        self.beaconId = (dictionary?["beacon_id"] as? Int)!
        self.boundaryPointId = (dictionary?["boundary_point_id"] as? Int)!
        self.segmentNo = (dictionary?["segment_no"] as? UInt)!
        self.distance = (dictionary?["distance"] as? Double)!
        let fromSide = (dictionary?["from_side"] as? String)!
        self.beacon = Beacon(object: (dictionary?["beacon"] as Any))

        switch fromSide {
            case "left":
                self.fromSide = .leftSide
            case "right":
                self.fromSide = .rightSide
            default:
                self.fromSide = .rightSide
        }
    }
}


struct Beacon {
    let id: Int
    let name: String?
    let identity: String
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        self.id = (dictionary?["id"] as? Int)!
        self.name = (dictionary?["name"] as? String)!
        self.identity = (dictionary?["identity"] as? String)!
    }
}
