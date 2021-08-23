//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Natali Malich on 18.08.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    private var habit: Habit?
    var onRemove = {}
    
    private lazy var scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           return scrollView
       }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = .footnoteBold
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = .body
        textField.textColor = .black
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.clipsToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = .footnoteBold
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orangeColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(onColorButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = .footnoteBold
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в "
        label.font = .body
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purpleColor
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .body
        button.addTarget(self, action: #selector(OnDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init (habit: Habit?) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupHideKeyboardOnTap()
        
        nameTextField.delegate = self
        
        if let habit = habit {
            nameTextField.text = habit.name
            colorButton.backgroundColor = habit.color
            timePicker.setDate(habit.date, animated: true)
            setTime()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension HabitViewController {
    private func setupNavigationBar() {
        if habit == nil {
            
            navigationItem.title = "Создать"
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.tintColor = .purpleColor
            
            let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(onSaveButton))
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
            let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(onCancelButton))
            navigationItem.leftBarButtonItem = leftBarButtonItem
            
            deleteButton.isHidden = true
        } else {
            navigationItem.title = "Править"
            navigationController?.navigationBar.tintColor = .purpleColor
            
            let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(onSaveButton))
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
            let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(onCancelButton))
            navigationItem.leftBarButtonItem = leftBarButtonItem
            
            deleteButton.isHidden = false
        }
    }
}

extension HabitViewController {
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(nameTitleLabel, nameTextField, colorTitleLabel, colorButton, timeTitleLabel, timeLabel, setTimeLabel, timePicker, deleteButton)
    }
}

extension HabitViewController {
    private func setupConstraints() {
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            nameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            colorButton.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 7),
            colorButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorButton.heightAnchor.constraint(equalToConstant: 30),
            colorButton.widthAnchor.constraint(equalTo: colorButton.heightAnchor),
            
            timeTitleLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 15),
            timeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            timeLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 7),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            setTimeLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 7),
            setTimeLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            timePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timePicker.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -52),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}

extension HabitViewController {
    
    @objc func onSaveButton() {
        if habit == nil {
            let habit = Habit(name: nameTextField.text!, date: timePicker.date, color: colorButton.backgroundColor!)
            let store = HabitsStore.shared
            store.habits.append(habit)
            dismiss(animated: true, completion: nil)
        } else {
            let index = HabitsStore.shared.habits.firstIndex(of: habit!)
            habit!.name = nameTextField.text!
            habit!.color = colorButton.backgroundColor!
            habit!.date = timePicker.date
            HabitsStore.shared.habits[index!] = habit!
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func OnDeleteButton() {
        
        if let habit = habit {
            let alertVC = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit.name)?", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Удалить", style: .default) { UIAlertAction in
                self.deleteHabit()
            }
            alertVC.addAction(cancel)
            alertVC.addAction(delete)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
        
    func deleteHabit() {
        HabitsStore.shared.habits.removeAll{$0 == self.habit}
        dismiss(animated: false, completion: onRemove)
    }
    
    @objc func onCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onColorButton() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = self.colorButton.backgroundColor!
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func setTime() {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .short
        setTimeLabel.text = dateFormater.string(from: timePicker.date)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
}

extension HabitViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension HabitViewController: UITextFieldDelegate {
    //Скрытие keyboard при нажатии за пределами TextField
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    //Скрытие keyboard при нажатии клавиши Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
