//
//  DetailViewController.swift
//  Tutorial_2
//
//  Created by Roquie on 22/05/2017.
//  Copyright © 2017 roquie. All rights reserved.
//

import UIKit
import EFInternetIndicator
import APIKit

enum BackendError: Error {
    case didNotLoadConfiguredLocation
}

class DetailViewController: UIViewController, EILIndoorLocationManagerDelegate, InternetStatusIndicable {

    @IBOutlet weak var myLocationView: EILIndoorLocationView!
    @IBOutlet weak var myPositionLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!

    var internetConnectionIndicator: InternetViewIndicator?
    
    /**
     * Location manager.
     */
    
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    
    var selectedLocation: Location? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let location = selectedLocation {
            self.initEstimote(useLocation: location)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Estimote init and others.
        self.locationManager.delegate = self
        ESTConfig.setupAppID(Constants.estimote.appId, andAppToken: Constants.estimote.appToken)

        self.startMonitoringInternet()
        
        restartButton.backgroundColor = .clear
        restartButton.layer.cornerRadius = 5
        restartButton.layer.borderWidth = 1
        restartButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        myLocationView.backgroundColor = UIColor.clear
        myLocationView.showTrace = true
        myLocationView.showWallLengthLabels = true
        myLocationView.rotateOnPositionUpdate = false
        
        myLocationView.locationBorderColor = UIColor.black
        myLocationView.locationBorderThickness = 6
        myLocationView.doorColor = UIColor.brown
        myLocationView.doorThickness = 5
        myLocationView.traceColor = UIColor.lightGray
        myLocationView.traceThickness = 2
        myLocationView.wallLengthLabelsColor = UIColor.black
    }

    // Stop listening for the view.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.locationManager.stopPositionUpdates()
    }
    
    // Check for failure.
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: Error) {
        print("Did Fail to update location \(manager)")
    }
    
    // Updating our label, and updating our position.
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {
        
        var accuracy: String!
        switch positionAccuracy {
            case .veryHigh: accuracy = "+/- 1.00m"
            case .high:     accuracy = "+/- 1.62m"
            case .medium:   accuracy = "+/- 2.62m"
            case .low:      accuracy = "+/- 4.24m"
            case .veryLow:  accuracy = "+/- ? :-("
            case .unknown:  accuracy = "unknown"
        }
        
        myPositionLabel.text = String(
            format: "x: %5.2f, y: %5.2f, α: %3.0f \n accuracy: %@",
            position.x,
            position.y,
            position.orientation,
            accuracy
        ) as String

        myLocationView.updatePosition(position)
    }

    func initEstimote(useLocation: Location) -> Void {
        self.fetchConfiguredLocation(id: useLocation.id, responseCallback: { settings in
            var points = Array<EILPoint>()
            let locationBuilder = EILLocationBuilder()
            locationBuilder.setLocationName(settings.name)
            
            for point in settings.boundaryPoints {
                points.append(EILPoint(x: (point?.x)!, y: (point?.y)!))
            }
            
            locationBuilder.setLocationBoundaryPoints(points)
            
            for point in settings.boundaryPoints {
                for segment in (point?.boundarySegments)! {
                    locationBuilder.addBeacon(
                        withIdentifier: segment!.beacon.identity,
                        atBoundarySegmentIndex: segment!.segmentNo,
                        inDistance: segment!.distance,
                        from: segment!.fromSide
                    )
                }
            }

//            locationBuilder.addBeacon(
//                withIdentifier: "89d76cc3a5fdd158337ca4ef15355f30",
//                withPosition: EILOrientedPoint(x: 5, y: 4, orientation: 176),
//                andColor: .candyFloss
//            )
            // locationBuilder.setLocationOrientation(0)
            
            self.location = locationBuilder.build()
            self.startRoomDrawing()
        })
    }
    
    @IBAction func restartRoomDrawing(_ sender: UIButton, forEvent event: UIEvent) {
        self.locationManager.stopPositionUpdates()
        myLocationView.clearTrace()
        myPositionLabel.text = "Re-initialization..."
        self.initEstimote(useLocation: self.selectedLocation!)
        self.startRoomDrawing()
    }

    func startRoomDrawing() -> Void {
        myLocationView.drawLocation(self.location)
        self.locationManager.startPositionUpdates(for: self.location)
    }

    func fetchConfiguredLocation(id: Int, responseCallback: @escaping (ConfiguredLocation) -> Void ) -> Void {
        let request = GetConfiguredLocationByIdRequest(id: id)
        Session.send(request) { result in
            switch result {
                case .success(let location):
                    responseCallback(location)
                case .failure(let error):
                    print("error: \(error)")
                    //throw BackendError.didNotLoadConfiguredLocation
            }
        }
    }
 
//    func buildDefaultLocation() -> EILLocation? {
//        let locationBuilder = EILLocationBuilder()
//        locationBuilder.setLocationName("Моя комната")
//        
//        // That’s a simple 4.56 m x 9.85 m, rectangular room
//        locationBuilder.setLocationBoundaryPoints([
//            EILPoint(x: 0.00, y: 0.00),
//            EILPoint(x: 0.00, y: 9.85),
//            EILPoint(x: 4.56, y: 9.85),
//            EILPoint(x: 4.56, y: 0.00)
//            ])
//        
//        locationBuilder.addBeacon(
//            withIdentifier: "905c49683e24a6f1ed29327b3c075124",
//            atBoundarySegmentIndex: 0,
//            inDistance: 3.5,
//            from: .leftSide
//        )
//        locationBuilder.addBeacon(
//            withIdentifier: "0988f26868b790495ff0a42c3f20d330",
//            atBoundarySegmentIndex: 1,
//            inDistance: 1.1,
//            from: .rightSide
//        )
//        locationBuilder.addBeacon(
//            withIdentifier: "752014311c253e149863dafb012bda1e",
//            atBoundarySegmentIndex: 2,
//            inDistance: 5.7,
//            from: .leftSide
//        )
//        locationBuilder.addBeacon(
//            withIdentifier: "67c1b35f87e34987df9bce327e9c3600",
//            atBoundarySegmentIndex: 3,
//            inDistance: 2.4,
//            from: .rightSide
//        )
//        locationBuilder.setLocationOrientation(35)
//        
//        return locationBuilder.build()
//    }
    
    //    private func indoorLocationManager(manager: EILIndoorLocationManager!,
    //                               didFailToUpdatePositionWithError error: NSError!) {
    //        print("failed to update position: \(error)")
    //    }
    //
    //    private func indoorLocationManager(manager: EILIndoorLocationManager!,
    //                               didUpdatePosition position: EILOrientedPoint!,
    //                               withAccuracy positionAccuracy: EILPositionAccuracy,
    //                               inLocation location: EILLocation!) {
    //        var accuracy: String!
    //        switch positionAccuracy {
    //        case .veryHigh: accuracy = "+/- 1.00m"
    //        case .high:     accuracy = "+/- 1.62m"
    //        case .medium:   accuracy = "+/- 2.62m"
    //        case .low:      accuracy = "+/- 4.24m"
    //        case .veryLow:  accuracy = "+/- ? :-("
    //        case .unknown:  accuracy = "unknown"
    //        }
    //        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
    //                     position.x, position.y, position.orientation, accuracy))
    //    }
}

