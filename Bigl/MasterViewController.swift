//
//  MasterViewController.swift
//  Tutorial_2
//
//  Created by Roquie on 22/05/2017.
//  Copyright © 2017 roquie. All rights reserved.
//

import UIKit
import EFInternetIndicator
import APIKit

class MasterViewController: UITableViewController, InternetStatusIndicable {
    
    var internetConnectionIndicator: InternetViewIndicator?
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureNavigationItems()
        self.startMonitoringInternet()
        self.fetchLocationsAndSetIt()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let location = objects[indexPath.row] as! Location
                let controller = segue.destination as! DetailViewController
                controller.selectedLocation = location
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row] as! Location
        cell.textLabel!.text = object.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = objects[indexPath.row] as! Location
            self.removeLocation(id: location.id)
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func configureNavigationItems() -> Void {
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self,
            action: #selector(MasterViewController.refreshTableItems)
        )
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func refreshTableItems() -> Void {
        objects.removeAll()
        self.tableView.reloadData()
        self.fetchLocationsAndSetIt()
    }

    func fetchLocationsAndSetIt() -> Void {
        let request = GetLocationsRequest()
        Session.send(request) { result in
            switch result {
            case .success(let locations):
                print(locations)
                for location in locations {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.objects.insert(location, at: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }

    func removeLocation(id: Int) -> Void {
        let request = DeleteLocationRequest(id: id)
        Session.send(request)
    }
}

