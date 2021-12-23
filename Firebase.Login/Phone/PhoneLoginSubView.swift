import SwiftUI

struct PhoneLoginSubView: View {
    @EnvironmentObject var vm: PhoneLoginViewModel
    
    var body : some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Enter phone number:")
                
                HStack(spacing: 10) {
                    TextField("+1", text: $vm.countryCode)
                        .frame(width: 80)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                       
                    TextField("Number", text: $vm.phoneNumber)
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
            }
            .font(.title2)
            .frame(maxWidth: .infinity)
            
            NavigationLink(destination: PhoneLoginVerifyView(), isActive: $vm.showVerifyView) {
                Button(action: {
                    vm.verifyPhoneNumber()
                }, label: {
                    Text("Send")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 50)
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
            }
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $vm.hasError, presenting: vm.errorMessage, actions: { message in
        }, message: { message in
            Text(vm.errorMessage!)
        })
    }
}

struct PhoneLoginSubView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLoginSubView()
            .environmentObject(PhoneLoginViewModel())
    }
}
