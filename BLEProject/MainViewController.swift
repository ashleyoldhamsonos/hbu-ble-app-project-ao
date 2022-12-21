//
//  ViewController.swift
//  BLEProject
//
//  Created by Ashley Oldham on 14/11/2022.
//

import UIKit

class MainViewController: UIViewController, ViewModelUpdateDelegate {

//  var bluetoothService: BluetoothService!
  var refreshControl: UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let navigationTextColour = UINavigationBarAppearance()
    navigationTextColour.titleTextAttributes = [.foregroundColor: UIColor.black]
    navigationItem.standardAppearance = navigationTextColour
    navigationItem.title = "Devices"

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshScan), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    
//    bluetoothService = BluetoothService()
    BluetoothService.shared.viewModel?.delegate = self
    
    setupViews()
  }

  private lazy var collectionView: UICollectionView = {
    let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
    let list = UICollectionViewCompositionalLayout.list(using: layoutConfig)
    let view = UICollectionView(frame: .zero, collectionViewLayout: list)
    view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = .white
    view.delegate = self
    view.dataSource = self
    return view
  }()

  private let statusLabel: UILabel = {
    let label = UILabel()
    label.text = "STATUS"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 15)
    return label
  }()

  private let bluetoothStatusLabel: UILabel = {
    let label = UILabel()
    label.text = "CHECKING..."
    label.textColor = .black
    label.textAlignment = .center
    return label
  }()

  private lazy var scanButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Scan", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 16
    button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    button.layer.borderWidth = 2
    button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    button.layer.masksToBounds = false
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    button.addTarget(self, action: #selector(onScanButtonTap), for: .touchUpInside)
    return button
  }()

  @objc private func onScanButtonTap() {
    BluetoothService.shared.viewModel?.scannedDevicesArray = []
    BluetoothService.shared.startScan()
  }

  @objc private func refreshScan() {
    BluetoothService.shared.viewModel?.scannedDevicesArray = []
    BluetoothService.shared.startScan()
    refreshControl.endRefreshing()
  }

  func checkForBluetoothSignal() {
    if BluetoothService.shared.isBluetoothOn {
      bluetoothStatusLabel.text = "Bluetooth is ON"
      bluetoothStatusLabel.textColor = .green
    } else {
      bluetoothStatusLabel.text = "Bluetooth is OFF"
      bluetoothStatusLabel.textColor = .red
    }
  }

  func update() {
    collectionView.reloadData()
  }

  func alert() {
    let alert = UIAlertController(title: "Hi 👋🏼", message: "Please ensure Bluetooth is ON!", preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)

    present(alert, animated: true)
  }

  private func setupViews() {
    [collectionView, statusLabel, bluetoothStatusLabel, scanButton].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate([

      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      collectionView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -16),

      statusLabel.bottomAnchor.constraint(equalTo: bluetoothStatusLabel.topAnchor, constant: -8),
      statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      bluetoothStatusLabel.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -16),
      bluetoothStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      scanButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }

}

// MARK: CollectionView delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return BluetoothService.shared.viewModel?.scannedDevicesArray.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
    cell.deviceLabel.text = BluetoothService.shared.viewModel?.scannedDevicesArray[indexPath.row].name
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let batteryLevel = BluetoothService.shared.viewModel?.batteryLevel else { return }
    //        bluetoothService.selectedDevice()

    let deviceDetailVC = DeviceDetailViewController()
    
    deviceDetailVC.deviceHeaderName = BluetoothService.shared.viewModel?.scannedDevicesArray[indexPath.row].name ?? ""
    deviceDetailVC.deviceDetail = BluetoothService.shared.viewModel?.scannedDevicesArray[indexPath.row].data ?? ""
    deviceDetailVC.deviceRssiDetail = BluetoothService.shared.viewModel?.scannedDevicesArray[indexPath.row].rssi ?? ""
    deviceDetailVC.batteryInfo = String(describing: batteryLevel)
    print("3 didSelectItem", batteryLevel)

    navigationController?.pushViewController(deviceDetailVC, animated: true)
  }

}



