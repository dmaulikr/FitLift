//
//  WorkoutTableViewCell.swift
//  FitLift
//
//  Created by Gerald Morna on 15/5/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell, UITextFieldDelegate {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var setsLabel: UILabel!
  @IBOutlet var topConstraint: NSLayoutConstraint!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!
  @IBOutlet var gradientView: UIImageView!
  @IBOutlet var weightTextField: WeightTextField!
  
  var completedSets = 0
  var attemptedSets = 0
  
  let imageParallaxFactor: CGFloat = 40
  
  var topInitial: CGFloat!
  var bottomInitial: CGFloat!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    self.backgroundColor = UIColor.clear
    
    self.clipsToBounds = true
    self.bottomConstraint.constant -= 2 * imageParallaxFactor
    self.topInitial = self.topConstraint.constant
    self.bottomInitial = self.bottomConstraint.constant
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = gradientView.frame
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientView.layer.addSublayer(gradientLayer)
    
    weightTextField.delegate = self
  }
  
  func setBackgroundOffset(offset:CGFloat) {
    let boundOffset = max(0, min(1, offset))
    let pixelOffset = (1-boundOffset)*2*imageParallaxFactor
    self.topConstraint.constant = self.topInitial - pixelOffset
    self.bottomConstraint.constant = self.bottomInitial + pixelOffset
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
