//
//  ViewController.swift
//  LOL:TANA
//
//  Created by Jonathan Yu on 11/30/18.
//  Copyright © 2018 Jonathan Yu. All rights reserved.
//
//  View Controller view of Launch Screen

import UIKit

class LaunchController: UIViewController, AKPickerViewDelegate, AKPickerViewDataSource {
    
    // custom AKPicker view
    @IBOutlet weak var championPicker: AKPickerView!
    @IBOutlet var tutorialView: UIView!
    
    let championList = ["Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Jhin", "Jinx", "Kai'Sa", "Kalista", "Kog'Maw", "Lucian", "Miss Fortune", "Quinn", "Sivir", "Tristana", "Twitch", "Varus", "Vayne", "Xayah"]
    var championSelected : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        championSelected = championList[0]
        
        self.championPicker.delegate = self
        self.championPicker.dataSource = self
        self.championPicker.pickerViewStyle = .wheel
        self.championPicker.reloadData()
        
        tutorialView.layer.borderWidth = 4
        tutorialView.layer.borderColor = UIColor.black.cgColor
        //tutorialView.layer.cornerRadius = 10
        self.view.addSubview(tutorialView)
        tutorialView.center = self.view.center
        

    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return championList.count
    }
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {

        return UIImage(named: championList[item])!.imageWithSize(CGSize(width: 75, height: 60))
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        championSelected = championList[item]
        print(championSelected!)
    }
    
    @IBAction func closeTutorialButton(_ sender: Any) {
        animateOut()
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tutorialView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.tutorialView.alpha = 0
            
        }) {(success:Bool) in
            self.tutorialView.removeFromSuperview()
        }
    }
    
    @IBAction func launchButton(_ sender: UIButton) {
        sender.pulsate()
        performSegue(withIdentifier: "goToAIView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! AIViewController
        secondVC.champSelected = championSelected!
    }
    


}

