//
//  SavedPerformancesView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/4/21.
//

import SwiftUI

struct SavedPerformancesView: View {
    

    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var alertText = "Hey"
        
    @State private var comparePerf1 = AthleticsPointsEventPerformance()
    @State private var comparePerf2 = AthleticsPointsEventPerformance()

    @State var selectedItemsArray=[UUID]()
    @State var editModeSelectionSetForList=Set<UUID>()

    @State var searchText = ""
    @State var compareButtonText = "Compare"
    
    @State var shouldCancelButtonHide = true
    
    @State var editMode: EditMode = .inactive {
        willSet {
            selectedItemsArray = [UUID]()
            editModeSelectionSetForList = Set<UUID>()
        }
        didSet {
            updateCompareButtonText(count: selectedItemsArray.count)
            shouldCancelButtonHide=(editMode==EditMode.inactive)
        }
    }

    var body: some View {
        
        NavigationView{
            
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                    .onChange(of: searchText) { newValue in
                        mainViewModel.updateQuery(searchText: newValue)
                }

                FilteredPerformances(performancesToDisplay: mainViewModel.userSavedPerfsArray, selectedItemsArray: $selectedItemsArray, selection: $editModeSelectionSetForList)
                    .environmentObject(mainViewModel)
                    .onChange(of: selectedItemsArray) { newValue in
                        withAnimation{
                            updateCompareButtonText(count: newValue.count)
                        }
                    }
                
                HStack {
                    
                    CompareButtonView(action: {
                        withAnimation{
                            compareButtonPressed()
                        }
                    }, buttonText: $compareButtonText)
                    
                    if !shouldCancelButtonHide {
                        CancelButtonView(action: {
                            withAnimation{
                                self.editMode.toggle()
                            }
                        })
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    ComparePerformancesView(athleticPointsEventPerformance1: $comparePerf1, athleticPointsEventPerformance2: $comparePerf2)
                }
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Ups!"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
                        }
                .onAppear{
//                    print ("check this:\(mainViewModel.container.name)")
                }
            }
            .navigationTitle("Saved Performances")
            .environment(\.editMode, self.$editMode) //#2
        }
        .navigationViewStyle(StackNavigationViewStyle())
 }

    func compareButtonPressed() {
        if editMode==EditMode.inactive {
            self.editMode.toggle()
        } else {
            if selectedItemsArray.count==2 {
                proceedWithComparing()
            } else {
                alertText = compareButtonText
                showingAlert = true
            }
        }
    }
    
    func proceedWithComparing() {
        if let performance = mainViewModel.getAthleticsPerformanceFromSelection(selectedUUID: selectedItemsArray[0]) {
            comparePerf1 = performance
        }
        if let performance = mainViewModel.getAthleticsPerformanceFromSelection(selectedUUID: selectedItemsArray[1]) {
            comparePerf2 = performance
        }

        if (comparePerf1.sEventsArray.count==comparePerf2.sEventsArray.count) {
            showingSheet.toggle()
        } else {
            alertText = "you can only compare same number of events performances. E.g. You can´t compare a decathlon with 10 performances against a 100m"
            showingAlert = true
        }
    }
    
    func updateCompareButtonText(count: Int) {
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

//    struct SavedPerformancesView_Previews: PreviewProvider {
//        static var previews: some View {
//            SavedPerformancesView()
//        }
//    }
}
