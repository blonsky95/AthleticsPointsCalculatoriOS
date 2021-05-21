//
//  CancelButtonView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 21/5/21.
//

import SwiftUI

struct CancelButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button (action: action) {
            Text("Cancel")
                .padding()
                .foregroundColor(.white)
        }
        .background(Capsule()
                        .fill(Color.red))
    }
}

//struct CancelButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CancelButtonView()
//    }
//}
