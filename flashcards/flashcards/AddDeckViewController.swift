//
//  AddDeckViewController.swift
//  flashcards
//
//  Created by Simone De Luca on 13/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class AddDeckViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var addDeckTextField: UITextField!
    
    var deck: Deck!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if(deck != nil)
        {
            addDeckTextField.text = deck.name
            self.title = "Rename Deck"
        }
    }
    
    // MARK: Actions
    @IBAction func cancelAddDeck(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil )
    }
    
    @IBAction func addDeck(_ sender: UIBarButtonItem) {
        
        if let textField = addDeckTextField.text, !textField.isEmpty
        {
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = AppDelegate.persistentContainer.viewContext
            
            if(deck == nil)
            {
                // Create new deck
                deck = Deck(context: context)
            }
            // Set deck name
            deck.name = textField
            
            // Save to CoreData
            AppDelegate.saveContext()
            self.dismiss(animated: true, completion: nil )
            
        } else {
            // Show alert if textfield is empty
            let alert = UIAlertController(title: "Enter a name", message: "You must enter a name for your deck", preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(dismissAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
