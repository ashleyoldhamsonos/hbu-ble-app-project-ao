//
//  BluetoothDeviceModel.swift
//  BLEProject
//
//  Created by Ashley Oldham on 14/11/2022.
//

import Foundation

struct BluetoothDeviceModel {
  let name: String
  let data: String?
  
  init(name: String, data: String?) {
    self.name = name
    self.data = data
  }
}
