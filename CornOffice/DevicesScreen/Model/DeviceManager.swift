//
//  DeviceManager.swift
//  CornOffice
//
//  Created by Artem Murashko on 19.04.2022.
//

import Foundation

protocol DeviceManagerDelegate {
    func didUpdateDevice(_ deviceManager: DeviceManager)
    func didFetchDevices(_ deviceManager: DeviceManager, devices: [DeviceModel])
    func didFailWithError(error: Error)
}

struct DeviceManager {
    var delegate: DeviceManagerDelegate?
    
    // MARK: - Fetch
    
    func fetchDevices(for email: String) {
        guard let url = URL(string: "https://beecoder-qr-code-entrance.herokuapp.com/gadgets/devices/\(email)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            if let safeData = data {
                if let devices = parseData(jsonData: safeData) {
                    delegate?.didFetchDevices(self, devices: devices)
                }
            }
        }
        
        task.resume()
    }
    
    func fetchDevices() {
        guard let url = URL(string: "https://beecoder-qr-code-entrance.herokuapp.com/device/all") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            if let safeData = data {
                if let devices = parseData(jsonData: safeData) {
                    delegate?.didFetchDevices(self, devices: devices)
                }
            }
        }
        
        task.resume()
    }
    
    func switchBulb(id: String) {
        guard let url = URL(string: "https://beecoder-qr-code-entrance.herokuapp.com/device/bulb/\(id)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            self.delegate?.didUpdateDevice(self)
        }
        
        task.resume()
    }
    
    func turnOnKettle(id: String) {
        guard let url = URL(string: "https://beecoder-qr-code-entrance.herokuapp.com/device/kettle/boil/\(id)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            self.delegate?.didUpdateDevice(self)
        }
        
        task.resume()
    }
    
    // MARK: - Parse
    
    private func parseData(jsonData: Data) -> [DeviceModel]? {
        let decoder = JSONDecoder()
        do {
            let devices = try decoder.decode([DeviceModel].self, from: jsonData)
            
            return devices
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

