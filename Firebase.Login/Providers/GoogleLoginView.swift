import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleLoginView: View {
    @AppStorage("GoogleLoggedIn") var loggedIn = true
    
    var body: some View {
        NavigationView {
            VStack {
                if loggedIn {
                    Text(Auth.auth().currentUser?.email ?? "Logged in")
                }
                else {
                    GoogleLoginSubView()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if loggedIn {
                        Button("Sign Out") {
                            GIDSignIn.sharedInstance.signOut()
                            try? Auth.auth().signOut()
                            loggedIn = false
                        }
                    }
                })
            })
        }
    }
}

struct GoogleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginView()
    }
}
