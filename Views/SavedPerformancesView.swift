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

    @FetchRequest(entity: UserSavedPerformance.entity(), sortDescriptors: []) var userSavedPerformances: FetchedResults<UserSavedPerformance>
    
    var body: some View {
        
        NavigationView{
            List {
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
            .toolbar {
                EditButton()
            }
            .navigationTitle("Saved Performances")
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
