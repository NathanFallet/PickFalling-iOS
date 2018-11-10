//
//  LoseViewController.swift
//  PickFalling
//
//  Created by Nathan FALLET on 06/03/2018.
//

import UIKit
import GameKit

class LoseViewController: UIViewController {
    
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var highest: UILabel!
    var mode: Mode?
    var points: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = NSLocalizedString("score_lose", value:"Score: %d", comment:"Current score in lose")
        score.text = String.localizedStringWithFormat(format, points!)
        
        var highest_mode = 0
        
        let datas = Foundation.UserDefaults.standard
        if datas.value(forKey: "highest_\(mode?.name ?? "CLASSIC")") != nil {
            highest_mode = datas.value(forKey: "highest_\(mode?.name ?? "CLASSIC")") as! Int
        }
        
        let format_high = NSLocalizedString("highest_lose", value:"Highest score: %d", comment:"Highest score in lose")
        highest.text = String.localizedStringWithFormat(format_high, highest_mode)
        
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.first_game", completion: Double(100))
        
        let highest_score = datas.value(forKey: "highest") as! Int
        
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.get_250_points_at_once", completion: Double(highest_score*100/250))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.get_500_points_at_once", completion: Double(highest_score*100/500))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.get_750_points_at_once", completion: Double(highest_score*100/750))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.get_1000_points_at_once", completion: Double(highest_score*100/1000))
        
        let total = datas.value(forKey: "total") as! Int
        var unlock = 0
        if total >= 250 {
            unlock += 2
        }
        if total >= 500 {
            unlock += 2
        }
        if total >= 1000 {
            unlock += 2
        }
        if total >= 2500 {
            unlock += 2
        }
        if total >= 5000 {
            unlock += 2
        }
        if total >= 10000 {
            unlock += 1
        }
        if total >= 15000 {
            unlock += 1
        }
        if total >= 20000 {
            unlock += 1
        }
        
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.unlock_1_level", completion: Double(unlock*100/1))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.unlock_5_levels", completion: Double(unlock*100/5))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.unlock_10_levels", completion: Double(unlock*100/10))
        updateAchievement(id: "fr.zabricraft.iOSPickFalling.unlock_all_levels", completion: Double(unlock*100/13))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameViewController = segue.destination as? GameViewController else {
            return
        }
        
        gameViewController.mode = mode
    }
    
    func updateAchievement(id: String, completion: Double) {
        let achievement = GKAchievement(identifier: id)
        if !achievement.isCompleted {
            achievement.percentComplete = min(max(completion, achievement.percentComplete), Double(100))
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement], withCompletionHandler: nil)
        }
    }

}
