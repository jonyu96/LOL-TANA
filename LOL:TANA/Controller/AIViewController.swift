//
//  MainViewController.swift
//  LOL:TANA
//
//  Created by Jonathan Yu on 12/1/18.
//  Copyright © 2018 Jonathan Yu. All rights reserved.
//
//  View Controller for win percentage screen. Uses three
//  different models to generate win percentage based on
//  specific input values (performance feature values)

import UIKit
import Alamofire
import SwiftyJSON
import EFCountingLabel
import SuxiNumberInputView



class AIViewController: UIViewController {
    
    // CoreML Models (10/20/30 min)
    let model_10 = LogRegModel_10()
    let model_20 = LogRegModel_20()
    let model_30 = LogRegModel_30()
    
    // Champion.GG API url and key
    // To retrieve initial general winrate of selected champion
    let championGG_api = "http://api.champion.gg/v2/champions/"
    let championGG_api_key = "1fdd79e55b7ffbabb30a2c7e494a6874"
    
    var champSelected : String?
    let champDataModel = ChampDataModel()
    
    var shapeLayer : CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    // Percentage label
    let percentageLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.text = "START"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    // Keep track of game duration
    var gameDuration : Int?
    
    // Feature Input Values
    
    @IBOutlet weak var playerCSInput: UITextView!
    @IBOutlet weak var matchupCSInput: UITextView!
    
    @IBOutlet weak var killCountLabel: UILabel!
    @IBOutlet weak var deathCountLabel: UILabel!
    @IBOutlet weak var assistCountLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var dragonCountLabel: UILabel!
    
    @IBOutlet weak var firstBloodCheck: UILabel!
    @IBOutlet weak var firstTowerCheck: UILabel!
    @IBOutlet weak var firstHeraldCheck: UILabel!
    @IBOutlet weak var firstBaronCheck: UILabel!
    @IBOutlet weak var firstInhibitorCheck: UILabel!
    
    var getFirstBlood : Int = 0
    var getFirstTower : Int = 0
    var getHerald : Int = 0
    var getFirstBaron : Int = 0
    var getFirstInhibitor : Int = 0
    
    
    // Initialize buttons and views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerCSView = SuxiNumberInputView().bindTo(textView: playerCSInput)
        playerCSView?.becomeFirstResponder()
        let matchupCSView = SuxiNumberInputView().bindTo(textView: matchupCSInput)
        matchupCSView?.becomeFirstResponder()
        
        let bloodTap = UITapGestureRecognizer(target: self, action: #selector(AIViewController.bloodTapFunction))
        firstBloodCheck.isUserInteractionEnabled = true
        firstBloodCheck.addGestureRecognizer(bloodTap)
        
        let towerTap = UITapGestureRecognizer(target: self, action: #selector(AIViewController.towerTapFunction))
        firstTowerCheck.isUserInteractionEnabled = true
        firstTowerCheck.addGestureRecognizer(towerTap)
        
        let heraldTap = UITapGestureRecognizer(target: self, action: #selector(AIViewController.heraldTapFunction(sender:)))
        firstHeraldCheck.isUserInteractionEnabled = true
        firstHeraldCheck.addGestureRecognizer(heraldTap)
        
        let baronTap = UITapGestureRecognizer(target: self, action: #selector(AIViewController.baronTapFunction(sender:)))
        firstBaronCheck.isUserInteractionEnabled = true
        firstBaronCheck.addGestureRecognizer(baronTap)
        
        let inhibitorTap = UITapGestureRecognizer(target: self, action: #selector(AIViewController.inhibitorTapFunction(sender:)))
        firstInhibitorCheck.isUserInteractionEnabled = true
        firstInhibitorCheck.addGestureRecognizer(inhibitorTap)


    }
    
    // Display champion win rate as the initial win percentage
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loginTime = Date()
        UserDefaults.standard.set(loginTime, forKey: "loginTime")
        
        setupCircularWP()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let url = championGG_api + String(champDataModel.retrieveChampID(name: champSelected!)) + "?elo=GOLD&api_key=" + championGG_api_key
    
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                
                let champJSON : JSON = JSON(response.result.value!)
                let champWinRate = champJSON[0]["winRate"].floatValue
                self.animatePercentage(percentage: champWinRate)
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    // Create circular, animated win percentage indicator
    private func setupCircularWP() {
        // pulsating layer
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // create track layer
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .white)
        view.layer.addSublayer(trackLayer)
        
        // create shape layer
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        // create percentage label
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = CGPoint(x: 187.5, y: 230)
        self.view.addSubview(percentageLabel)
    }
    
    // Create outer circle layer
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer{
        let indicatorPosition = CGPoint(x: 187.5, y: 230)
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = indicatorPosition
        return layer
    }
    
    // Animation
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func animatePercentage(percentage: Float) {

        percentageLabel.format = "%.1f%%"
        percentageLabel.method = .easeOut
        percentageLabel.animationDuration = 2
        percentageLabel.countFrom(0, to: CGFloat(100.0 * percentage))
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(percentage)
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func getGameDuration() -> String {
        let loginTime = UserDefaults.standard.object(forKey: "loginTime") as? Date ?? Date()
        let loginInterval = -loginTime.timeIntervalSinceNow
        
        let formatter = DateComponentsFormatter()
        //formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute]
        
        // Use the configured formatter to generate the string.
        //let userLoginTimeString = formatter.string(from: loginInterval) ?? ""
        return formatter.string(from: loginInterval) ?? ""
    }

    @objc private func handleTap() {
        
        //let gameDuration:Int? = Int(getGameDuration())
        let gameDuration : Int? = 30
        
        let playerCS:Int? = Int(playerCSInput.text!)
        let matchupCS:Int? = Int(matchupCSInput.text!)
        let csDiff = playerCS! - matchupCS!
        
        let kills:Int? = Int(killCountLabel.text!)
        let deaths:Int? = Int(deathCountLabel.text!)
        let assists:Int? = Int(assistCountLabel.text!)
        
        let numOfItems:Int? = Int(itemCountLabel.text!)
        let dragons:Int? = Int(dragonCountLabel.text!)
        
        let win_percentage : Float
        
        if gameDuration! <= 10 {
            let input = LogRegModel_10Input(creepsPerMinDelta: Double(playerCS! / gameDuration!), csDiff: Double(csDiff), kills: Double(kills!), deaths: Double(deaths!), assists: Double(assists!), numOfItems: Double(numOfItems!), firstBlood: Double(getFirstBlood))
            guard let output = try? model_10.prediction(input: input) else {
                return
            }
            let win_loss = output.classProbability
            guard let win_proba = win_loss[1] else {
                return
            }
            win_percentage = Float(win_proba)
        } else if gameDuration! > 10 && gameDuration! <= 20 {
            let input = LogRegModel_20Input(creepsPerMinDelta: Double(playerCS! / gameDuration!), csDiff: Double(csDiff), kills: Double(kills!), deaths: Double(deaths!), assists: Double(assists!), numOfItems: Double(numOfItems!), firstTower: Double(getFirstTower), firstRiftHerald: Double(getHerald))
            guard let output = try? model_20.prediction(input: input) else {
                return
            }
            let win_loss = output.classProbability
            guard let win_proba = win_loss[1] else {
                return
            }
            win_percentage = Float(win_proba)
        } else {
            let input = LogRegModel_30Input(creepsPerMinDelta: Double(playerCS! / 30), csDiff: Double(csDiff), kills: Double(kills!), deaths: Double(deaths!), assists: Double(assists!), numOfItems: Double(numOfItems!), dragonKills: Double(dragons!), firstBaron: Double(getFirstBaron), firstInhibitor: Double(getFirstInhibitor))
            guard let output = try? model_30.prediction(input: input) else {
                return
            }
            let win_loss = output.classProbability
            guard let win_proba = win_loss[1] else {
                return
            }
            win_percentage = Float(win_proba)
        }
    
        
        animatePercentage(percentage: win_percentage)
        
    }
    
    // Button functions
    @IBAction func incrementKillButton(_ sender: Any) {
        let killCount:Int? = Int(killCountLabel.text!)
        killCountLabel.text = String(killCount! + 1)
    }
    
    @IBAction func incrementDeathButton(_ sender: Any) {
        let deathCount:Int? = Int(deathCountLabel.text!)
        deathCountLabel.text = String(deathCount! + 1)
    }
    
    @IBAction func incrementAssistButton(_ sender: Any) {
        let assistCount:Int? = Int(assistCountLabel.text!)
        assistCountLabel.text = String(assistCount! + 1)
    }
    @IBAction func incrementItemsButton(_ sender: Any) {
        let itemsCount:Int? = Int(itemCountLabel.text!)
        itemCountLabel.text = String(itemsCount! + 1)
    }
    @IBAction func incrementDragonButton(_ sender: Any) {
        let dragonCount:Int? = Int(dragonCountLabel.text!)
        dragonCountLabel.text = String(dragonCount! + 1)
    }
    
    @objc func bloodTapFunction(sender:UITapGestureRecognizer) {
        firstBloodCheck.textColor = UIColor.rgb(r: 99, g: 99, b: 0)
        getFirstBlood = 1
    }
    
    @objc func towerTapFunction(sender:UITapGestureRecognizer) {
        firstTowerCheck.textColor = UIColor.rgb(r: 99, g: 99, b: 0)
        getFirstTower = 1
    }
    
    @objc func heraldTapFunction(sender:UITapGestureRecognizer) {
        firstHeraldCheck.textColor = UIColor.rgb(r: 99, g: 99, b: 0)
        getHerald = 1
    }
    
    @objc func baronTapFunction(sender:UITapGestureRecognizer) {
        firstBaronCheck.textColor = UIColor.rgb(r: 99, g: 99, b: 0)
        getFirstBaron = 1
    }
    
    @objc func inhibitorTapFunction(sender:UITapGestureRecognizer) {
        firstInhibitorCheck.textColor = UIColor.rgb(r: 99, g: 99, b: 0)
        getFirstInhibitor = 1
    }
    
}
