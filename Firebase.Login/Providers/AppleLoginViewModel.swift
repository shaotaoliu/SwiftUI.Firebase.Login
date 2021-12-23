import SwiftUI
import CryptoKit
import Firebase
import AuthenticationServices

class AppleLoginViewModel: ObservableObject {
    
    // For every sign-in request, generate a random string (called "nonce") to make sure that
    // the ID token was granted specifically in response to the auth request.
    // It is important to prevent replay attachs.
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    // Send the SHA256 hash of the nonce with the sign-in request.
    // Apple will pass unchanged in the response.
    // Firebase validates the response by hashing the original nonce
    // and comparing it to the value passed by Apple.
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // If sign-in was successful, anthenticate with Firebase using the ID token
    // in the response of Apple with the unhashed nonce.
    
    func authenticate(credential: ASAuthorizationAppleIDCredential, nonce: String) {
        guard let token = credential.identityToken else {
            print("Unable to fetch identity token.")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("Unable to serialize token string.")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Logged in successfully")
        }
    }
}
