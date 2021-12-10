import SwiftUI

struct ErrorsView: View {
    let errors: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(errors, id: \.self) { error in
                HStack(alignment: .top) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 16))
                        .padding(.top, 5)
                    
                    Text(error)
                        .font(.title2)
                }
                .padding(.vertical, 5)
            }
        }
        .foregroundColor(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ErrorsView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorsView(errors: [
            "Email is empty",
            "Invalid password",
            "The email address is badly formatted. Please correct it."
        ])
            .padding()
    }
}
