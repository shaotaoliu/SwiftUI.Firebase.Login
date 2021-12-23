import SwiftUI
import FacebookLogin

struct FacebookLoginView: View {
    @State var manager = LoginManager()
    @State var loggedIn = false
    @State var email = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // FB Login Button:
                // FBLogButton(loggedIn: $loggedIn, email: $email)
                
                Button("FB Login") {
                    manager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        if result!.isCancelled == false {
                            loggedIn = true
                            let request = GraphRequest(graphPath: "me", parameters: ["fields": "email"])
                            
                            request.start { ( _, response, _ ) in
                                guard let data = response as? [String: Any] else {
                                    return
                                }
                                
                                // it is a dictionary
                                email = data["email"] as! String
                            }
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        manager.logOut()
                        loggedIn = false
                        email = ""
                    }
                }
            })
        }
    }
}

struct FacebookLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginView()
    }
}

struct FBLogButton: UIViewRepresentable {
    @Binding var loggedIn: Bool
    @Binding var email: String
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return FBLogButton.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        var parent: FBLogButton
        
        init(parent: FBLogButton) {
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if result!.isCancelled == false {
                parent.loggedIn = true
                
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "email"])
                
                request.start { [self] ( _, response, _ ) in
                    // it is a dictionary
                    guard let data = response as? [String: Any] else {
                        return
                    }
                    
                    parent.email = data["email"] as! String
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            parent.loggedIn = false
            parent.email = ""
        }
    }
}
 
/*
 1. Create a FB app.
 2. Add a product: Facebook Login
 3. Install FB Login SDK: https://github.com/facebook/facebook-ios-sdk
 4. Add your iOS app's bundle id to your FB app.
 5. Add XML (from FB) to your info.plist file.
*/
