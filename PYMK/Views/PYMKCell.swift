//
//  PYMKCell.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

@objc final class PYMKCell: UITableViewCell {
    
    private enum CellMetrics {
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 15
    }
    
    // MARK: View Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initComplete()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComplete()
    }
    
    // MARK: Public Interface
    
    func configure(with person: Person) {
        nameLabel.text = person.name
        if let count = person.mutualCount, let distance = person.distance, distance == 2 {
            distanceLabel.text = "Social Distance: \(distance), Mutual Friends: \(count)"
        } else if let distance = person.distance {
            distanceLabel.text = "Social Distance: \(distance)"
        } else {
            distanceLabel.text = ""
        }
    }
    
    // MARK: Private
    
    private func initComplete() {
        
        // Layout
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellMetrics.horizontalMargin),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellMetrics.verticalMargin),
        ])
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)
        NSLayoutConstraint.activate([
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellMetrics.horizontalMargin),
            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellMetrics.verticalMargin)
        ])
        
        // Accessiblity
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIContentSizeCategory.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        
        // Styling
        updateFonts()
        updateColors()
    }
    
    @objc private func updateFonts() {
        let titleFont = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.font = titleFont
        
        let subtitleFont = UIFont.preferredFont(forTextStyle: .caption1)
        distanceLabel.font = subtitleFont
    }
    
    private func updateColors() {
        contentView.backgroundColor = .black
        nameLabel.textColor = .white
        distanceLabel.textColor = StyleGuide.Colors.yellow
    }
}

