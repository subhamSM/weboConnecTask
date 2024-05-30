////
////  ProfileViewController.swift
////  Happid
////
////  Created by Deepak Kumar on 29/05/24.
////
//
//import UIKit
//
//class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    
//    @IBOutlet weak var profileBtn: UIButton!
//    @IBOutlet weak var firstName: UITextField!
//    @IBOutlet weak var lastName: UITextField!
//    @IBOutlet weak var mobileNumber: UITextField!
//    @IBOutlet weak var pinCode: UITextField!
//    
//    var selectedImage: UIImage?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        profileBtn.layer.cornerRadius = profileBtn.frame.size.width / 2
//        profileBtn.clipsToBounds = true
//        profileBtn.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
//    }
//    
//    @objc func pickImage() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.allowsEditing = false
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    
//    // MARK: - UIImagePickerControllerDelegate Methods
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            selectedImage = pickedImage
//            profileBtn.imageView?.contentMode = .scaleAspectFit
//            profileBtn.setImage(pickedImage, for: .normal)
//            
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func backBtnAction(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func ProfileBtnAction(_ sender: UIButton) {
//    }
//    
//    @IBAction func submitBtnAction(_ sender: UIButton) {
//        guard let firstName = firstName.text,
//              let lastName = lastName.text,
//              let mobileNumber = mobileNumber.text,
//              let pinCode = pinCode.text else {
//            // Handle case where form fields are empty
//            return
//        }
//        
//         let userProfile = UserProfile(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, pinCode: pinCode)
//        
//        let url = URL(string: "https://dummyapi.com/submit")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            let jsonData = try JSONEncoder().encode(userProfile)
//            request.httpBody = jsonData
//        } catch {
//            // Handle error
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                // Handle error
//                return
//            }
//            // Handle response
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Response JSON: \(json)")
//                    // Show success alert on the main thread
//                    DispatchQueue.main.async {
//                        self.showSuccessAlert()
//                    }
//                }
//            } catch {
//                // Handle error
//            }
//        }
//        task.resume()
//    }
//    
//    func showSuccessAlert() {
//        let alert = UIAlertController(title: "Success", message: "Profile data submitted successfully!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}



//
import UIKit
import Alamofire

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var pinCode: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileButton()
    }
    
    private func setupProfileButton() {
        profileBtn.layer.cornerRadius = profileBtn.frame.size.width / 2
        profileBtn.clipsToBounds = true
        profileBtn.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    @objc func pickImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            profileBtn.setImage(pickedImage, for: .normal)
            profileBtn.imageView?.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ProfileBtnAction(_ sender: UIButton) {
        // Handle profile button action if needed
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        guard let firstName = firstName.text,
              let lastName = lastName.text,
              let mobileNumber = mobileNumber.text,
              
              let pinCode = pinCode.text else {
           
             return
        }
        if firstName != ""{
            showSuccessAlertApi()
        }else{
            showSuccessAlert (message:"Please Input the Value", title:  "Error")
        }
        
        let userProfile = UserProfile(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, pinCode: pinCode)
        
        NetworkManager.shared.submitUserProfile(userProfile: userProfile, profileImage: selectedImage) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.showSuccessAlert(message: "Profile data submitted successfully!", title:  "Success")
                }
            case .failure(let error):
                print("Error submitting profile: \(error)")
                // Handle error (show alert, etc.)
            }
        }
    }
    
    func showSuccessAlert(message:String,title:String) {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showSuccessAlertApi() {
        let alert = UIAlertController(title: "Success", message: "Profile data submitted successfully! to dummy api Url", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
             
 
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}

