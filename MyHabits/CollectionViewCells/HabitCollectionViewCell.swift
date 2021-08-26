//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Natali Malich on 18.08.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit? {
        didSet {
            if let habit = habit {
                nameLabel.text = habit.name
                nameLabel.textColor = habit.color
                timeLabel.text = habit.dateString
                counterLabel.text = "Счётчик: \(habit.trackDates.count)"
                colorButton.layer.borderColor = habit.color.cgColor
                
                if habit.isAlreadyTakenToday {
                    colorButton.backgroundColor = habit.color
                } else {
                    colorButton.backgroundColor = .white
                }
            }
        }
    }
    
    var onHabitTrack = {}
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headLine
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .footnote
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 3
        button.addTarget(self, action: #selector(onColorButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
                   setupViews()
                   setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HabitCollectionViewCell {
    @objc func onColorButton() {
        if habit?.isAlreadyTakenToday == false {
            colorButton.backgroundColor = habit?.color
            HabitsStore.shared.track(habit!)
            counterLabel.text = "Счётчик: \(habit!.trackDates.count)"
            onHabitTrack()
        }
    }
}

extension HabitCollectionViewCell {
    private func setupViews() {
        contentView.addSubviews(nameLabel, timeLabel, counterLabel, colorButton)
    }
}

extension HabitCollectionViewCell {
    private func setupConstraints() {
        [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -88),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            colorButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            colorButton.heightAnchor.constraint(equalToConstant: 38),
            colorButton.widthAnchor.constraint(equalTo: colorButton.heightAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}
