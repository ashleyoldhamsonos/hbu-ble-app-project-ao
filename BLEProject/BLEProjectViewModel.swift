//
//  BLEProjectViewModel.swift
//  BLEProject
//
//  Created by Ashley Oldham on 22/11/2022.
//

import UIKit

protocol BLEProjectView: AnyObject {
  func update()
}

struct BLEProjectViewModel {

  weak var view: BLEProjectView?
  var scannedDevices: [BluetoothDeviceModel] = []

  init(view: BLEProjectView?) {
    self.view = view
  }

  mutating func addDeviceToArray(device: String, data: String) {
    scannedDevices.append(BluetoothDeviceModel(name: device, data: data))
    self.view?.update()
  }
}
