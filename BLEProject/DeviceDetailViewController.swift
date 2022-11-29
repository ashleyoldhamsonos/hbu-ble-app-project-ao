//
//  DeviceDetail.swift
//  BLEProject
//
//  Created by Ashley Oldham on 17/11/2022.
//

import UIKit

class DeviceDetailViewController: UIViewController {

  var deviceDetail: String = ""
  var batteryInfo: String = ""
  var bluetoothManager: BluetoothService?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray

    /// potential removal of back button for disconnection of devices
//    navigationItem.hidesBackButton = true
//    let customBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(disconnectFromDevice))
//    navigationItem.leftBarButtonItem = customBackButton
//    bluetoothManager = BluetoothService(view: self)
    setupDetailLayout()
  }

//  private let customBackButton: UIBarButtonItem = {
//    let button = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: DeviceDetailViewController.self, action: #selector(disconnectFromDevice))
//
//    return button
//  }()

  private let detailLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()

  let batteryInfoLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()

  private lazy var disconnectDeviceButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Disconnect", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 16
    button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    button.layer.borderWidth = 2
    button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    button.layer.masksToBounds = false
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    button.addTarget(self, action: #selector(disconnectFromDevice), for: .touchUpInside)
    return button
  }()

  @objc func disconnectFromDevice() {
//    bluetoothManager?.disconnectFromDevice()
    navigationController?.popViewController(animated: true)
  }

  func setupDetailLayout() {
    [detailLabel, batteryInfoLabel, disconnectDeviceButton].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      detailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      batteryInfoLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 16),
      batteryInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

      disconnectDeviceButton.topAnchor.constraint(equalTo: batteryInfoLabel.bottomAnchor, constant: 16),
      disconnectDeviceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      disconnectDeviceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      disconnectDeviceButton.heightAnchor.constraint(equalToConstant: 45)
    ])

    detailLabel.text = String(describing: deviceDetail)
    batteryInfoLabel.text = "Battery percentage: \(String(describing: batteryInfo))"
    
  }
}
