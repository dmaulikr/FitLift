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
  
  var tapTimer: Timer?
  var workout: Workout = allWorkouts[0] //Set by the previous viewcontroller
  
  var previousWorkout: Workout?
  var previousCompletionCounter: [Bool]?
  
  var currentCompletionCounter: [Bool]
  var currentWorkoutRoutine: Int = 0
  
  //CoreData variables
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let moc: NSManagedObjectContext
  let entity: NSEntityDescription
  let item: NSManagedObject
  
  fileprivate var scrollOffsetY: CGFloat = 0
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    configureNavBar()
    let image1 = Asset.backgroundImage.image
    tableView.backgroundView = UIImageView(image: image1)
    
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //    let context = appDelegate.managedObjectContext
    
    //    let entity = NSEntityDescription.entity(forEntityName: "SavedWorkout", in: context)
    //    let item = NSManagedObject(entity: entity!, insertInto: context)
    //
    //    item.setValue(Date() as NSDate, forKey: "date")
    //
    //    do {
    //      try context.save()
    //      print("data saved")
    //    } catch {
    //      print("saving error")
    //    }
    
    print("Current workout: \(workout.name)")
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    moc = appDelegate.managedObjectContext
    entity = NSEntityDescription.entity(forEntityName: "SavedWorkout", in: moc)!
    item = NSManagedObject(entity: entity, insertInto: moc)
    
    
    let workoutSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedWorkout")
    var allSavedWorkouts: [SavedWorkout] = []
    do {
      allSavedWorkouts = try moc.fetch(workoutSearch) as! [SavedWorkout]
    } catch {
      print("Fetching workouts Error")
    }
    
    for previousWorkout in allSavedWorkouts {
      if let _ = previousWorkout.date {
        print("previous workout had a date")
      } else {
        print("previous workout did not have a date")
      }
    }
    
    currentCompletionCounter = [Bool](repeating: false, count: workout.routine[currentWorkoutRoutine].exercises.count)
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }
  
  @IBAction func doneButtonpressed(_ sender: UIBarButtonItem) {
    
    print("Done button pressed")
    
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    print("Cancel button pressed")
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
      
      let bubbleCounter = BubbleRepCounter(reps: 5)
      bubbleCounter.exerciseRoutine = exerciseRoutine
      bubbleCounter.backgroundColor = UIColor.clear
      bubbleCounter.frame = CGRect(x: cell.frame.width - bubbleCounter.frame.width - 10, y: cell.frame.height - bubbleCounter.frame.height*CGFloat(i) - 8*CGFloat(i), width: bubbleCounter.bounds.width, height: bubbleCounter.bounds.height)
      bubbleCounter.tag = i
      
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
    
    return cell
  }
  
  func bubblePressed(_ sender: UITapGestureRecognizer) {
    
    let bubble = sender.view as! BubbleRepCounter
    let alertDialogTimeDelay = 0.4
    
    bubble.changeFilledReps()
    
    tapTimer?.invalidate()
    tapTimer = Timer.scheduledTimer(timeInterval: alertDialogTimeDelay, target: self, selector: #selector(self.displayWorkoutFinishedDialog(_:)), userInfo: bubble, repeats: false)
    
  }
  
  func displayWorkoutFinishedDialog(_ timer: Timer) {
    
    let bubbleCounter = timer.userInfo as! BubbleRepCounter
    let cell = bubbleCounter.superview as! WorkoutTableViewCell
    
    var attemptedSets = 0
    var completedSets = 0
    
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
}
