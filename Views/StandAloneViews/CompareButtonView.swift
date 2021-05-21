//
//  CompareButtonView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 21/5/21.
//

import SwiftUI

struct CompareButtonView: View {
    
    let action: () -> Void
    @Binding var buttonText:String
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .padding()
                .foregroundColor(.white)
        }
        .background(Capsule()
                        .fill(Color.blue)
                        .frame(minWidth: 100, minHeight: 50))
        .padding()
    } 
}


//struct CompareButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompareButtonView()
//    }
//}
