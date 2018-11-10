//
//  MenuTableViewController.swift
//  PickFalling
//
//  Created by Nathan FALLET on 05/03/2018.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var modes = [Mode]()
    
    private func loadModes() {
        let classic = Mode(name: "CLASSIC", score: 0, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let unicorn = Mode(name: "UNICORN", score: 250, player: UIImage(named: "unicorn")!, object: UIImage(named: "heart")!, color: "#FEBFD2")
        let fish = Mode(name: "FISH", score: 500, player: UIImage(named: "fish")!, object: UIImage(named: "bubble")!, color: "#26C4EC")
        let cat = Mode(name: "CAT", score: 1000, player: UIImage(named: "cat")!, object: UIImage(named: "fish")!, color: "#FEBFD2")
        let bird = Mode(name: "BIRD", score: 2500, player: UIImage(named: "bird")!, object: UIImage(named: "maggot")!, color: "#26C4EC")
        let shell = Mode(name: "SHELL", score: 5000, player: UIImage(named: "crab")!, object: UIImage(named: "shell")!)
        let quick = Mode(name: "QUICK", score: 250, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let mirror = Mode(name: "MIRROR", score: 500, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let zigzag = Mode(name: "ZIGZAG", score: 1000, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let random = Mode(name: "RANDOM", score: 2500, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let bonus = Mode(name: "BONUS", score: 5000, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let everything = Mode(name: "EVERYTHING", score: 10000, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let control = Mode(name: "CONTROL", score: 15000, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        let random2 = Mode(name: "RANDOM2", score: 20000, player: UIImage(named: "player")!, object: UIImage(named: "spinash")!)
        
        modes += [classic, unicorn, fish, cat, bird, shell, quick, mirror, zigzag, random, bonus, everything, control, random2]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadModes()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mode = modes[indexPath.row]
        
        var total = 0
        var highest_mode = 0
        
        let datas = Foundation.UserDefaults.standard
        if datas.value(forKey: "total") != nil {
            total = datas.value(forKey: "total") as! Int
        }
        if datas.value(forKey: "highest_\(mode.name)") != nil {
            highest_mode = datas.value(forKey: "highest_\(mode.name)") as! Int
        }
        
        if total >= mode.score {
            let cellIdentifier = "MenuTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MenuTableViewCell else {
                fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
            }
            let format = NSLocalizedString("menu_button_unlocked", value:"%@\nHighest score: %d", comment:"Button for an unlocked mode")
            cell.button.setTitle(String.localizedStringWithFormat(format, mode.name, highest_mode), for: .normal)
            return cell
        } else {
            let cellIdentifier = "MenuTableViewCellDisabled"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MenuTableViewCell else {
                fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
            }
            let format = NSLocalizedString("menu_button_locked", value:"%@\nUnlock: %d", comment:"Button for a locked mode")
            cell.button.setTitle(String.localizedStringWithFormat(format, mode.name, mode.score), for: .normal)
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameViewController = segue.destination as? GameViewController else {
            return
        }
        
        guard let selectedModeButton = sender as? UIButton else {
            fatalError("Unexpected sender: \(sender ?? "")")
        }
        
        guard let selectedModeCell = selectedModeButton.superview?.superview as? MenuTableViewCell else {
            fatalError("Unexpected sender: \(sender ?? "")")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedModeCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedMode = modes[indexPath.row]
        gameViewController.mode = selectedMode
    }

}
