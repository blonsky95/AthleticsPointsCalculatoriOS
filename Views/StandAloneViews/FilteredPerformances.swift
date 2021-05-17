//
//  FilteredPerformances.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/5/21.
//

import SwiftUI

struct FilteredPerformances: View {
    
    var fetchRequest: FetchRequest<UserSavedPerformance>
    @Binding var selectedItemsArray:[UUID] 
//        willSet {
//            print ("will set called for selected items array AAA")
//            if newValue.count==0 {
//                //Reset selection
//                selection = Set<UUID>()
//            }
//
//        }
    

    @Binding var selection:Set<UUID>
    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    @Environment(\.managedObjectContext) var moc
    
    init(filter: String, selectedItemsArray:Binding<[UUID]>, selectionUUIDArray:Binding<Set<UUID>>) {
        fetchRequest = FetchRequest<UserSavedPerformance>(entity: UserSavedPerformance.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
        ])
//        , predicate: NSPredicate(format: "performanceTitle CONTAINS[c] %@", filter)
        
        self._selectedItemsArray=selectedItemsArray
        self._selection=selectionUUIDArray

    }
    


    var body: some View {
        
//        List(fetchRequest.wrappedValue, id: \.self) { singer in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
        
        List(selection: $selection) {
            ForEach(fetchRequest.wrappedValue) { performance in
                NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: performance), userSavedPerformance: performance, isASavedPerformance: true).environmentObject(eventsDataObtainerAndHelper)) {
                    HStack{
                        VStack(alignment: .leading){
                            Text(performance.performanceTitle ?? "Unknown")
                            Text(performance.performanceEventName ?? "Unknown")
                            Text(String(performance.getEventsArraySizeCount()))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 16))
                            
                        }
                        Spacer()
                        Text(String(performance.performanceTotalPoints))
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .onChange(of: selection) { newValue in
            
            updateOrderArray(selectionArray: newValue)
//            withAnimation{
//                updateButtonText(count: newValue.count)
//                print("selection: \(newValue)")
//            }
        }
        
        
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let savedPerformance = fetchRequest.wrappedValue[index]
                moc.delete(savedPerformance)
            }
        do {
            try moc.save()
        } catch {
            print("Error deleting items")
        }
    }
    
    func updateOrderArray(selectionArray: Set<UUID>) {
        if selectionArray.count>selectedItemsArray.count {
            for uuid in selectionArray {
                if !selectedItemsArray.contains(uuid) {
                    selectedItemsArray.append(uuid)
                    break
                }
            }
        }
        if selectionArray.count<selectedItemsArray.count {
            for uuid in selectedItemsArray {
                if !selectionArray.contains(uuid) {
                    selectedItemsArray.remove(at: selectedItemsArray.firstIndex(of: uuid)!)
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
