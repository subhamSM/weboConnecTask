 

import UIKit
import CountryPickerView

class LoginViewController: UIViewController ,UITextViewDelegate ,UITextFieldDelegate,CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var countryPickerBtn: UIButton!
    
    @IBOutlet weak var textFeild4: UITextField!
    
    @IBOutlet weak var textFeild3: UITextField!
    
    @IBOutlet weak var textFeild2: UITextField!
    
    @IBOutlet weak var textFeild1: UITextField!
    
    @IBOutlet weak var headingText: UILabel!
    
    @IBOutlet weak var mobileTextFeild: UITextField!
    
    @IBOutlet weak var mobileNumberView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var blurOtpView: UIView!
    
    let countryPickerView = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextFeild.attributedPlaceholder = NSAttributedString(string:  "0 0 0 0 0   0 0 0 0 0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        bottomText ()
        setupTextFields()
        blurOtpView.isHidden = true
                countryPickerView.delegate = self
                countryPickerView.dataSource = self
 
    }
    override func viewWillAppear(_ animated: Bool) {
        blurOtpView.isHidden = true
         mobileTextFeild.attributedPlaceholder = NSAttributedString(string:  "0 0 0 0 0   0 0 0 0 0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    //
    
    @IBAction func countryBtnAction(_ sender: UIButton) {
        countryPickerView.showCountriesList(from: self)

    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let countryFlag = country.flag
        let countryName = country.phoneCode
        print("checkINPrint\(countryFlag) \(countryName)")
        countryPickerBtn.setImage(countryFlag, for: .normal)
        countryPickerBtn.setTitle(countryName, for: .normal)
 
       }
    
    
    //
    func getFourDigitNumber(from mobileNumber: String) -> String? {
        guard mobileNumber.count >= 4 else {
            return nil
        }

         let startIndex = mobileNumber.startIndex
        let secondIndex = mobileNumber.index(startIndex, offsetBy: 1)
        let firstTwo = String(mobileNumber[startIndex...secondIndex])
        
         let endIndex = mobileNumber.index(mobileNumber.endIndex, offsetBy: -1)
        let secondLastIndex = mobileNumber.index(endIndex, offsetBy: -1)
        let lastTwo = String(mobileNumber[secondLastIndex...endIndex])
        
         let fourDigitNumber = firstTwo + lastTwo
        
        return fourDigitNumber
    }

    //
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
    
    func bottomText() {
         let text = "By Creating Passcode You Agree With Our \n    Terms & Conditions And Privacy Policy"
        let termsText = "Terms & Conditions"
        let privacyPolicyText = "Privacy Policy"
        
         let textRange = NSRange(location: 0, length: text.count)
        
         let attributedString = NSMutableAttributedString(string: text)
        
         attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: textRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: textRange)
        
         if let termsRange = text.range(of: termsText) {
            let nsRange = NSRange(termsRange, in: text)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 127/255, blue: 93/255, alpha: 1.0), range: nsRange)
            attributedString.addAttribute(.link, value: "terms://", range: nsRange)
        }
        
        if let privacyPolicyRange = text.range(of: privacyPolicyText) {
            let nsRange = NSRange(privacyPolicyRange, in: text)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 127/255, blue: 93/255, alpha: 1.0), range: nsRange)
            attributedString.addAttribute(.link, value: "privacy://", range: nsRange)
        }
        
         textView.attributedText = attributedString
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textAlignment = .center
    }



             func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
                if URL.scheme == "terms" {
                     print("Terms & Conditions tapped")
                     return false
                } else if URL.scheme == "privacy" {
                     print("Privacy Policy tapped")
                     return false
                }
                return true
            }
    
    
    
    @IBAction func requestBtnAction(_ sender: UIButton) {
 
        if mobileTextFeild.text != ""{
            blurOtpView.isHidden = false
        }else {
              showAlert(message: "Please Enter Mobile Number")

        }
       
        
        guard let mobileNumber = mobileTextFeild.text else {
            print("No mobile number entered")
            return
        }
        
        if let fourDigitNumber = getFourDigitNumber(from: mobileNumber) {
            print("Four-digit number: \(fourDigitNumber)")
            
             if fourDigitNumber.count == 4 {
                let firstDigit = fourDigitNumber[fourDigitNumber.startIndex]
                let secondDigit = fourDigitNumber[fourDigitNumber.index(after: fourDigitNumber.startIndex)]
                let thirdDigit = fourDigitNumber[fourDigitNumber.index(fourDigitNumber.startIndex, offsetBy: 2)]
                let fourthDigit = fourDigitNumber[fourDigitNumber.index(before: fourDigitNumber.endIndex)]
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.textFeild1.text = String(firstDigit)
                    self.textFeild2.text = String(secondDigit)
                    self.textFeild3.text = String(thirdDigit)
                    self.textFeild4.text = String(fourthDigit)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let secondVC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                             secondVC.num1 = self.textFeild1.text!
                            secondVC.num2 = self.textFeild2.text!
                            secondVC.num3 = self.textFeild3.text!
                            secondVC.num4 = self.textFeild4.text!
                            secondVC.phoneNumberString = self.mobileTextFeild.text!
                            self.navigationController?.pushViewController(secondVC, animated: true)
                        }
                    }
                }

            } else {
                print("Mobile number is too short")
                
            }
        }
        
        
    }
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
