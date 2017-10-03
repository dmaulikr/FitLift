//
//  SettingsViewController.swift
//  FitLift
//
//  Created by Gerald Morna on 29/9/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.

import UIKit

func convertMetricToImperial(metricVal: Double) -> Double {
  var tempMetric = metricVal
  var sum: Double = 45 * Double(Int(tempMetric / 20))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 20.0)
  
  sum = sum + 35 * Double(Int(tempMetric / 15))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 15.0)
  
  sum = sum + 25 * Double(Int(tempMetric / 10))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 10.0)
  
  sum = sum + 10 * Double(Int(tempMetric / 5))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 5.0)
  
  sum = sum + 5 * Double(Int(tempMetric / 2.5))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 2.5)
  
  sum = sum + 2.5 * Double(Int(tempMetric / 1.25))
  tempMetric = tempMetric.truncatingRemainder(dividingBy: 1.25)
  
  return sum
}

func convertImperialToMetric(imperialVal: Double) -> Double {
  var tempImperial = imperialVal
  var sum: Double = 20 * Double(Int(tempImperial / 45))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 45.0)
  
  sum = sum + 15 * Double(Int(tempImperial / 35))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 35.0)
  
  sum = sum + 10 * Double(Int(tempImperial / 25))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 25.0)
  
  sum = sum + 5 * Double(Int(tempImperial / 10))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 10.0)
  
  sum = sum + 2.5 * Double(Int(tempImperial / 5))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 5.0)
  
  sum = sum + 1.25 * Double(Int(tempImperial / 2.5))
  tempImperial = tempImperial.truncatingRemainder(dividingBy: 2.5)
  
  return Double(sum)
}

class SettingsViewController: UIViewController {
  
  @IBOutlet var metricOptionSwitch: OutlineSwitch!
  var settingMetric: Bool = true //true for kg, false for lbs cause i'm shit
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    if let settingMetric = getMetricSetting() {
      print("settingMetric found!, it's \(settingMetric)")
      metricOptionSwitch.rightSelected = !settingMetric
    } else {
      print("settingMetric not found")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func switchTriggered(_ sender: OutlineSwitch) {
    let outlineSwitch = sender as OutlineSwitch
    if outlineSwitch.rightSelected {
//      print("lbs selected")
      settingMetric = false
      saveData()
    } else {
//      print("kg selected")
      settingMetric = true
      saveData()
    }
  }
  
  func saveData() {
    
//    print("Attempting to save settings")
    
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: settingMetric)
//    print("encodedData: \(encodedData)")
    
    let userDefaults: UserDefaults = UserDefaults.standard
    userDefaults.set(encodedData, forKey: "settingMetric")
    userDefaults.synchronize()
  }
  
  func getMetricSetting() -> Bool? {
    
    if let data = UserDefaults.standard.data(forKey: "settingMetric"),
      let savedSettingMetric = NSKeyedUnarchiver.unarchiveObject(with: data) as? Bool {
      return savedSettingMetric
    } else {
      return nil
    }
  }
}
