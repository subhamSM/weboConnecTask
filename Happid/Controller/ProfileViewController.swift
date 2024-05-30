 
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
     }
    
     func pickImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
 
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
        pickImage()
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

