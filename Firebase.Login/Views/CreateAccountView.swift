import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = LoginViewModel()
    @Binding var email: String
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                TextField("Email", text: $vm.email)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $vm.password)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Repeat Password", text: $vm.password2)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack {
                Button {
                    createNewAccount()
                } label: {
                    Text("Create Account")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
            }
            .padding(.vertical)
            
            ErrorsView(errors: vm.errors)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Create New Account")
    }
    
    func createNewAccount() {
        vm.createNewAccount { success in
            if success {
                email = vm.email
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccountView(email: .constant(""))
        }
    }
}
