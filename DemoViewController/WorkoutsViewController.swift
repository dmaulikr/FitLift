//
//  WorkoutsViewController.swift
//

import UIKit
import CoreData

class WorkoutsViewController: ExpandingViewController {
  
  //CoreData variables
  
  
  typealias ItemInfo = (imageName: String, title: String)
  fileprivate var cellsIsOpen = [Bool]()
  fileprivate let items: [ItemInfo] = [("item0", "Boston"),("item1", "New York"),("item2", "San Francisco"),("item3", "Washington")]
  
  @IBOutlet weak var pageLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    
  }
}

// MARK: life cicle

extension WorkoutsViewController {
  
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 335)
    super.viewDidLoad()
    
    //print("Workouts viewDidLoad")
    
    registerCell()
    fillCellIsOpeenArry()
    addGestureToView(collectionView!)
    configureNavBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    //print("Workouts viewWillAppear")
    addGestureToView(collectionView!)
  }
  
  func getLastWorkout() -> SavedWorkout? {
    
    if let data = UserDefaults.standard.data(forKey: "savedWorkout"),
      let lastWorkout = NSKeyedUnarchiver.unarchiveObject(with: data) as? SavedWorkout {
      print("Last workout: \(lastWorkout.workout.name)")
      return lastWorkout
    } else {
      print("No Previous Workout Found!")
      return nil
    }
  }
}

// MARK: Helpers

extension WorkoutsViewController {
  
  fileprivate func registerCell() {
    
    let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
  }
  
  fileprivate func fillCellIsOpeenArry() {
    for _ in items {
      cellsIsOpen.append(false)
    }
  }
  
  fileprivate func getViewController() -> WorkoutsTableViewController {
    let storyboard = UIStoryboard(storyboard: .Main)
    let toViewController: WorkoutsTableViewController = storyboard.instantiateViewController()
    toViewController.workout = allWorkouts[currentIndex]
    
    if let lastSavedWorkout = getLastWorkout() {
      if lastSavedWorkout.workout.name == toViewController.workout.name {
        toViewController.previousWorkout = lastSavedWorkout
        toViewController.previousCompletionCounter = lastSavedWorkout.completionCounter
      } else {
        print("User is loading a different workout to the previous one")
      }
    } else {
      print("WE AINT FIND SHIT")
    }
    
    return toViewController
  }
  
  fileprivate func configureNavBar() {
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
  }
}

/// MARK: Gesture

extension WorkoutsViewController {
  
  fileprivate func addGestureToView(_ toView: UIView) {
    let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(WorkoutsViewController.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(WorkoutsViewController.swipeHandler(_:)))) {
      $0.direction = .down
    }
    toView.addGestureRecognizer(gesutereUp)
    toView.addGestureRecognizer(gesutereDown)
  }
  
  func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard let cell  = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
    
    cell.workoutDescriptionLabel.text = allWorkouts[currentIndex].longDescription
    // double swipe Up transition
    if cell.isOpened == true && sender.direction == .up {
      let upcomingTableViewController = getViewController()
      
      pushToViewController(upcomingTableViewController)
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
    
    let open = sender.direction == .up ? true : false
    cell.cellIsOpen(open)
    cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
  }
}

// MARK: UIScrollViewDelegate

extension WorkoutsViewController {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageLabel.text = "\(currentIndex+1)/\(allWorkouts.count)"
  }
}

// MARK: UICollectionViewDataSource

extension WorkoutsViewController {
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? DemoCollectionViewCell else { return }
    
    let index = (indexPath as NSIndexPath).row //% items.count
    let workout = allWorkouts[index]
    cell.backgroundImageView?.image = UIImage(named: workout.imageName)
    cell.customTitle.text = workout.name
    cell.cellIsOpen(cellsIsOpen[index], animated: false)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
      , currentIndex == (indexPath as NSIndexPath).row else { return }
    
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
      pushToViewController(getViewController())
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
  }
}

// MARK: UICollectionViewDataSource
extension WorkoutsViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return items.count
    return allWorkouts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath) as! DemoCollectionViewCell
    cell.leftView.text = allWorkouts[indexPath.row].shortDescription
    cell.rightView.text = String("\(allWorkouts[indexPath.row].routine[0].exercises.count) Exercises")
    return cell
  }
}
