//
//  DeviceListCell.swift
//  CornOffice
//
//  Created by Artem Murashko on 19.04.2022.
//

import UIKit

class BulbViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "BulbViewCell"
    
    // MARK: - UI
    
    let bulbLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let deviceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let controlPanelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Control panel"
        
        return label
    }()
    
    let turnOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.text = "Turn the bulb on/off:"
        
        return label
    }()
    
    let turnOnSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        return switcher
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        clipsToBounds = true
        
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 0, right: 5))
    }
    
    // MARK: - Layout
    
    func setupViews() {
        contentView.addSubview(bulbLogo)
        contentView.addSubview(placeLabel)
        contentView.addSubview(deviceNameLabel)
        contentView.addSubview(controlPanelLabel)
        
        contentView.addSubview(turnOnLabel)
        contentView.addSubview(turnOnSwitch)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bulbLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            bulbLogo.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bulbLogo.widthAnchor.constraint(equalToConstant: 50),
            bulbLogo.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: bulbLogo.trailingAnchor, constant: 5),
            placeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            placeLabel.heightAnchor.constraint(equalToConstant: 30),
            placeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            deviceNameLabel.leadingAnchor.constraint(equalTo: bulbLogo.trailingAnchor, constant: 5),
            deviceNameLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 5),
            deviceNameLabel.heightAnchor.constraint(equalToConstant: 25),
            deviceNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            controlPanelLabel.topAnchor.constraint(equalTo: bulbLogo.bottomAnchor, constant: 10),
            controlPanelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            controlPanelLabel.heightAnchor.constraint(equalToConstant: 25),
            controlPanelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            turnOnLabel.topAnchor.constraint(equalTo: controlPanelLabel.bottomAnchor, constant: 10),
            turnOnLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            turnOnLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            turnOnSwitch.topAnchor.constraint(equalTo: controlPanelLabel.bottomAnchor, constant: 10),
            turnOnSwitch.leadingAnchor.constraint(equalTo: turnOnLabel.trailingAnchor, constant: 10),
            turnOnSwitch.heightAnchor.constraint(equalToConstant: 25),
            turnOnSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Settings
    func configure(with deviceModel: DeviceModel) {
        placeLabel.text = deviceModel.place
        deviceNameLabel.text = deviceModel.name
        turnOnSwitch.isOn = deviceModel.status
        
        if (!deviceModel.status) {
            bulbLogo.image = UIImage(systemName: "lightbulb")
            bulbLogo.tintColor = .black
        } else {
            bulbLogo.image = UIImage(systemName: "lightbulb.fill")
            bulbLogo.tintColor = .systemYellow
        }
    }
    
    func animate() {
        self.layoutIfNeeded()
    }
}
