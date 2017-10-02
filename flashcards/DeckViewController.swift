//
//  DeckViewController.swift
//  flashcards
//
//  Created by Simone De Luca on 15/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var showCardBack: UIButton!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var cardStack: UIStackView!
    @IBOutlet weak var nothingToSeeLabel: UILabel!
    
    var deck: Deck!
    var cardsSet: Set<Card> = []
    var cardsToShowArray: [Card] = []
    var tomorrowTimestamp: Double = 0.0
    var calendar: Calendar = Calendar.current
    var appUsage: AppUsage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsageStats()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.title = deck?.name
        
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: Date())
        tomorrowTimestamp = calendar.startOfDay(for: tomorrowDate!).timeIntervalSince1970
        
        sortDeck()
        showNextCard()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCard" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let addCardViewController = destinationNavigationController.topViewController as! AddCardViewController
            addCardViewController.deck = deck
        }
        if segue.identifier == "toEditCard" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let addCardViewController = destinationNavigationController.topViewController as! AddCardViewController
            addCardViewController.deck = deck
            addCardViewController.card = cardsToShowArray.first!
        }
        if segue.identifier == "toAddDeck" {
            
            let destinationNavigationController = segue.destination as! UINavigationController
            let addDeckViewController = destinationNavigationController.topViewController as! AddDeckViewController
            addDeckViewController.deck = deck
        }
    }
    
    // MARK: Actions
    @IBAction func showEditActionSheet(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: "Edit Deck", preferredStyle: .actionSheet)
        
        let renameDeckAction = UIAlertAction(title: "Rename Deck", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "toAddDeck", sender: UIAlertAction.self)
        })
        
        let addCardAction = UIAlertAction(title: "Add Card", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "toAddCard", sender: UIAlertAction.self)
        })
        
        
        if(cardsToShowArray.count > 0) {
            let editCardAction = UIAlertAction(title: "Edit Card", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toEditCard", sender: UIAlertAction.self)
            })
            
            let deleteCardAction = UIAlertAction(title: "Delete Card", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete the deck? All cards and progress will be lost", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    
                    // Delete card and save
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    context.delete(self.cardsToShowArray.first!)
                    AppDelegate.saveContext()
                    self.sortDeck()
                    self.showNextCard()
                })
                alertController.addAction(delete)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    return Void()
                })
                
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)

            })
            
            optionMenu.addAction(deleteCardAction)
            
            optionMenu.addAction(editCardAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(renameDeckAction)
        optionMenu.addAction(addCardAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    @IBAction func showCardBack(_ sender: Any) {
        backLabel.isHidden = false
        buttonStack.isHidden = false
    }
    
    @IBAction func stackButtonTapped(_ sender: Any) {
        let buttonTapped = sender as AnyObject

        updateCard(tag: buttonTapped.tag)
        sortDeck()
        showNextCard()
    }
    
    func sortDeck() -> Void {
        let datePredicate = NSPredicate(format: "nextShown < %f", tomorrowTimestamp)
        let filteredDeck = deck.cards?.filtered(using: datePredicate) as NSSet?
        
        cardsSet = filteredDeck! as! Set<Card>
        
        cardsToShowArray = cardsSet.sorted { $0.updatedDate < $1.updatedDate }
    }
    
    // This function implements the SuperMemo 2 Algorithm. Source: https://www.supermemo.com/english/ol/sm2.htm
    func updateCard(tag: Int?) -> Void {
        let now = Date().timeIntervalSince1970
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentCard = cardsToShowArray.first!
        let currentEasinessFactor = currentCard.easinessFactor
        var newEasinessFactor: Double = 0.0
        let cardScore = Double(tag!)
        currentCard.updatedDate = now
        
        if (cardScore < 3.0) {
            currentCard.repetition = 0
            currentCard.interval = 0
            appUsage.wrongCount += 1
        } else {
            let q = (5.0 - cardScore)
            newEasinessFactor = currentEasinessFactor + (0.1 - (q) * (0.08 + (q) * 0.02))
            
            if (currentEasinessFactor < 1.3) {
                currentCard.easinessFactor = 1.3
            } else {
                currentCard.easinessFactor = newEasinessFactor
            }
            currentCard.repetition = currentCard.repetition + 1.0;
            switch (currentCard.repetition) {
                case 1.0:
                    currentCard.interval = 1.0
                    break
                case 2.0:
                    currentCard.interval = 6.0
                    break
                default:
                    currentCard.interval = (currentCard.repetition - 1.0) * currentCard.easinessFactor
                    break
            }
            // Update correctCount in App Usage
            appUsage.correctCount += 1
        }
        appUsage.totalReviews += 1
        // Update nextShown in card Entity
        let nextShownDate = calendar.date(byAdding: .day, value: Int(currentCard.interval), to: Date())!
        currentCard.nextShown = nextShownDate.timeIntervalSince1970
        AppDelegate.saveContext()
    }
    
    func showNextCard() -> Void {
        
        if(cardsToShowArray.count > 0) {
            cardStack.isHidden = false
            showCardBack.isHidden = false
            nothingToSeeLabel.isHidden = true
            buttonStack.isHidden = true
            backLabel.isHidden = true
            frontLabel.text = cardsToShowArray.first?.front
            backLabel.text = cardsToShowArray.first?.back
        }
        else {
            showCardBack.isHidden = true
            cardStack.isHidden = true
            buttonStack.isHidden = true
            nothingToSeeLabel.isHidden = false
            
            if((deck.cards?.count)! > 0) {
                nothingToSeeLabel.text = "Congratulations, you have finished this deck for now! Check back tomorrow."
            } else {
                nothingToSeeLabel.text = "You haven't added any cards to this deck yet. Click the edit button and start adding your cards!"
            }
        }
    }
    
    func fetchUsageStats() -> Void {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            appUsage = try context.fetch(AppUsage.fetchRequest()).first
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "There was an error fetching your data, try restarting the application.", preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(dismissAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
