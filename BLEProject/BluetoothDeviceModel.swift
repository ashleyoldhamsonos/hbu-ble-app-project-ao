//
//  BluetoothDeviceModel.swift
//  BLEProject
//
//  Created by Ashley Oldham on 14/11/2022.
//

import Foundation

struct BluetoothDeviceModel: Hashable {
  let name: String
  let data: String?
  let rssi: String
  
  init(name: String, data: String?, rssi: String) {
    self.name = name
    self.data = data
    self.rssi = rssi
  }
}
