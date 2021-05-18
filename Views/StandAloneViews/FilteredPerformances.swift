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

//The question is, does it need a predicate and a FetchRequest? or would it be better off just receving the
//the whole [UserSavedPerf] and having it filter it like a Collection? so no more CoreData dynamic fetch request?
struct FilteredPerformances: View {
    
    
    var fetchRequest: FetchRequest<UserSavedPerformance> //no error because it is initialized in the init block - even if not a param
    
    //This view could actually work receiving the whole FetchedResults, and filtering instead of dynamically filtering the FetchRequest. The code is commented out but it is straight forward.
    
    //    var fullSetOfPerformances: FetchedResults<UserSavedPerformance>
    //    @Binding var searchhText:String

    @Binding var selectedItemsArray:[UUID]
    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    @Environment(\.managedObjectContext) var moc
    
    @State var selection = Set<UUID>()
    
    init(predicate: NSPredicate?, selectedItemsArray:Binding<[UUID]>) {
        
//        , fullSet: FetchedResults<UserSavedPerformance>, text: Binding<String>
        
        fetchRequest = FetchRequest<UserSavedPerformance>(entity: UserSavedPerformance.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
        ], predicate: predicate)
        
        
        self._selectedItemsArray=selectedItemsArray
        
//        self.fullSetOfPerformances = fullSet
//        self._searchhText = text

    }
    

//    var filteredPerformances:[UserSavedPerformance] {
//            return fullSetOfPerformances.filter { $0.wrappedPerformanceTitle.contains(searchhText) }
//    }

    var body: some View {
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
