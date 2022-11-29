//
//  CollectionViewCell.swift
//  BLEProject
//
//  Created by Ashley Oldham on 15/11/2022.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

  let deviceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 17)
    return label
  }()
  
  static let identifier = "CustomCell"

  override init(frame: CGRect) {
    super .init(frame: frame)
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupLayout() {
    backgroundColor = .darkGray

    [deviceLabel].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate([
      deviceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      deviceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      deviceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
}
