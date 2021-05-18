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
    @State private var showingAlert = false
    @State private var alertText = "dude"

    //This fetch request contains all the usp, 
    @FetchRequest(entity: UserSavedPerformance.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
        NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
    ]) var userSavedPerformances: FetchedResults<UserSavedPerformance>
    
    @State var filterPredicate: NSCompoundPredicate? = nil
    
    @State private var comparePerformancesArray=[AthleticsPointsEventPerformance]()
    @State private var comparePerf1 = AthleticsPointsEventPerformance()
    @State private var comparePerf2 = AthleticsPointsEventPerformance()

    @State var selectedItemsArray=[UUID]()

    @State var editMode: EditMode = .inactive {
        didSet {
            shouldCancelHide=(editMode==EditMode.inactive)
        }
    }
    
    @State var searchText = ""

    @State var compareButtonText = "Compare"
    @State var shouldCancelHide = true

    var body: some View {
        
        NavigationView{
            
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                    .onChange(of: searchText) { newValue in
                        if (newValue.isEmpty) {
                            filterPredicate = nil
                        } else {
                            let titleFilter = NSPredicate(format: "performanceTitle CONTAINS[c] %@", newValue)
                            let eventFilter = NSPredicate(format: "performanceEventName CONTAINS[c] %@", newValue)
                            let pointsFilter = NSPredicate(format: "performanceTotalPoints BEGINSWITH %@", newValue)

                            filterPredicate=NSCompoundPredicate(orPredicateWithSubpredicates: [titleFilter, eventFilter, pointsFilter])
                            
                        }
                }

                FilteredPerformances(predicate: filterPredicate, selectedItemsArray: $selectedItemsArray)
                    .environmentObject(eventsDataObtainerAndHelper)
                .onChange(of: selectedItemsArray) { newValue in
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
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Ups!"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
                        }
            }
            .navigationTitle("Saved Performances")
            .environment(\.editMode, self.$editMode) //#2
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
    
    func toggleEditMode() {
        self.editMode.toggle()
        self.selectedItemsArray = [UUID]()
        updateButtonText(count: selectedItemsArray.count)
    }
    
    func compareButtonPressed() {
        if editMode==EditMode.inactive {
            toggleEditMode()
        } else {
            if selectedItemsArray.count==2 {
                
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
                    alertText = "you can only compare same number of events performances. E.g. You can´t compare a decathlon with 10 performances against a 100m"
                    showingAlert = true
                }
                
            } else {
                alertText = compareButtonText
                showingAlert = true
            }
        }
    }
    func updateButtonText(count: Int) {
        print("update button text called: \(count)")
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

    struct SavedPerformancesView_Previews: PreviewProvider {
        static var previews: some View {
            SavedPerformancesView()
        }
    }
}
