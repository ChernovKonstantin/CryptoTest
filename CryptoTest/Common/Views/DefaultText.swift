import SwiftUI

struct DefaultText: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(color)
    }
}

#Preview {
    DefaultText(text: "Test", color: .black)
}
