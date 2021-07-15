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
    @NSManaged public var windReadings: String?
    @NSManaged public var windPoints: String?
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
    
    public var wrappedEventGroup: EventGroup {
        
        var rEventGroup = EventGroup()
        if let jsonData1 = eventGroup?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                rEventGroup = try decoder.decode(EventGroup.self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return rEventGroup
    }
    
    public var wrappedSelectedAthleticsEvents: [AthleticsEvent] {
        var array = [AthleticsEvent]()
        if let jsonData1 = selectedAthleticsEvents?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([AthleticsEvent].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
    }
    
    public var wrappedEventPerformances: [String] {
        var array = [String]()
        if let jsonData1 = eventPerformances?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
        
    }
    
    public var wrappedEventPerformancePoints: [String] {
        var array = [String]()
        if let jsonData1 = eventPerformancePoints?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
    }
    
    public var wrappedEventPlacementPoints: [String] {
        var array = [String]()
        if let jsonData1 = eventPlacementPoints?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
        
    }
    
    public var wrappedWindPoints: [String] {
        var array = [String]()
        if let jsonData1 = windPoints?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
        
    }
    
    public var wrappedWindReadings: [String] {
        var array = [String]()
        if let jsonData1 = windReadings?.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                array = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
        
    }
    
    public var wrappedRankingScore: String {
        rankingScore ?? "-100"
    }
}

extension WAPointsPerformance : Identifiable {

}
