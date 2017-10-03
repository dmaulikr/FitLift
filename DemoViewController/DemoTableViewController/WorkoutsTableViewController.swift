//
//  ViewController.swift
//  FitLift
//
//  Created by Gerald Morna on 11/5/17.
//  Copyright © 2017 Gerald Morna. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsTableViewController: ExpandingTableViewController {
  
  var tapTimer: Timer = Timer()
  var routineIndex: Int8 = 0  //Set by the previous viewcontroller, 0 by default
  var workout: Workout = allWorkouts[0] //Set by the previous viewcontroller, 0 by default
  
  //nil if the user has not done this workout previously
  var previousWorkout: SavedWorkout?
  var previousCompletionCounter: [Bool]?
  
  var currentCompletionCounter: [Bool] = []
  var currentWorkoutRoutine: Int = 0 //Set by the previous viewcontroller, 0 by default
  
  //User input storage
  var bubbleCounterInputData: [[Int]] = []  //Stores the values of the bubbleCounters so they are not lost on dequeue
  var weightsForTextFields: [Float] = []
  
  //CoreData variables
  //WHY CANT I FIGURE THIS OUT, SCREW IT I'LL USE USERDEFAULTS
  
  fileprivate var scrollOffsetY: CGFloat = 0
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    configureNavBar()
    let image1 = Asset.backgroundImage.image
    tableView.backgroundView = UIImageView(image: image1)
    
    // The two variables below store user info when each cell is dequeued
    weightsForTextFields = [Float](repeating: 0.0, count: workout.routine[currentWorkoutRoutine].exercises.count)
    currentCompletionCounter = [Bool](repeating: false, count: workout.routine[currentWorkoutRoutine].exercises.count)
    for exercise in workout.routine[currentWorkoutRoutine].exercises {
      
      bubbleCounterInputData.append([Int](repeating: 0, count: exercise.sets))
    }
    print("Current workout: \(workout.name)")
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }
  
  @IBAction func doneButtonpressed(_ sender: UIBarButtonItem) {
    
    for i in 0...workout.routine[currentWorkoutRoutine].exercises.count - 1 {
      workout.routine[currentWorkoutRoutine].exercises[i].weight = weightsForTextFields[i]
    }
    
    saveData()
    popTransitionAnimation()
  }
  
  @IBAction func weightsDoneEditing(_ sender: Any) {
    
    let weightTextView = sender as! WeightTextField
    let cell = weightTextView.superview!.superview as! WorkoutTableViewCell
    let row = tableView.indexPath(for: cell)!.row
    
    weightsForTextFields[row] = weightTextView.weight
    workout.routine[currentWorkoutRoutine].exercises[row].weight = weightTextView.weight
    
    print("User finished editing weight at row: \(row)")
    
  }
}
// MARK: Helpers

extension WorkoutsTableViewController {
  
  fileprivate func configureNavBar() {
    //navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
  }
}

// MARK: Actions

extension WorkoutsTableViewController {
  
  @IBAction func backButtonHandler(_ sender: AnyObject) {
    // buttonAnimation
    
    print("Cancel button pressed")
    
    let viewControllers: [WorkoutsViewController?] = navigationController?.viewControllers.map { $0 as? WorkoutsViewController } ?? []
    
    for viewController in viewControllers {
      if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(false)
      }
    }
    popTransitionAnimation()
  }
}

// MARK: UIScrollViewDelegate

extension WorkoutsTableViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //    if scrollView.contentOffset.y < -25 {
    //      // buttonAnimation
    //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
    //
    //      for viewController in viewControllers {
    //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
    //          rightButton.animationSelected(false)
    //        }
    //      }
    //      popTransitionAnimation()
    //    }
    
    scrollOffsetY = scrollView.contentOffset.y
    
    if (scrollView == self.tableView) {
      for indexPath in self.tableView.indexPathsForVisibleRows! as [NSIndexPath] {
        self.setCellImageOffset(cell: self.tableView.cellForRow(at: indexPath as IndexPath) as! WorkoutTableViewCell, indexPath: indexPath)
      }
    }
  }
  
  func setCellImageOffset(cell: WorkoutTableViewCell, indexPath: NSIndexPath) {
    let cellFrame = self.tableView.rectForRow(at: indexPath as IndexPath)
    let cellFrameInTable = self.tableView.convert(cellFrame, to: self.tableView.superview)
    let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
    let tableHeight = self.tableView.bounds.size.height + cellFrameInTable.size.height
    let cellOffsetFactor = cellOffset / tableHeight
    cell.setBackgroundOffset(offset: cellOffsetFactor)
  }
  
}

extension WorkoutsTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allWorkouts[section].routine[0].exercises.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let exerciseRoutine = workout.routine[currentWorkoutRoutine].exercises[indexPath.row]
    let exercise = exerciseRoutine.exercise
    //let cell = WorkoutTableViewCell()
    let cell = tableView.dequeueReusableCell(withIdentifier: "workoutTableCell") as! WorkoutTableViewCell
    
    for i in 1...exerciseRoutine.sets {
      
      let bubbleCounter = BubbleRepCounter(reps: exerciseRoutine.reps)
      bubbleCounter.exerciseRoutine = exerciseRoutine
      bubbleCounter.backgroundColor = UIColor.clear
      bubbleCounter.frame = CGRect(x: cell.frame.width - bubbleCounter.frame.width - 10, y: cell.frame.height - bubbleCounter.frame.height*CGFloat(i) - 8*CGFloat(i), width: bubbleCounter.bounds.width, height: bubbleCounter.bounds.height)
      bubbleCounter.tag = i
      bubbleCounter.filledReps = bubbleCounterInputData[indexPath.row][bubbleCounter.tag - 1]
      
      let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(bubblePressed(_:)))
      touchRecognizer.numberOfTapsRequired = 1
      bubbleCounter.addGestureRecognizer(touchRecognizer)
      bubbleCounter.isUserInteractionEnabled = true
      
      if(cell.viewWithTag(i) == nil) {
        cell.addSubview(bubbleCounter)
      }
    }
    
    cell.backgroundImageView.image = UIImage(named: exercise.imageName)
    cell.backgroundImageView.contentMode = .scaleAspectFill
    cell.nameLabel.text = exercise.name
    cell.setsLabel.text = "\(exerciseRoutine.sets)x\(exerciseRoutine.reps)"
    
    if previousWorkout != nil && previousCompletionCounter != nil {
      if previousWorkout!.completionCounter[indexPath.row] {
        cell.weightTextField.text = "\(previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].weight + previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].increaseWeightAmount)"
        weightsForTextFields[indexPath.row] = previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].weight + previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].increaseWeightAmount
      } else {
        cell.weightTextField.text = "\(previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].weight)"
        weightsForTextFields[indexPath.row] = previousWorkout!.workout.routine[previousWorkout!.routineIndex].exercises[indexPath.row].weight
      }
    }
    else {
      cell.weightTextField.text = "\(workout.routine[currentWorkoutRoutine].exercises[indexPath.row].weight)"
      weightsForTextFields[indexPath.row] = workout.routine[currentWorkoutRoutine].exercises[indexPath.row].weight
    }
    
    let _ = cell.weightTextField.textFieldShouldReturn(cell.weightTextField)
    
    return cell
  }
  
  func bubblePressed(_ sender: UITapGestureRecognizer) {
    
    let bubble = sender.view as! BubbleRepCounter
    let cell = bubble.superview! as! WorkoutTableViewCell
    let row = tableView.indexPath(for: cell)!.row
    let alertDialogTimeDelay = 3.0
    
    bubble.changeFilledReps()
    bubbleCounterInputData[row][bubble.tag - 1] = bubble.filledReps
    
    tapTimer.invalidate()
    tapTimer = Timer.scheduledTimer(timeInterval: alertDialogTimeDelay, target: self, selector: #selector(self.displayWorkoutFinishedDialog(_:)), userInfo: bubble, repeats: false)
  }
  
  func displayWorkoutFinishedDialog(_ timer: Timer) {
    
    let bubbleCounter = timer.userInfo as! BubbleRepCounter
    let cell = bubbleCounter.superview as! WorkoutTableViewCell
    
    var attemptedSets = 0
    var completedSets = 0
    
        print("tableView row: \(self.tableView.indexPath(for: cell)!.row)")
    currentCompletionCounter[self.tableView.indexPath(for: cell)!.row] = false
    
    for subview in cell.subviews {  //Find how many sets have been attempted vs completed
      if subview is BubbleRepCounter {
        if (subview as! BubbleRepCounter).filledReps != 0 {
          attemptedSets = attemptedSets + 1
          if (subview as! BubbleRepCounter).filledReps == (subview as! BubbleRepCounter).reps {
            completedSets = completedSets + 1
          }
        }
      }
    }
    
    if(bubbleCounter.filledReps == 0) {
      return
    }
    
    let cancelAction = DOAlertAction(title: "Done", style: .cancel, handler: nil)
    var alertController = DOAlertController()
    
    if attemptedSets == bubbleCounter.exerciseRoutine?.sets {
      if completedSets == bubbleCounter.exerciseRoutine?.sets { //Exercise completed successfully
        alertController = DOAlertController(title: "Exercise Complete!", message: "Increase weight by \(bubbleCounter.exerciseRoutine!.increaseWeightAmount)kg for your next workout", preferredStyle: .alert, restPeriodRemaining: bubbleCounter.exerciseRoutine!.restPeriod)
        
        currentCompletionCounter[self.tableView.indexPath(for: cell)!.row] = true
      } else {  //Exercise completed unsuccessfully
        alertController = DOAlertController(title: "Exercise Complete!", message: "Repeat the same weight next time", preferredStyle: .alert, restPeriodRemaining: bubbleCounter.exerciseRoutine!.restPeriod)
      }
    } else {  //Set finished successfully
      if bubbleCounter.filledReps == bubbleCounter.reps {
        alertController = DOAlertController(title: "Set Complete!", message: "Rest for \(bubbleCounter.exerciseRoutine!.restPeriod)", preferredStyle: .alert, restPeriodRemaining: bubbleCounter.exerciseRoutine!.restPeriod)
      } else {  //Set compelted unsuccessfully
        alertController = DOAlertController(title: "Set Failed", message: "Rest for \(bubbleCounter.exerciseRoutine!.restPeriod * 2) seconds!", preferredStyle: .alert, restPeriodRemaining: bubbleCounter.exerciseRoutine!.restPeriod)
        alertController.restPeriodRemaining = bubbleCounter.exerciseRoutine!.restPeriod * 2
      }
    }
    
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
    
    if attemptedSets < bubbleCounter.reps {
      
      let _ = Timer.scheduledTimer(timeInterval: TimeInterval(alertController.updatePeriod), target: self, selector: #selector(self.updateRestlabel(_:)), userInfo: alertController, repeats: true)
      
      let boldText = "\(alertController.restPeriodRemaining) "  //Embolden the time in the alertDialog
      let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: alertController.messageView.font.pointSize)]
      let attributedString = NSMutableAttributedString(string: "Rest for ")
      attributedString.append(NSMutableAttributedString(string: boldText, attributes: attrs))
      attributedString.append(NSMutableAttributedString(string: "seconds"))
      alertController.messageView.attributedText = attributedString
    }
  }
  
  func updateRestlabel(_ sender: Timer) {
    
    let alertController = sender.userInfo as! DOAlertController //The DOAlertController contains a rest period variable
    alertController.restPeriodRemaining = alertController.restPeriodRemaining - alertController.updatePeriod
    
    let boldText = "\(alertController.restPeriodRemaining) "
    let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: alertController.messageView.font.pointSize)]
    let attributedString = NSMutableAttributedString(string: "Rest for ")
    attributedString.append(NSMutableAttributedString(string: boldText, attributes: attrs))
    attributedString.append(NSMutableAttributedString(string: "seconds"))
    
    alertController.messageView.attributedText = attributedString
    
    if(alertController.restPeriodRemaining <= 0) {
      sender.invalidate()
    }
  }
  
  func saveData() {
    
    print("Attempting to save data")
    
    let savedWorkout = SavedWorkout(workout: workout, completionCounter: currentCompletionCounter, date: NSDate(), routineIndex: currentWorkoutRoutine)
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: savedWorkout)
    print("encodedData: \(encodedData)")
    
    let userDefaults: UserDefaults = UserDefaults.standard
    userDefaults.set(encodedData, forKey: "savedWorkout")
    userDefaults.synchronize()
    
    //testSavedData()
  }
  
  func testSavedData() {
    
    if let data = UserDefaults.standard.data(forKey: "savedWorkout"),
      let lastWorkout = NSKeyedUnarchiver.unarchiveObject(with: data) as? SavedWorkout {
      print(lastWorkout.workout.routine)
    } else {
      print("There is an issue")
    }
  }
}

