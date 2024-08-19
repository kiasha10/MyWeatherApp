//
//  WeatherFavouritesScreenTableViewCell.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/15.
//

import UIKit

class WeatherFavouritesScreenTableViewCell: UITableViewCell {
        
    // MARK: IBOutlets
        
        private let cityLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.textColor = .label
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(cityLabel)
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func configure(with city: String) {
        cityLabel.text = city
        }
    }
