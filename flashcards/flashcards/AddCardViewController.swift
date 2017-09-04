//
//  AddCardViewController.swift
//  flashcards
//
//  Created by Simone De Luca on 16/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var cardFrontTextField: UITextField!
    @IBOutlet weak var cardBackTextField: UITextField!
    @IBOutlet weak var saveCardButton: UIBarButtonItem!
    
    var deck: Deck!
    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // If card data is passed in populate the textfields with it
        if(card != nil)
        {
            cardFrontTextField.text = card.front
            cardBackTextField.text = card.back
            self.title = "Edit Card"
        }
    }
    
    // MARK: Actions
    
    // Cancel modal
    @IBAction func cancelModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil )
    }
    
    // Save card
    @IBAction func saveCard(_ sender: UIBarButtonItem) {
        if !((cardFrontTextField.text?.isEmpty)!) && !(cardBackTextField.text?.isEmpty)!
        {
            // Set up context
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = AppDelegate.persistentContainer.viewContext
            
            // If card data is passed in then only edit
            // its front and back without creating a new card
            if(card != nil)
            {
                card.front = cardFrontTextField.text
                card.back = cardBackTextField.text
            }
            else
            {
                // Create new card in Core Data
                let card = Card(context: context)
                
                // Get today's timeInterval
                let date = NSDate().timeIntervalSince1970
                
                // Initialise new card
                card.front = cardFrontTextField.text
                card.back = cardBackTextField.text
                card.nextShown = date
                card.updatedDate = date
                card.easinessFactor = 2.5
                card.repetition = 0.0
                card.interval = 0.0
                
                // Add card to deck
                card.deck = deck
            }
            // Save to CoreData
            AppDelegate.saveContext()
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            // Show alert if textfield is empty
            let alert = UIAlertController(title: "Enter the card details", message: "You must enter both front and back text for your card", preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(dismissAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
