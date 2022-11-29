//
//  ViewController.swift
//  BLEProject
//
//  Created by Ashley Oldham on 14/11/2022.
//

import UIKit

class MainViewController: UIViewController, BluetoothView, BLEProjectView {

  var bluetoothService: BluetoothService!
  var viewModel: BLEProjectViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray
    navigationItem.title = "Devices"
    
    bluetoothService = BluetoothService(view: self)
//    viewModel = BLEProjectViewModel(view: self)
    setupViews()
  }

  private lazy var collectionView: UICollectionView = {
    let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
    let list = UICollectionViewCompositionalLayout.list(using: layoutConfig)
    let view = UICollectionView(frame: .zero, collectionViewLayout: list)
    view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = .darkGray
    view.delegate = self
    view.dataSource = self
    return view
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
    bluetoothService.startScan()
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
    [collectionView, scanButton].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate([

      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      collectionView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -16),

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
    return bluetoothService.scannedDevicesArray.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
    cell.deviceLabel.text = bluetoothService.scannedDevicesArray[indexPath.row].name
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    let deviceDetailVC = DeviceDetailViewController()
    deviceDetailVC.deviceDetail = bluetoothService.scannedDevicesArray[indexPath.row].data ?? ""

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      deviceDetailVC.batteryInfo = self.bluetoothService.batteryLevel ?? "Error reading data"
      print("3 didSelectItem", self.bluetoothService.batteryLevel ?? "Error!")
    }

    navigationController?.pushViewController(deviceDetailVC, animated: true)
    bluetoothService.selectedDevice()
  }


}



