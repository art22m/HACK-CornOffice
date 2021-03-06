//
//  DevicesListController.swift
//  CornOffice
//
//  Created by Artem Murashko on 19.04.2022.
//

import UIKit

class DevicesListController: UIViewController {
    // MARK: - Properties
    let devicesListView = DevicesListView()
    var selectedIndex: IndexPath = IndexPath(row: -1, section: 0)
    let source = DispatchSource.makeTimerSource()
    
    var deviceManager = DeviceManager()
    var devicesList = [DeviceModel]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = devicesListView
        self.devicesListView.devicesListTable.delegate = self
        self.devicesListView.devicesListTable.dataSource = self
        self.devicesListView.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        self.deviceManager.delegate = self
        self.deviceManager.fetchDevices()
        
        self.navigationItem.title = "Devices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.startRepeatingUpdate()
    }
    
    func startRepeatingUpdate() {
        source.setEventHandler {
            self.deviceManager.fetchDevices()
        }
        source.schedule(deadline: .now(), repeating: 3)
        source.activate()
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        deviceManager.fetchDevices()
    }
    
    @objc func switchBulb(_ sender: UISwitch) {
        deviceManager.switchBulb(id: devicesList[sender.tag].uid)
    }
    
    @objc func turnOnKettle(_ sender: UIButton) {
        sender.pulsate()
        deviceManager.turnOnKettle(id:devicesList[sender.tag].uid)
    }
}

// MARK: - UITableViewDelegate

extension DevicesListController: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension DevicesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let device = devicesList[indexPath.row]
    
        switch device.type {
            case "kettle":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: KettleViewCell.identifier, for: indexPath) as? KettleViewCell else { return UITableViewCell() }
                cell.configure(with: device)
                cell.turnOnButton.tag = indexPath.row
                cell.turnOnButton.addTarget(self, action: #selector(turnOnKettle(_:)), for: .touchUpInside)
                cell.animate()
                
                return cell
            case "bulb":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BulbViewCell.identifier, for: indexPath) as? BulbViewCell else { return UITableViewCell() }
                cell.configure(with: device)
                cell.turnOnSwitch.tag = indexPath.row
                cell.turnOnSwitch.addTarget(self, action: #selector(switchBulb(_:)), for: .touchUpInside)
                cell.animate()
                
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath == selectedIndex ? 165 : 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (selectedIndex == indexPath) {
            selectedIndex = IndexPath(row: -1, section: 0)
        } else {
            selectedIndex = indexPath
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}

// MARK: - DeviceManagerDelegate

extension DevicesListController: DeviceManagerDelegate {
    func didUpdateDevice(_ deviceManager: DeviceManager) {
        deviceManager.fetchDevices()
    }
    
    func didFetchDevices(_ deviceManager: DeviceManager, devices: [DeviceModel]) {
        DispatchQueue.main.async {
            self.devicesList = devices
            self.devicesListView.activityIndicator.stopAnimating()
            self.devicesListView.refreshControl.endRefreshing()
            self.devicesListView.devicesListTable.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
