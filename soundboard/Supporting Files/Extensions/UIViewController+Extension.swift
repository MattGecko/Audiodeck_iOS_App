//
//  UIViewController+Extension.swift
//  ReviewsTap
//
//  Created by Horizam on 14/09/2023.
//

import UIKit

extension UIViewController {
    //MARK: - Alerts
    func showAlertWith(title: String?, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    func showAlert(withTitle title : String?, message : String, completion: ((_ status: Bool) -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?(true)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func askAlert(withTitle title : String?, message : String, okBtnTitle: String, cancelBtnTitle: String, completion: ((_ status: Bool) -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okBtnTitle, style: .default) { (action) in
            completion?(true)
        }
        
        let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: nil)

        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showErrorAlert() {
        
        self.showAlertWith(title: "ERROR!", message: "Something went wrong try again!")
        
    }
    
    
    //MARK: Toast
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = .systemGreen
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    func showErrorToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = .red
        alert.view.tintColor = .white
        
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlertWithInputField(withTitle: String, message: String, placeholder: String, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false, textAlignment: NSTextAlignment = .left, completion: ((_ text: String, _ noEntry: Bool) -> Void)? = nil) {
            
            let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                //            textField.delegate = self
                textField.placeholder = placeholder
                textField.isSecureTextEntry = isSecureTextEntry
                textField.textAlignment = textAlignment
                textField.keyboardType = keyboardType
                textField.doneAccessory = true
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                completion?("", true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(textField?.text ?? "")")
                
                if textField?.text != "" || textField?.text != nil {
                    completion?(textField?.text ?? "", false)
                } else {
                    completion?("", true)
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    
    
//    func getErrorMessage(data: Any?) {
//
//        if let data : Data = data as? Data {
//
//            let decoder = JSONDecoder()
//
//            do {
//
//                let msg = try decoder.decode(Message_Model.self, from: data)
//
//                self.showAlertWith(title: "Error", message: msg.message!)
//
//            } catch {
//
//                print(error.localizedDescription)
//
//            }
//
//        }
//    }
}
