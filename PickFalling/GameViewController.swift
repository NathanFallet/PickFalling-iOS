//
//  GameViewController.swift
//  PickFalling
//
//  Created by Nathan FALLET on 05/03/2018.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var object: UIImageView!
    @IBOutlet weak var clickArea: UIView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var clickto: UILabel!
    var points: Int!
    var mode: Mode?
    var pause: Bool?
    var playing: Bool?
    var lefttoright: Bool?
    var control: Bool?
    var nexting: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        player.image = UIImage(named: "player")
        object.image = UIImage(named: "spinash")
        
        if let mode = mode {
            player.image = mode.player
            object.image = mode.object
            clickArea.backgroundColor = hexStringToUIColor(hex: mode.color)
        }
        
        points = 0
        pause = true
        playing = true
        lefttoright = true
        control = false
        if mode?.name == "BIRD" {
            object.frame.origin.x = clickArea.frame.width
            object.frame.origin.y = clickArea.frame.height/2 - object.frame.height/2
            player.frame.origin.x = 0
            player.frame.origin.y = clickArea.frame.height/2 - player.frame.height/2
        } else {
            object.frame.origin.x = clickArea.frame.width/2 - object.frame.width/2
            object.frame.origin.y = -object.frame.height
            player.frame.origin.x = clickArea.frame.width/2 - player.frame.width/2
            player.frame.origin.y = clickArea.frame.height - player.frame.height
        }
        player.isHidden = false
        Timer.scheduledTimer(withTimeInterval: 0.017, repeats: true) { timer in
            if !(self.playing ?? true) {
                timer.invalidate()
            }
            if self.playing ?? true && !(self.pause ?? false) && !(self.nexting ?? false) {
                DispatchQueue.main.async {
                    if self.mode?.name == "BIRD" {
                        self.object.frame.origin.x -= self.clickArea.frame.width/self.getSpeed()
                    } else {
                        self.object.frame.origin.y += self.clickArea.frame.height/self.getSpeed()
                        if self.mode?.name == "ZIGZAG" || self.mode?.name == "EVERYTHING" || (self.mode?.name == "CONTROL" && !(self.control ?? false)) {
                            if self.lefttoright ?? true {
                                self.object.frame.origin.x += self.clickArea.frame.width/self.getSpeed()
                                if self.object.frame.origin.x >= self.clickArea.frame.width - self.object.frame.width {
                                    self.lefttoright = false
                                }
                            } else {
                                self.object.frame.origin.x -= self.clickArea.frame.width/self.getSpeed()
                                if self.object.frame.origin.x <= 0 {
                                    self.lefttoright = true
                                }
                            }
                        }
                    }
                }
                if self.object.frame.intersects(self.player.frame) {
                    if self.object.image == UIImage(named: "spinash2") {
                        self.endGame()
                    } else {
                        self.next()
                    }
                } else if (self.mode?.name == "BIRD" && self.object.frame.origin.x < -self.object.frame.width) || (self.object.frame.origin.y >= self.clickArea.frame.height) {
                    if self.object.image == UIImage(named: "spinash2") {
                        self.next()
                    } else {
                        self.endGame()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.view)
            movePlayer(location: touchPoint)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                      with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.view)
            movePlayer(location: touchPoint)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func movePlayer(location: CGPoint) {
        if pause ?? false {
            clickto.isHidden = true
            object.isHidden = false
            pause = false
        }
        if mode?.name == "BIRD" {
            player.frame.origin.y = max(score.frame.origin.y+score.frame.height, min(location.y-player.frame.height/2, clickArea.frame.height-player.frame.height))
        } else {
            var x = location.x
            if mode?.name == "MIRROR" || mode?.name == "EVERYTHING" {
                let middle = clickArea.frame.width/2
                x = middle - (x - middle)
            }
            if mode?.name == "CONTROL" && control ?? false {
                object.frame.origin.x = max(0, min(x-object.frame.width/2, clickArea.frame.width-object.frame.width))
            } else {
                player.frame.origin.x = max(0, min(x-player.frame.width/2, clickArea.frame.width-player.frame.width))
            }
        }
    }
    
    func getSpeed() -> CGFloat {
        if mode?.name == "QUICK" {
            return 25
        }
        if points < 5 {
            return 120
        } else if points < 20 {
            return 100
        } else if points < 30 {
            return 80
        } else if points < 50 {
            return 60
        } else if points < 70 {
            return 50
        } else if points < 90 {
            return 45
        } else if points < 110 {
            return 40
        } else if points < 130 {
            return 35
        } else if points < 150 {
            return 30
        }
        return 25
    }
    
    func endGame() {
        playing = false
        
        var highest = 0
        var highest_mode = 0
        var total = 0
        
        let datas = Foundation.UserDefaults.standard
        if datas.value(forKey: "highest") != nil {
            highest = datas.value(forKey: "highest") as! Int
        }
        if datas.value(forKey: "highest_\(mode?.name ?? "CLASSIC")") != nil {
            highest_mode = datas.value(forKey: "highest_\(mode?.name ?? "CLASSIC")") as! Int
        }
        if datas.value(forKey: "total") != nil {
            total = datas.value(forKey: "total") as! Int
        }
        
        total += points
        if points > highest {
            highest = points
        }
        if points > highest_mode {
            highest_mode = points
        }
        datas.set(highest, forKey: "highest")
        datas.set(highest_mode, forKey: "highest_\(mode?.name ?? "CLASSIC")")
        datas.set(total, forKey: "total")
        datas.synchronize()
        
        sendScore(id: "fr.zabricraft.iOSPickFalling.total_score", score: total)
        sendScore(id: "fr.zabricraft.iOSPickFalling.highest_score", score: highest)
        sendScore(id: "fr.zabricraft.iOSPickFalling.highest_score_in_\((mode?.name ?? "CLASSIC").lowercased())", score: highest_mode)
        
        performSegue(withIdentifier: "loseSegue", sender: self)
    }
    
    func next() {
        nexting = true
        
        if self.object.image == UIImage(named: "spinash1") {
            points = points + 10
        } else if self.object.image != UIImage(named: "spinash2") {
            points = points + 1
        }
        
        DispatchQueue.main.async {
            if self.mode?.name == "RANDOM" || self.mode?.name == "BONUS" || self.mode?.name == "EVERYTHING" || self.mode?.name == "CONTROL" {
                var ts = [String]()
                ts += ["spinash"]
                if self.mode?.name == "RANDOM" || self.mode?.name == "EVERYTHING" {
                    ts += ["heart", "bubble", "fish", "maggot"]
                }
                if self.mode?.name == "BONUS" || self.mode?.name == "EVERYTHING" || self.mode?.name == "CONTROL" {
                    ts += ["spinash1", "spinash2"]
                }
                self.object.image = UIImage(named: ts[Int(arc4random_uniform(UInt32(ts.count)))])
            }
            if self.mode?.name == "RANDOM2" {
                var ts = [String]()
                ts += ["player", "unicorn", "fish", "cat", "bird", "crab"]
                self.player.image = UIImage(named: ts[Int(arc4random_uniform(UInt32(ts.count)))])
            }
            if self.mode?.name == "BIRD" {
                self.object.frame.origin.x = self.clickArea.frame.width
                self.object.frame.origin.y = max(min(CGFloat(arc4random_uniform(UInt32(self.clickArea.frame.height))), self.clickArea.frame.height - self.object.frame.height), self.score.frame.origin.y + self.score.frame.height)
            } else {
                self.object.frame.origin.y = -self.object.frame.height
                self.object.frame.origin.x = min(CGFloat(arc4random_uniform(UInt32(self.clickArea.frame.width))), self.clickArea.frame.width - self.object.frame.width)
            }
            let format = NSLocalizedString("score", value:"Score: %d", comment:"Current score")
            self.score.text = String.localizedStringWithFormat(format, self.points!)
            if self.mode?.name == "CONTROL" {
                self.control = !(self.control ?? false)
            }
            self.nexting = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let loseViewController = segue.destination as? LoseViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        loseViewController.mode = mode
        loseViewController.points = points
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func sendScore(id: String, score: Int) {
        let bestScoreInt = GKScore(leaderboardIdentifier: id)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }

}
