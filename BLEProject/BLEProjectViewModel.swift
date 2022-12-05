//
//  BLEProjectViewModel.swift
//  BLEProject
//
//  Created by Ashley Oldham on 22/11/2022.
//

import UIKit

protocol ViewModelUpdateDelegate: AnyObject {
  func update()
  func alert()
}

class BLEProjectViewModel: NSObject {
  
  weak var delegate: ViewModelUpdateDelegate?
  var scannedDevicesArray: [BluetoothDeviceModel] = []
  var batteryLevel: UInt8 = 0
  
  init(delegate: ViewModelUpdateDelegate? = nil) {
    super .init()
    self.delegate = delegate
  }
  
  func addDeviceToArray(device: String, data: String, rssi: String) {
    scannedDevicesArray.append(BluetoothDeviceModel(name: device, data: data, rssi: rssi))
    self.delegate?.update()
  }
  
  func turnOnBluetoothAlert() {
    self.delegate?.alert()
  }
  
  func startScanning() {
    BluetoothService.shared.startScan()
  }
  
  func selectedDevice() {
    BluetoothService.shared.selectedDevice()
  }
}
