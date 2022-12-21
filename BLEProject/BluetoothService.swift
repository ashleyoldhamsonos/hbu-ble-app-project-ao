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
  let duke = "FDFFAAEAB6B833D7E9"
  static let shared = BluetoothService()
  var isBluetoothOn = false

  private override init() {
    super .init()
    viewModel = BLEProjectViewModel()
  }

}

extension BluetoothService: CBCentralManagerDelegate, CBPeripheralDelegate {

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == CBManagerState.poweredOn {
      print("Bluetooth is ON", central.state)
      isBluetoothOn = true
      viewModel?.checkBluetoothStatus()
      central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    } else {
      print("Bluetooth is OFF", central.state)
      viewModel?.checkBluetoothStatus()
      viewModel?.turnOnBluetoothAlert()
      isBluetoothOn = false
    }
  }

  /// ran each time a new device is discovered
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//    myPeripheral = peripheral
//    myPeripheral.delegate = self

    if let pName = peripheral.name {
      if pName == duke {
        central.stopScan()

        myPeripheral = peripheral
        myPeripheral.delegate = self
        central.connect(peripheral)
      }
      let data = advertisementData.description

      viewModel?.addDeviceToArray(device: pName, data: data, rssi: RSSI.stringValue)
    }

//    if let pName = peripheral.name {
//      DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
//        central.stopScan()
//        centralManager.connect(myPeripheral, options: nil)
//      }
//      //      print("Device", pName)
//      let data = advertisementData.description
//
//      viewModel?.addDeviceToArray(device: pName, data: data, rssi: RSSI.stringValue)
//    }
  }

  /// provides incoming information about newly connected device
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    myPeripheral.discoverServices([batteryLevelService])
    print("CONNECTED", myPeripheral.description)
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }

    if error != nil {
      print("Error receiving services")
    } else {
      for service in services {
        print("SERVICE", service)
        myPeripheral.discoverCharacteristics([batteryLevelCharacteristic], for: service)
      }
    }

  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      peripheral.setNotifyValue(true, for: characteristic)
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
//            centralManager.connect(myPeripheral)
  }

  func startScan() {
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  /// cancelling local connection here doesn't always mean the physical link is disconnected immeadiately
  func disconnectFromDevice() {
//    if myPeripheral != nil {
//      centralManager.cancelPeripheralConnection(myPeripheral)
//      print("DISCONNECTED", myPeripheral)
//    }
  }

}
