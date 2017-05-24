//
//  ViewController.swift
//  Bigl
//
//  Created by Roquie on 15/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import UIKit
import Darwin
import EFInternetIndicator
import RevealingSplashView

class ViewController: UIViewController, EILIndoorLocationManagerDelegate, InternetStatusIndicable {

    @IBOutlet weak var myLocationView: EILIndoorLocationView!
    @IBOutlet weak var myPositionLabel: UILabel!

    var internetConnectionIndicator: InternetViewIndicator?

    /**
     * Location manager.
     */
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = showCompanyLogoWhenAppLoading()
        self.setEstimoteDefaults()
        self.startMonitoringInternet()

        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            revealingSplashView.startAnimation()
        }
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
        myLocationView.traceColor = UIColor.yellow
        myLocationView.traceThickness = 2
        myLocationView.wallLengthLabelsColor = UIColor.black
        
        // Start location drawing.
        myLocationView.drawLocation(self.location)
        self.locationManager.startPositionUpdates(for: self.location)
    }
    
    // Stop listening for the view.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
        self.locationManager.stopPositionUpdates()
    }
    
    // Check for failure.
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: Error) {
        print("Did Fail to update location \(manager)")
    }
    
    // Updating our label, and updating our position.
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {

        myPositionLabel.text = NSString(
            format: "x: %.2f   y: %.2f    α: %.2f",
            position.x,
            position.y,
            position.orientation
        ) as String

        myLocationView.updatePosition(position)
    }
    
    func buildDefaultLocation() -> EILLocation? {
        let locationBuilder = EILLocationBuilder()
        locationBuilder.setLocationName("Моя комната")
        
        // That’s a simple 4.56 m x 9.85 m, rectangular room
        locationBuilder.setLocationBoundaryPoints([
            EILPoint(x: 0.00, y: 0.00),
            EILPoint(x: 0.00, y: 9.85),
            EILPoint(x: 4.56, y: 9.85),
            EILPoint(x: 4.56, y: 0.00)
        ])

        locationBuilder.addBeacon(
            withIdentifier: "905c49683e24a6f1ed29327b3c075124",
            atBoundarySegmentIndex: 0,
            inDistance: 3.5,
            from: .leftSide
        )
        locationBuilder.addBeacon(
            withIdentifier: "0988f26868b790495ff0a42c3f20d330",
            atBoundarySegmentIndex: 1,
            inDistance: 1.1,
            from: .rightSide
        )
        locationBuilder.addBeacon(
            withIdentifier: "752014311c253e149863dafb012bda1e",
            atBoundarySegmentIndex: 2,
            inDistance: 5.7,
            from: .leftSide
        )
        locationBuilder.addBeacon(
            withIdentifier: "67c1b35f87e34987df9bce327e9c3600",
            atBoundarySegmentIndex: 3,
            inDistance: 2.4,
            from: .rightSide
        )
        locationBuilder.setLocationOrientation(35)
        
        return locationBuilder.build()
    }

    func cannotSetupLocationMessage() -> Void {
//        throw LocationBuilderError.buildFailed(
//            message: "Error: Can't setup location using builder."
//        )
        print("Error: Can't setup location using builder.")
    }

    func setEstimoteDefaults() -> Void {
        // Estimote init and others.
        self.locationManager.delegate = self
        ESTConfig.setupAppID(Constants.estimote.appId, andAppToken: Constants.estimote.appToken)
        print("App still running...")

        let locationSetup = self.buildDefaultLocation()
        if (locationSetup == nil) {
            cannotSetupLocationMessage()
            return
        }
        print(locationSetup ?? "fuck off")
        self.location = locationSetup
    }

    func showCompanyLogoWhenAppLoading() -> RevealingSplashView {
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(
            iconImage: UIImage(named: "bigl")!,
            iconInitialSize: CGSize(width: 100, height: 100),
            backgroundColor: UIColor(red:0, green:0, blue:0, alpha:1.0)
        )

        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        return revealingSplashView
    }
    
    
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

