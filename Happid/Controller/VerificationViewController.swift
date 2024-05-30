 

import UIKit

class VerificationViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var textFeild1: UITextField!
    
    @IBOutlet weak var textFeild2: UITextField!
    
    @IBOutlet weak var textFeild3: UITextField!
    
    @IBOutlet weak var textFeild4: UITextField!
    
    @IBOutlet weak var phoneNoLabel: UILabel!
    
        var num1 = "1"
        var num2 = "2"
        var num3 = "3"
        var num4 = "4"
        var phoneNumberString = "+91"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        phoneNoLabel.text =  "+91 \(phoneNumberString)"
      }
    
    func otpVerification (){
        
    }
    
    
    func setupTextFields() {
           let textFields = [textFeild1, textFeild2, textFeild3, textFeild4]
           for textField in textFields {
               textField?.delegate = self
               textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
           }
       }

       @objc func textFieldDidChange(_ textField: UITextField) {
           guard let text = textField.text, text.count == 1 else { return }

           switch textField {
           case textFeild1:
               textFeild2.becomeFirstResponder()
           case textFeild2:
               textFeild3.becomeFirstResponder()
           case textFeild3:
               textFeild4.becomeFirstResponder()
           case textFeild4:
               textFeild4.resignFirstResponder()
           default:
               break
           }
       }

       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return false }
           let newLength = text.count + string.count - range.length
           return newLength <= 1 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
       }
   

     
    // MARK: - Navigation
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        let enteredNum1 = textFeild1.text ?? ""
               let enteredNum2 = textFeild2.text ?? ""
               let enteredNum3 = textFeild3.text ?? ""
               let enteredNum4 = textFeild4.text ?? ""
               
               if enteredNum1 == num1 && enteredNum2 == num2 && enteredNum3 == num3 && enteredNum4 == num4 {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   if let loginVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                       navigationController?.pushViewController(loginVC, animated: true)
                   }
               } else {
                   showAlert(message: "Otp Not Matched")
               }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
