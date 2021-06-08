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
        
        var perfsArray = [String]()
        var eventsArray = [AthleticsEvent]()

        if let jsonData1 = self.wrappedPerformancesArray.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                perfsArray = try decoder.decode([String].self, from: jsonData1)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let jsonData2 = self.wrappedPerformanceEventsArray.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            do {
                eventsArray = try decoder.decode([AthleticsEvent].self, from: jsonData2)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        var perfString = ""
        for (index, element) in perfsArray.enumerated() {
            var currentPerfString = String(element)
            let elementDoubleValue = element.doubleValue
            if eventsArray[index].sType==AthleticsEvent.typeRunLong {
                currentPerfString="\(getMinutesFromSecondsTotal(elementDoubleValue))\(getSecondsFromSecondsTotal(elementDoubleValue))\(getDecimalsFromSecondsTotal(elementDoubleValue))"
            }
            perfString.append("\(currentPerfString) ")
        }
        return perfString.trimSpace()
        
        
    }
    
    func getMinutesFromSecondsTotal(_ seconds: Double) -> String {
        if floor(seconds/60)>0 {
            return "\(Int(floor(seconds/60))):"
        }
        return ""
    }
    
    func getSecondsFromSecondsTotal(_ seconds: Double) -> String {
        let spareSecs = Int(floor(seconds - ((floor(seconds/60))*60)))
        var string = "\(spareSecs)"
        if string.count<=1 {
            string = "0\(string)"
        }
        return string
    }
    
    func getDecimalsFromSecondsTotal(_ seconds: Double) -> String {
        var string = ""
        let spareSecs = seconds - ((floor(seconds/60))*60)
        let decimals = String(Int(100 * (spareSecs-floor(spareSecs)))) //number between 0 and 99
        switch decimals.count {
        case 1:
            string = ".0\(decimals)"
        case 2:
            string = ".\(decimals)"
        default:
            return string
        }
        
        return string
    }
    
    


}

extension UserSavedPerformance : Identifiable {

}
