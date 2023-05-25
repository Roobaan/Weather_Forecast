//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by Roobaan M T on 24/05/23.
//

import UIKit

class WeatherCell : UITableViewCell {

    lazy var dateLabel = UILabel()
    
    lazy var weatherIcon = UIImageView()

    lazy var minTempLabel = UILabel()
    
    lazy var maxTempLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            cellUISetup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    func cellUISetup(){
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(dateLabel)
        weatherIcon.contentMode = .scaleAspectFit
        contentView.addSubview(weatherIcon)
        minTempLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(minTempLabel)
        maxTempLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(maxTempLabel)
       
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = [
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weatherIcon.heightAnchor.constraint(equalToConstant: 50),
            weatherIcon.widthAnchor.constraint(equalToConstant: 50),
            weatherIcon.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            minTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            minTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            maxTempLabel.trailingAnchor.constraint(equalTo: minTempLabel.leadingAnchor, constant: -20),
            maxTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ]
        NSLayoutConstraint.activate(constraint)
        
    }
}


