//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Natali Malich on 18.08.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.font = .footnoteStatus
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = .footnoteStatus
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .systemGray
        progressView.progressTintColor = .purpleColor
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
        refreshProgress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshProgress() -> Void {
        percentLabel.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
        progressView.setProgress(HabitsStore.shared.todayProgress, animated: true)
    }
}

extension ProgressCollectionViewCell {
    private func setupViews() {
        contentView.addSubviews(titleLabel, percentLabel, progressView)
    }
}

extension ProgressCollectionViewCell {
    private func setupConstraints() {
        [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        .forEach {$0.isActive = true}
    }
}
