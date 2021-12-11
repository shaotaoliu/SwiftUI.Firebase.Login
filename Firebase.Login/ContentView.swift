import SwiftUI

struct ContentView: View {
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CreateAccountView(email: $vm.email), isActive: $vm.showNewAccountView) { EmptyView() }
                NavigationLink(destination: ResetPasswordView(email: $vm.email), isActive: $vm.showResetPasswordView) { EmptyView() }
                NavigationLink(destination: MainView(), isActive: $vm.showMainView) { EmptyView() }
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(20)

                VStack(spacing: 15) {
                    TextField("Email", text: $vm.email)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $vm.password)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    Button {
                        vm.signIn() { success in
                            if success {
                                vm.showMainView = true
                            }
                        }
                    } label: {
                        Text("Sign In")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(15)
                    
                    Button {
                        vm.showNewAccountView = true
                    } label: {
                        Text("Create Account")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                ErrorsView(errors: vm.errors)
                
                Spacer()
                
                Button {
                    vm.showResetPasswordView = true
                } label: {
                    Text("Forgot Password?")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationTitle("Login Page")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LoginViewModel())
    }
}
