//
//  AppStatsViewController.swift
//  flashcards
//
//  Created by Simone De Luca on 26/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class AppUsageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var statsTableView: UITableView!
    var appUsage: AppUsage!
    var decks: [Deck] = []
    var usageStats: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTableView.dataSource = self
        statsTableView.delegate = self
        statsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fetchUsageStats()
        generateAppUsageStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usageStats.count
    }
    
    // Populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appUsageCell") as! AppUsageTableViewCell
        let labels = ["Total Decks", "Total Cards", "Total Reviews", "Days Studied", "Hours Studied", "Minutes Studied", "Correct Answers", "Wrong Answers"]
        cell.label.text = labels[indexPath.row]
        cell.value.text = usageStats[indexPath.row]
        return cell
    }
    
    func calculateDecksTotal() -> Int {
        return decks.count
    }
    func calculateCardsTotal() -> Int {
        var total = 0
        for deck in decks {
            if (deck.cards?.count)! > 0 {
                for _ in deck.cards! {
                    total += 1
                }
            }
        }
        return total
    }
    func calculateSecondsMinutesHoursStudied() -> (Int64, Int64, Int64) {
        let secondsUsed = appUsage.secondsStudied
        return (secondsUsed % (86400 * 30) / 86400, secondsUsed / 3600, (secondsUsed % 3600) / 60)
    }
    
    func generateAppUsageStats() -> Void {
        let (days, hours, minutes) = calculateSecondsMinutesHoursStudied()
        print(appUsage.secondsStudied)
        print(minutes)
        
        usageStats.append("\(calculateDecksTotal())")
        usageStats.append("\(calculateCardsTotal())")
        usageStats.append("\(appUsage.totalReviews)")
        usageStats.append("\(days)")
        usageStats.append("\(hours)")
        usageStats.append("\(minutes)")
        usageStats.append("\(appUsage.correctCount)")
        usageStats.append("\(appUsage.wrongCount)")
        
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
