//
//  WeightTextField.swift
//  FitLift
//
//  Created by Gerald Morna on 22/5/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.
//

import UIKit

class WeightTextField: UITextField,UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let maxCharacterCount = 3
    
    if(textField.text!.characters.count > maxCharacterCount) {
      return false
    }
    
    if(string == ".") {
      if(textField.text!.contains(".") || textField.text!.isEmpty) {
        return false
      }
    }
    
    let charSet = CharacterSet(charactersIn: "0123456789.") //Only allow digits and a single decimal point
    for _ in string.characters.indices {
      if string.rangeOfCharacter(from: charSet) != nil {
        return true
      }
      else {
        return false
      }
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if(textField.text?.isEmpty)! {
      textField.text?.append("0.0")
    }
    else if(textField.text?.characters.last == ".") {
      textField.text!.append("0")
    }
    else if(!textField.text!.contains(".")) {
      textField.text!.append(".0")
    }
    
    textField.text?.append("kg")
    self.endEditing(true)
    return true
  }
  
  override func awakeFromNib() {
    self.delegate = self
    adjustsFontSizeToFitWidth = true
    
  }
}
