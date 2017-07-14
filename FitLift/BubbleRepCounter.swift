import UIKit
import QuartzCore

@IBDesignable
class BubbleRepCounter: UIControl {
  
  private let radius: CGFloat = 8
  private let lineThickness: CGFloat = 1
  var exerciseRoutine: ExerciseRoutine?
  
  @IBInspectable var reps: Int = 0
  @IBInspectable var filledReps: Int = 0
  
  
  init(reps: Int) {
    self.reps = reps
    
    super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(reps)*radius*2, height: radius*2)))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.isOpaque = false
    self.backgroundColor = UIColor.clear
  }
  
  override func draw(_ rect: CGRect) {
    
    self.isOpaque = false
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.clear(self.frame)
    
    UIColor.white.set()
    for i in 1...reps {
      ctx?.addArc(center: CGPoint(x: radius*(2*CGFloat(i) - 1), y: bounds.height/2), radius: radius - lineThickness, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
      ctx?.setLineWidth(lineThickness)
      ctx?.setLineCap(.butt)
      
      
      if (i <= filledReps) {
        ctx?.drawPath(using: .fill)
      } else {
        ctx?.drawPath(using: .stroke)
      }
    }
    
  }
  
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    changeFilledReps()
    return false
  }
  
  func changeFilledReps() {
    if filledReps == 0 {
      filledReps = reps
    } else {
      filledReps -= 1
    }
    setNeedsDisplay()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
