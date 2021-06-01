//
//  FilteredPerformances.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/5/21.
//

import SwiftUI

struct FilteredPerformances: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel

    @Binding var selectedUUIDsArray:[UUID] //Contains the UUIDs in the right first, second... order
    @Binding var listUUIDSelectionSet:Set<UUID> //Keeps track of selected items in SwiftUI List when in EditMode. No order
    
    var performancesToDisplay:[UserSavedPerformance]
    
    init(performancesToDisplay:[UserSavedPerformance], selectedItemsArray:Binding<[UUID]>, selection:Binding<Set<UUID>>) {
        self.performancesToDisplay = performancesToDisplay
        self._selectedUUIDsArray = selectedItemsArray
        self._listUUIDSelectionSet = selection
    }

    var body: some View {
        List(selection: $listUUIDSelectionSet) {
            ForEach(performancesToDisplay) { performance in
                NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: performance), userSavedPerformance: performance)) {
                    HStack{
                        VStack(alignment: .leading){
                            Text(performance.performanceTitle ?? "Unknown")
                            Text(performance.performanceEventName ?? "Unknown")
                            Text(performance.getReadablePerformances())
                                .foregroundColor(Color.gray)
                                .font(.system(size: 14))
                                .padding(.trailing)
                            
                        }
                        Spacer()
                        Text(String(performance.performanceTotalPoints))
                    }
                    
                }
            }
            .onDelete(perform: mainViewModel.deletePerformance)
        }
        .onChange(of: listUUIDSelectionSet) { newValue in
            updateOrderArray(selectionArray: newValue)
        }
        
        
    }
    
    func updateOrderArray(selectionArray: Set<UUID>) {
        if selectionArray.count>selectedUUIDsArray.count {
            for uuid in selectionArray {
                if !selectedUUIDsArray.contains(uuid) {
                    selectedUUIDsArray.append(uuid)
                    break
                }
            }
        }
        if selectionArray.count<selectedUUIDsArray.count {
            for uuid in selectedUUIDsArray {
                if !selectionArray.contains(uuid) {
                    selectedUUIDsArray.remove(at: selectedUUIDsArray.firstIndex(of: uuid)!)
                    break
                }
            }
        }
    }
}

//struct FilteredPerformances_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredPerformances()
//    }
//}
