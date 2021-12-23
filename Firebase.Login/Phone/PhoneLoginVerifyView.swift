import SwiftUI

struct PhoneLoginVerifyView: View {
    @EnvironmentObject var vm: PhoneLoginViewModel
    
    var body : some View{
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter verification code:")

                TextField("Code", text: $vm.verifyCode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
            }
            .font(.title2)
            .frame(maxWidth: .infinity)
            
            Button(action: {
                vm.signIn()
            }, label: {
                Text("Verify")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $vm.hasError, presenting: vm.errorMessage, actions: { message in
        }, message: { message in
            Text(vm.errorMessage!)
        })
    }
}

struct PhoneLoginVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLoginVerifyView()
            .environmentObject(PhoneLoginViewModel())
    }
}
