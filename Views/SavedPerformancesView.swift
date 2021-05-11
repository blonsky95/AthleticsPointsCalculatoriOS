//
//  SavedPerformancesView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/4/21.
//

import SwiftUI

struct SavedPerformancesView: View {
    
    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper

    @Environment(\.managedObjectContext) var moc
    
    @State private var showingSheet = false

    @FetchRequest(entity: UserSavedPerformance.entity(), sortDescriptors: []) var userSavedPerformances: FetchedResults<UserSavedPerformance>
    
    @State private var comparePerformancesArray=[AthleticsPointsEventPerformance]()
    @State private var comparePerf1 = AthleticsPointsEventPerformance()
    @State private var comparePerf2 = AthleticsPointsEventPerformance()
    
    @State var selection =  Set<UUID>(){
//        This will be called before actually setting/modifying the variable
//        So, you have access to newValue which has the new value for "selection"
        willSet {
//            let newCount = newValue.count
        }

        //This will be called when user touches "Cancel" button, as it resets selection
        didSet {
//           I use this to update the text, this gets called when selection is reset
            updateButtonText(count: 0) //0 is size of selection when reset
        }
    }
    
//    @State var selectionStack = Stack() //This will be used to keep selection in order that they are pressed
    @State var selectedItemsArray=[UUID]()
    
    @State var editMode: EditMode = .inactive {
        didSet {
            shouldCancelHide=(editMode==EditMode.inactive)
        }
    }

    @State var compareButtonText = "Compare"
    @State var shouldCancelHide = true

    var body: some View {
        
        NavigationView{
            
            VStack{
                List(selection: $selection) {
                    ForEach(userSavedPerformances) { performance in
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: userSavedPerformanceToAthlPointsEvPerf(performance), userSavedPerformance: performance, isASavedPerformance: true).environmentObject(eventsDataObtainerAndHelper)) {
                            HStack{
                                VStack{
                                    Text(performance.performanceTitle ?? "Unknown")
                                    Text(performance.performanceEventName ?? "Unknown")
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
                    withAnimation{
                        updateButtonText(count: newValue.count)
                        print("selection: \(newValue)")
                    }
                }
                
                HStack {
                    
                    Button(action: {
                        withAnimation{
                            compareButtonPressed()
                        }
                    }) {
                        Text(compareButtonText)
                            .padding()
                            .foregroundColor(.white)
                    }
                    .background(Capsule()
                                    .fill(Color.blue)
                                    .frame(minWidth: 100, minHeight: 50))
                    .padding()
                    
                    if !shouldCancelHide {
                        Button(action: {
                            withAnimation{
                                toggleEditMode()
                            }
                        }) {
                            Text("Cancel")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .background(Capsule()
                                        .fill(Color.red))
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    ComparePerformancesView(athleticPointsEventPerformance1: $comparePerf1, athleticPointsEventPerformance2: $comparePerf2)
                }
            }
            .navigationTitle("Saved Performances")
            .environment(\.editMode, self.$editMode) //#2
        }
 }
    
    func updateOrderArray(selectionArray: Set<UUID>) {
//        print  ("TEST TIME START - \(selectedItemsArray)")
        if selectionArray.count>selectedItemsArray.count {
            print  ("TEST TIME - will append")

            for uuid in selectionArray {
                if !selectedItemsArray.contains(uuid) {
                    selectedItemsArray.append(uuid)
                    break
                }
            }
        }
        if selectionArray.count<selectedItemsArray.count {
            print  ("TEST TIME - will remove")

            for uuid in selectedItemsArray {
                if !selectionArray.contains(uuid) {
                    selectedItemsArray.remove(at: selectedItemsArray.firstIndex(of: uuid)!)
                    break
                }
            }
        }
        print  ("TEST TIME END - \(selectedItemsArray)")

    }
    
    func toggleEditMode() {
        self.editMode.toggle()
        self.selection = Set<UUID>()
    }
    
    func compareButtonPressed() {
        if editMode==EditMode.inactive {
            toggleEditMode()
        } else {
            if selection.count==2 {
                
                //reset compare array
                comparePerformancesArray=[AthleticsPointsEventPerformance]()

                for uuid in selectedItemsArray {
                        if let performance = userSavedPerformances.first(where: {$0.id == uuid}) {
                            comparePerformancesArray.append(AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: performance))
                        }
                }

                comparePerf1=comparePerformancesArray[0]
                comparePerf2=comparePerformancesArray[1]

                if (comparePerf1.sEventsArray.count==comparePerf2.sEventsArray.count) {
                    showingSheet.toggle()
                } else {
                    //todo show toast
                    print ("Event arrays are not the same size - cant compare")
                }
                
            } else {
                print("Nothing will happen")
            }
        }
    }
    func updateButtonText(count: Int) {
        if editMode==EditMode.active {
            switch count {
            case 0:
                compareButtonText="Choose first performance"
            case 1:
                compareButtonText="Choose second performance"
            case 2:
                compareButtonText="Compare!"
            default:
                compareButtonText="Too many!"
            }
        } else {
            compareButtonText="Compare"
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
                let savedPerformance = userSavedPerformances[index]
                moc.delete(savedPerformance)
            }
        do {
            try moc.save()
        } catch {
            print("Error deleting items")
        }
    }
    
    func userSavedPerformanceToAthlPointsEvPerf(_ userSavedPerformance : UserSavedPerformance) -> AthleticsPointsEventPerformance {
        return AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: userSavedPerformance)
    }}

struct SavedPerformancesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPerformancesView()
    }
}

class myTrackerArray {
    
}
