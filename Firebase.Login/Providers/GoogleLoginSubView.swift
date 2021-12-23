import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleLoginSubView: View {
    @AppStorage("GoogleLoggedIn") var loggedIn = false
    @State private var loading = false
    
    var body: some View {
        VStack {
            Button("Login") {
                handleLogin()
            }
            
            // GIDSignInButton in UIKit
        }
        .overlay(
            ZStack {
                if loading {
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        )
    }
    
    func handleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        loading = true
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, error in
            if let error = error {
                loading = false
                print(error.localizedDescription)
                return
            }
            
            guard let auth = user?.authentication, let token = auth.idToken else {
                loading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    loading = false
                    return
                }
                
                guard let user = result?.user else {
                    loading = false
                    return
                }
                
                print(user.displayName ?? "")
                
                loggedIn = true
                loading = false
            }
        }
    }
}

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct GoogleLoginSubView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginSubView()
    }
}

/*
 1. Add package: https://github.com/google/GoogleSignIn-iOS
 2. Open GoogleService-Info.plist, copy the value of REVERSED_CLIENT_ID
 3. Select your app > TARGETS > Info > URL Types > + button, add a URL schema with the value
 
 */
