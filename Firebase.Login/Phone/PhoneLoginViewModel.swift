import SwiftUI
import FirebaseAuth

class PhoneLoginViewModel: ObservableObject {
    @Published var countryCode = ""
    @Published var phoneNumber = ""
    @Published var verifyID = ""
    @Published var verifyCode = ""
    @Published var showVerifyView = false
    @AppStorage("PhoneLoggedIn") var loggedIn = false
    
    private let provider = PhoneAuthProvider.provider()
    private let auth = Auth.auth()
    
    var currentPhoneNumber: String {
        auth.currentUser?.phoneNumber ?? ""
    }
    
    @Published var hasError = false
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
    
    func verifyPhoneNumber() {
        // Enable for test; disable when running on real device
        // Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        provider.verifyPhoneNumber("+\(countryCode)\(phoneNumber)", uiDelegate: nil) { id, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.verifyID = id!
            self.showVerifyView = true
        }
    }
    
    func signIn() {
        let credential = provider.credential(withVerificationID: verifyID, verificationCode: verifyCode)
        
        auth.signIn(with: credential) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.showVerifyView = false
            self.loggedIn = true
        }
        
        countryCode = ""
        phoneNumber = ""
    }
    
    func signOut() {
        do {
            try auth.signOut()
            self.loggedIn = false
        }
        catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
