import SwiftUI

struct PhoneLoginView: View {
    @EnvironmentObject var vm: PhoneLoginViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.loggedIn {
                    Text("Welcome, \(vm.currentPhoneNumber)")
                        .font(.title2)
                        .padding(.bottom, 30)
                }
                else {
                    PhoneLoginSubView()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if vm.loggedIn {
                        Button("Sign Out") {
                            vm.signOut()
                        }
                    }
                })
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PhoneLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLoginView()
            .environmentObject(PhoneLoginViewModel())
    }
}

/*
 1. Open GoogleService-Info.plist, copy the value of REVERSED_CLIENT_ID
 2. Select your app > TARGETS > Info > URL Types, add a URL schema with the value
 */

