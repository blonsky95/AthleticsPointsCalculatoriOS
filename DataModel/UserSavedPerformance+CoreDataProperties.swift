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

    @NSManaged public var id: UUID?
    @NSManaged public var performanceEventName: String?
    @NSManaged public var performanceEventsArray: String?
    @NSManaged public var performanceNumberDays: Int16
    @NSManaged public var performancesArray: String?
    @NSManaged public var performanceTitle: String?
    @NSManaged public var performanceTotalPoints: Int16
    
    
    
    public var wrappedPerformanceID: String {
//        id.uuidString
        id?.uuidString ?? "Unknown id"

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


}

extension UserSavedPerformance : Identifiable {

}
