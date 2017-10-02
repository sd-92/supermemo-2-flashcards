//
//  flashcardsTests.swift
//  flashcardsTests
//
//  Created by Simone De Luca on 12/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import XCTest
@testable import flashcards
import CoreData

class flashcardsTests: XCTestCase {

    func testDeckAddition() {
        let managedObjectContext = createManagedObjectContext()
        let deckEntity = NSEntityDescription.entity(forEntityName: "Deck", in: managedObjectContext)
        var fetchedDecks : [Deck] = []
        let deckOne = Deck(entity: deckEntity!, insertInto: managedObjectContext)
    
        deckOne.name = "DeckOne"
        
        do {
            fetchedDecks = try managedObjectContext.fetch(Deck.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        XCTAssert(fetchedDecks.count == 1)
    }
    
    func testDeckDeletion() {
        let managedObjectContext = createManagedObjectContext()
        let deckEntity = NSEntityDescription.entity(forEntityName: "Deck", in: managedObjectContext)
        var decks : [Deck] = []
        
        let deckOne = Deck(entity: deckEntity!, insertInto: managedObjectContext)
        deckOne.name = "DeckOne"
        let deckTwo = Deck(entity: deckEntity!, insertInto: managedObjectContext)
        deckTwo.name = "DeckTwo"
        
        managedObjectContext.delete(deckOne)
        
        do {
            decks = try managedObjectContext.fetch(Deck.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        
        XCTAssert(decks.count == 1)
    }
    
    func testDeckName() {
        let managedObjectContext = createManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: "Deck", in: managedObjectContext)
        let deck = Deck(entity: entity!, insertInto: managedObjectContext)
        deck.name = "testDeck"
        var fetchedDecks: [Deck] = []
        
        do {
            fetchedDecks = try managedObjectContext.fetch(Deck.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        
        XCTAssert(fetchedDecks.first?.name == "testDeck")
    }
    
    func testCardFields() {
        let managedObjectContext = createManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext)
        let card = Card(entity: entity!, insertInto: managedObjectContext)
        var cards: [Card] = []
        card.front = "front"
        card.back = "back"
        
        do {
            cards = try managedObjectContext.fetch(Card.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        
        XCTAssert(cards.first?.front == "front")
        XCTAssert(cards.first?.back == "back")
    }
    
    func testCardDeletion() {
        let managedObjectContext = createManagedObjectContext()
        let cardEntity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext)
        let deckEntity = NSEntityDescription.entity(forEntityName: "Deck", in: managedObjectContext)
        let cardOne = Card(entity: cardEntity!, insertInto: managedObjectContext)
        let cardTwo = Card(entity: cardEntity!, insertInto: managedObjectContext)
        let deck = Deck(entity: deckEntity!, insertInto: managedObjectContext)
        var fetchedDecks: [Deck] = []
        
        cardTwo.deck = deck
        cardOne.deck = deck
        deck.removeFromCards(cardOne)
        
        do {
            fetchedDecks = try managedObjectContext.fetch(Deck.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        
        
        XCTAssert(fetchedDecks.first?.cards?.count == 1)
    }
    
    func testCardAddition() {
        let managedObjectContext = createManagedObjectContext()
        let cardEntity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext)
        let deckEntity = NSEntityDescription.entity(forEntityName: "Deck", in: managedObjectContext)
        let cardOne = Card(entity: cardEntity!, insertInto: managedObjectContext)
        let cardTwo = Card(entity: cardEntity!, insertInto: managedObjectContext)
        let deck = Deck(entity: deckEntity!, insertInto: managedObjectContext)
        var fetchedDecks: [Deck] = []
        
        cardTwo.deck = deck
        cardOne.deck = deck
        
        do {
            fetchedDecks = try managedObjectContext.fetch(Deck.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
        XCTAssert(fetchedDecks.first?.cards?.count == 2)
    }
    
    func createManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Error setting up context")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    
}
