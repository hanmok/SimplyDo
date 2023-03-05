//
//  TestViewController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/03/05.
//

import UIKit
import Then
import SnapKit
import AudioToolbox

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private let btn = UIButton().then {
        $0.backgroundColor = .magenta
    }
    
    var currentSound: Int? = 1000
    
    private let myField: UITextField = {
        let textField = UITextField()

        textField.keyboardType = .numberPad
        textField.backgroundColor = .gray
        return textField
    }()
    
    private let label = UILabel().then {
        $0.textColor = .cyan
    }
    
    @objc func makeSound() {
        if let currentSound = currentSound {
            print("currentSound: \(currentSound)")
            let soundId: SystemSoundID = SystemSoundID(currentSound)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    
    @objc func txtChanged(_ textField: UITextField) {
        let text = textField.text!
        print("txtChanged! to \(text)")
        if let int = Int(text) {
            currentSound = int
            DispatchQueue.main.async {
                self.label.text = String(int)
            }
        }
    }
    
    func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [myField, btn, label])
        stackView.backgroundColor = .indigo
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        myField.delegate = self
        btn.addTarget(self, action: #selector(makeSound), for: .touchUpInside)
        myField.addTarget(self, action: #selector(txtChanged(_:)), for: .editingChanged)
        
        [stackView].forEach {
            self.view.addSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
    }
}

extension TestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!
        if let int = Int(text) {
            currentSound = int
            DispatchQueue.main.async {
                self.label.text = String(int)
            }
        }
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text!
        
        if let int = Int(text) {
            currentSound = int
            DispatchQueue.main.async {
                self.label.text = String(int)
            }
        }
    }
}
