//
//  CustomCenterTextField.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import SwiftUI

struct CustomCenterTextField: View {
    @Binding var value:String
    @State private var frame = CGRect.zero

    var body: some View {
        return HStack(alignment: .center) {
            ZStack {
                Text(self.value).foregroundColor(Color.clear)
                    .fixedSize()
                    .background(rectReader($frame))

                TextField("0.0", text: $value)
                    .multilineTextAlignment(.leading)
                    .fixedSize()
                    .keyboardType(.decimalPad)
//                    .frame(minWidth: 60, idealWidth: frame.width)
                    .fixedSize(horizontal: true, vertical: false)
//                    .border(Color.black)      // << for demo only

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
