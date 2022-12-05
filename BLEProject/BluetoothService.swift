//
//  BluetoothManager.swift
//  BLEProject
//
//  Created by Ashley Oldham on 14/11/2022.
//

import CoreBluetooth
import UIKit

//protocol BluetoothView: AnyObject {
////  func update()
////  func alert()
//}

class BluetoothService: NSObject {

  //  var view: BluetoothView?
  var viewModel: BLEProjectViewModel?
  private var centralManager: CBCentralManager!
  private var myPeripheral: CBPeripheral!
  let batteryLevelService = CBUUID(string: "0x180F")
  let batteryLevelCharacteristic = CBUUID(string: "0x2A19")
  let heartRateService = CBUUID(string: "0x180D")
  static let shared = BluetoothService()

  override init() {
    super .init()
    viewModel = BLEProjectViewModel()
  }

}

extension BluetoothService: CBCentralManagerDelegate, CBPeripheralDelegate {

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == CBManagerState.poweredOn {
      print("Bluetooth is ON", central.state)
      central.scanForPeripherals(withServices: nil)
    } else {
      print("Bluetooth is OFF", central.state)
      viewModel?.turnOnBluetoothAlert()
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if let pName = peripheral.name {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        central.stopScan()
      }
      //      print("Device", pName)
      myPeripheral = peripheral

      let data = advertisementData.description

      myPeripheral.delegate = self
      centralManager.connect(myPeripheral)

      viewModel?.addDeviceToArray(device: pName, data: data)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    myPeripheral.discoverServices([batteryLevelService])
    print("CONNECTED", myPeripheral.description)
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }

    for service in services {
      print("SERVICE", service)
      myPeripheral.discoverCharacteristics([batteryLevelCharacteristic], for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      peripheral.readValue(for: characteristic)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    guard let batteryData = characteristic.value, let vm = viewModel else { return }

    if characteristic.uuid == batteryLevelCharacteristic {
      vm.batteryLevel = batteryData.first ?? 0
    } else {
      print("error reading characteristic value")
    }
  }

  func selectedDevice() {
    //        myPeripheral.delegate = self
    //        centralManager.connect(myPeripheral)
  }

  func startScan() {
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

}
