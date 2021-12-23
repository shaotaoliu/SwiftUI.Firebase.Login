import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm = AppleLoginViewModel()
    @State private var nonce = ""
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.continue) { request in
                nonce = vm.randomNonceString()
                request.nonce = vm.sha256(nonce)
                request.requestedScopes = [.email, .fullName]
                
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else {
                        print("Error with Firebase")
                        return
                    }
                    
                    print(credential.email ?? "")
                    vm.authenticate(credential: credential, nonce: nonce)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    return
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 50)
            .padding()
            .cornerRadius(10)
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}

/*
 1. You need an Apple Developer account (need to pay)
 2. Select your app > TARGETS > Signing & Capabilities > + Capability
 3. Add "Sign in with Apple"
*/
