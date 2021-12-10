import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("Wellcome to the App!")
                .font(.title.bold())
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button("Sign Out") {
            if vm.signOut() {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
        }
    }
}
