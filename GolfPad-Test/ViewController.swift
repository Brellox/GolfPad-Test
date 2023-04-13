//
//  ViewController.swift
//  GolfPad-Test
//
//  Created by Иван Суслов on 13.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var handicapLabel: UILabel!
    @IBOutlet weak var indexField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    private var presenter = MainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indexField.delegate = self
        self.ratingField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func hideKeyboard () {
        
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        
        if indexField.isEditing || ratingField.isEditing {
            
            moveViewWithKeyboard(
                notification: notification,
                viewBottomConstraint: self.buttonBottomConstraint,
                keyboardWillShow: true)
        }
    }
    
    @objc private func keyboardWillHide (notification: NSNotification){
        
        moveViewWithKeyboard (notification: notification,
                              viewBottomConstraint: self.buttonBottomConstraint,
                              keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard ( notification: NSNotification,
                                viewBottomConstraint: NSLayoutConstraint,
                                keyboardWillShow: Bool ) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let keyboardCurve = UIView.AnimationCurve (rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        } else {
            
            viewBottomConstraint.constant = 20
        }
        
        let animator = UIViewPropertyAnimator( duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded ()
        }
        
        animator.startAnimation()
    }
    
    @IBAction func calculateAction (_ sender: Any) {
        
        if let result = presenter.calculateTheHandicap (index: indexField.text, rating: ratingField.text){
            handicapLabel.text = result
        } else {
            
            self.showToast (message: presenter.message, interval: 2)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField (_ textField: UITextField) {
        
        switch textField {
            
        case self.indexField:
            self.ratingField.becomeFirstResponder()
        default:
            self.ratingField.resignFirstResponder()
        }
    }
}
