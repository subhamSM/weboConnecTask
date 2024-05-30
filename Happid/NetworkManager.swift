import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func submitUserProfile(userProfile: UserProfile, profileImage: UIImage?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "https://dummyapi.com/submit"
        
        // Multipart form data construction
        AF.upload(multipartFormData: { (formData) in
            // Append profile image if available
            if let image = profileImage, let imageData = image.jpegData(compressionQuality: 0.5) {
                formData.append(imageData, withName: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
            }
            
            // Append user profile fields
            formData.append(userProfile.firstName.data(using: .utf8)!, withName: "firstName")
            formData.append(userProfile.lastName.data(using: .utf8)!, withName: "lastName")
            formData.append(userProfile.mobileNumber.data(using: .utf8)!, withName: "mobileNumber")
            formData.append(userProfile.pinCode.data(using: .utf8)!, withName: "pinCode")
            
        }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data"])
        .responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
