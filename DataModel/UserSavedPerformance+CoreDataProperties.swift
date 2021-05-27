//
//  UserSavedPerformance+CoreDataProperties.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/4/21.
//
//

import Foundation
import CoreData


extension UserSavedPerformance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSavedPerformance> {
        return NSFetchRequest<UserSavedPerformance>(entityName: "UserSavedPerformance")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date?
    @NSManaged public var performanceEventName: String?
    @NSManaged public var performanceEventsArray: String?
    @NSManaged public var performanceNumberDays: Int16
    @NSManaged public var performancesArray: String?
    @NSManaged public var performanceTitle: String?
    @NSManaged public var performanceTotalPoints: Int16
    
    
    
    public var wrappedPerformanceID: String {
        id.uuidString
//        id?.uuidString ?? "Unknown id"

    }
    
    public var wrappedDate: Date {
        if date == nil {
            var components = DateComponents()
            components.year = 1995
            components.month = 3
            components.day = 4
            components.hour = 7
            date = Calendar.current.date(from: components)
        }
        return date!
    }
    
    public var wrappedPerformanceEventName: String {
        performanceEventName ?? "Unknown Event Name"
    }
    
    public var wrappedPerformancesArray: String {
        performancesArray ?? "Unknown perf array"
    }
    
    public var wrappedPerformanceTitle: String {
        performanceTitle ?? "Unknown Title"
    }
    
    public var wrappedPerformanceEventsArray: String {
        performanceEventsArray ?? "Unknown perf events array"
    }
    
    public func getEventsArraySizeCount() -> Int {
        
        var athleticsEventsArray = [AthleticsEvent]()

        if let jsonData1 = self.wrappedPerformanceEventsArray.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                athleticsEventsArray = try decoder.decode([AthleticsEvent].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return athleticsEventsArray.count
    }
    
    public func getReadablePerformances() -> String {
        
        var perfsArray = [Double]()

        if let jsonData1 = self.wrappedPerformancesArray.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                perfsArray = try decoder.decode([Double].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        var perfString = ""
        for perf in perfsArray {
            perfString.append("\(String(perf)) ")
        }
        return perfString.trimSpace()
    }
    
    


}

extension UserSavedPerformance : Identifiable {

}
