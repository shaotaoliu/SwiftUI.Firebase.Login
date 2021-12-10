import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var password2 = ""
    @Published var errors: [String] = []
    @Published var showNewAccountView = false
    @Published var showResetPasswordView = false
    @Published var showMainView = false
    @Published var showEmailSentMessage = false

    func createNewAccount(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        if email.isEmpty {
            errors.append("Email cannot be empty")
        }
        
        if password.isEmpty {
            errors.append("Password cannot be empty")
        }
        
        if password != password2 {
            errors.append("Passwords do not match")
        }
        
        if !errors.isEmpty {
            completion(false)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            print(result!.user.uid)
            //example: sEU03BRFUsW8GNBT0JzhFOzoQ6l1
            
            completion(true)
            return
        }
    }
    
    func resetPassword(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        if email.isEmpty {
            errors.append("Email cannot be empty")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            self.email = ""
            self.password = ""
            
            completion(true)
            return
        }
    }
    
    func signOut() -> Bool {
        errors.removeAll()
        
        do {
            try Auth.auth().signOut()
        }
        catch {
            errors.append(error.localizedDescription)
            return false
        }
        
        return true
    }
}
