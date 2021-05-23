//
//  FilteredPerformances.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/5/21.
//

import SwiftUI


//This class takes a nullable predicate and a binding [UUID], from there, it's in charge of querying
//depending on the predicate, presenting information, its a link to CalculatorView, and it also informs
//of which UUIDs are selected when in editmode.

//This view could actually work receiving the whole FetchedResults, and filtering instead of dynamically filtering the FetchRequest. Loook at ticket around 18 May but it is straight forward.

struct FilteredPerformances: View {

    var fetchRequest: FetchRequest<UserSavedPerformance> //no error because it is initialized in the init block - even if not a param

    @Binding var selectedUUIDsArray:[UUID] //Contains the UUIDs in the right first, second... order
    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    @Environment(\.managedObjectContext) var moc
    
    @Binding var listUUIDSelectionSet:Set<UUID> //Keeps track of selected items in SwiftUI List when in EditMode. No order
    
    init(predicate: NSPredicate?, selectedItemsArray:Binding<[UUID]>, selection:Binding<Set<UUID>>) {
                
        fetchRequest = FetchRequest<UserSavedPerformance>(entity: UserSavedPerformance.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
        ], predicate: predicate)
        
        self._selectedUUIDsArray = selectedItemsArray
        self._listUUIDSelectionSet = selection
    }

    var body: some View {
        List(selection: $listUUIDSelectionSet) {
            ForEach(fetchRequest.wrappedValue) { performance in
                NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: performance), userSavedPerformance: performance).environmentObject(eventsDataObtainerAndHelper)) {
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
        .onChange(of: listUUIDSelectionSet) { newValue in
            updateOrderArray(selectionArray: newValue)
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
