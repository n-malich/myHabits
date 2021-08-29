//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Natali Malich on 18.08.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
}

extension HabitsViewController {
    private func setupNavigationBar() {
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.isTranslucent = true
        appearance.backgroundColor = .navigationColor
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onCreateHabit))
    }
    
    @objc func onCreateHabit() {
        let habitVC = HabitViewController(habit: nil)
        let habitNavigationVC = UINavigationController(rootViewController: habitVC)
        habitNavigationVC.modalPresentationStyle = .fullScreen
        present(habitNavigationVC, animated: true, completion: nil)
    }
}

extension HabitsViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGrayColor
        
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: "progressID")
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "habitID")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension HabitsViewController {
    private func setupConstraints() {
        [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        .forEach {$0.isActive = true}
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressID", for: indexPath) as! ProgressCollectionViewCell
            cell.refreshProgress()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitID", for: indexPath) as! HabitCollectionViewCell
            cell.habit = HabitsStore.shared.habits[indexPath.item]
            cell.onHabitTrack = {collectionView.reloadSections(IndexSet(integer: 0))}
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let habitDetailsVC = HabitDetailsViewController(habit: HabitsStore.shared.habits[indexPath.item])
            navigationController?.pushViewController(habitDetailsVC, animated: true)
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt IndexPath: IndexPath) -> CGSize {
        if IndexPath.section == 0 {
            return CGSize(width: view.bounds.width - 32, height: 60)
        } else {
            return CGSize(width: view.bounds.width - 32, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 18 , right: 16)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 22, right: 16)
        }
    }
}
