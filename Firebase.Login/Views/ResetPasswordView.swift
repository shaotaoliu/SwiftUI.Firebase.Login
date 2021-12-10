import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = LoginViewModel()
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 30) {
            TextField("Email", text: $vm.email)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Button {
                resetPassword()
            } label: {
                Text("Reset Password")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .foregroundColor(.white)
            .background(vm.email.isEmpty ? Color.gray : Color.blue)
            .cornerRadius(15)
            .disabled(vm.email.isEmpty)
            
            ErrorsView(errors: vm.errors)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Reset Password")
        .alert("Sent", isPresented: $vm.showEmailSentMessage, actions: {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        }, message: {
            Text("An email has been sent to the email address above. Please following the instructions in the email to reset your passowrd.")
        })
    }
    
    func resetPassword() {
        vm.resetPassword { success in
            if success {
                email = vm.email
                vm.showEmailSentMessage = true
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResetPasswordView(email: .constant(""))
        }
    }
}
