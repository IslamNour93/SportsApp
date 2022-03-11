//
//  LeaguesCoreData+CoreDataProperties.swift
//  
//
//  Created by Islam Noureldeen on 02/03/2022.
//
//

import Foundation
import CoreData


extension LeaguesCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeaguesCoreData> {
        return NSFetchRequest<LeaguesCoreData>(entityName: "LeaguesCoreData")
    }

    @NSManaged public var leagueName: String?
    @NSManaged public var leagueBadge: String?
    @NSManaged public var leagueYoutube: String?
    @NSManaged public var btnPressed: Bool?
    @NSManaged public var leagueId: String?
}
