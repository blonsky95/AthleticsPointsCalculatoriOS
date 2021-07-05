//
//  WAPointsPerformance+CoreDataProperties.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 5/7/21.
//
//

import Foundation
import CoreData


extension WAPointsPerformance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WAPointsPerformance> {
        return NSFetchRequest<WAPointsPerformance>(entityName: "WAPointsPerformance")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var date: Date?
    @NSManaged public var performanceTitle: String?
    @NSManaged public var eventGroup: String?
    @NSManaged public var selectedAthleticsEvents: String?
    @NSManaged public var eventPerformances: String?
    @NSManaged public var eventPerformancePoints: String?
    @NSManaged public var eventPlacementPoints: String?
    @NSManaged public var rankingScore: String?
    
    public var wrappedPerformanceID: String {
        id.uuidString
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
    
    public var wrappedPerformanceTitle: String {
        performanceTitle ?? "Unknown Title"
    }
    
    public var wrappedEventGroup: String {
        eventGroup ?? "Unknown Event Group"
    }
    
    public var wrappedSelectedAthleticsEvents: String {
        selectedAthleticsEvents ?? "Unknown selected ath events"
    }
    
    public var wrappedEventPerformances: String {
        eventPerformances ?? "Unknown Event perfs"
    }
    
    public var wrappedEventPerformancePoints: String {
        eventPerformancePoints ?? "Unknown Event perfs points"
    }
    
    public var wrappedEventPlacementPoints: String {
        eventPlacementPoints ?? "Unknown Event placement points"
    }
    
    public var wrappedRankingScore: String {
        rankingScore ?? "-100"
    }
}

extension WAPointsPerformance : Identifiable {

}
