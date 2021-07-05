//
//  CustomCenterTextField.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import SwiftUI

//This file is a textfield that adjusts its width to its content, you can also set a minimum width if you want. It is surprisingly difficult to make a textview do this with swiftui provided code.
struct CustomCenterTextField: View {
    
    @Binding var value:String
    let keyboardType: UIKeyboardType
    let defaultValue: String
    
    @State private var frame = CGRect.zero

    var body: some View {
        return HStack(alignment: .center) {
            ZStack {
                Text(self.value).foregroundColor(Color.clear)
                    .fixedSize()
                    .background(rectReader($frame))

                TextField(defaultValue, text: $value)
                    .multilineTextAlignment(.leading)
                    .fixedSize()
                    .keyboardType(keyboardType)
//                    .frame(minWidth: 60, idealWidth: frame.width)
                    .fixedSize(horizontal: true, vertical: false)
//                    .border(Color.black)      // << to check its boundaries/size

            }.font(Font.system(size: 16).bold())
        }
    }
}

func rectReader(_ binding: Binding<CGRect>) -> some View {
    return GeometryReader { (geometry) -> AnyView in
        let rect = geometry.frame(in: .global)
        DispatchQueue.main.async {
            binding.wrappedValue = rect
        }
        return AnyView(Rectangle().fill(Color.clear))
    }
}

//struct CustomCenterTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCenterTextField()
//    }
//}
