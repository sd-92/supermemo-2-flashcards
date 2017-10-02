//
//  Deck+CoreDataProperties.swift
//  flashcards
//
//  Created by Simone De Luca on 17/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck");
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
