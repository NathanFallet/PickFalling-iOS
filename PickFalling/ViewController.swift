//
//  ViewController.swift
//  PickFalling
//
//  Created by Nathan FALLET on 04/03/2018.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var leaderboardsButton: UIButton!
    @IBOutlet weak var achievmentsButton: UIButton!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var total: UILabel!
    var gcEnabled = Bool()
    
    @IBAction func displayLeaderboards(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        present(gcVC, animated: true, completion: nil)
    }
    
    @IBAction func displayAchievments(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .achievements
        present(gcVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var highest = 0
        var total2 = 0
        
        let datas = Foundation.UserDefaults.standard
        if datas.value(forKey: "highest") != nil {
            highest = datas.value(forKey: "highest") as! Int
        }
        if datas.value(forKey: "total") != nil {
            total2 = datas.value(forKey: "total") as! Int
        }
        
        let format_high = NSLocalizedString("highest", value:"Highest score: %d", comment:"Highest score")
        let format_total = NSLocalizedString("total", value:"Total score: %d", comment:"Total score")
        
        high.text = String.localizedStringWithFormat(format_high, highest)
        total.text = String.localizedStringWithFormat(format_total, total2)
        
        authenticateLocalPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                
                GKLeaderboard.loadLeaderboards() { (leaderboards, error) in
                    for leaderboard in leaderboards! {
                        leaderboard.loadScores() { (scores, error) in
                            let id = leaderboard.identifier?.dropFirst(29)
                            if let score = leaderboard.localPlayerScore {
                                let datas = Foundation.UserDefaults.standard
                                var key = "total"
                                switch id {
                                case "total_score":
                                    key = "total"
                                case "highest_score":
                                    key = "highest"
                                default:
                                    key = "highest_\(id?.dropFirst(17).uppercased() ?? "UNKNOWN")"
                                }
                                if datas.value(forKey: key) == nil || score.value > datas.value(forKey: key) as! Int {
                                    datas.set(score.value, forKey: key)
                                    GKNotificationBanner.show(withTitle: NSLocalizedString("score_update_title", value: "Score updated!", comment: ""), message: NSLocalizedString("score_update_description", value: "We updated one score on your device", comment: ""), completionHandler: nil)
                                }
                                datas.synchronize()
                            }
                        }
                    }
                }
                GKAchievement.loadAchievements(completionHandler: nil)
            } else {
                self.gcEnabled = false
            }
        }
    }


}

