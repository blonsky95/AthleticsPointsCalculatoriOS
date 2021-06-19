//
//  CustomEventGroupPicker.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/6/21.
//

import SwiftUI

struct CustomEventGroupPicker: View {
    @Binding var selectedEventGroupIndex:Int
    let arrayOfEventGroups:[EventGroup]
    
    var body: some View {
        Picker("Main event", selection: $selectedEventGroupIndex) {
            ForEach(0..<arrayOfEventGroups.count) {
                Text(arrayOfEventGroups[$0].sName)
            }
        }//.pickerStyle(WheelPickerStyle())
    }
}

//struct CustomEventGroupPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomEventGroupPicker()
//    }
//}
