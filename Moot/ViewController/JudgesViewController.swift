//
//  SecondViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/21/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class JudgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
        
    @IBOutlet weak var judgesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        judgesTableView.dataSource = self
        judgesTableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        judgesTableView.setEditing(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        print("viewWillAppear")
        self.judgesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Preparing for segue: \(segue.identifier)")
        let dest = segue.destination as! JudgeViewController
        dest.vc = self
        switch segue.identifier! {
        case "judgeDetail" :
            //            print("Segue: judgeDetail")
            let ip = self.judgesTableView.indexPathForSelectedRow
            dest.judge = fetchedResultsController!.object(at: ip!) as? Judge
        case "judgeAddNew" :
            print("Segue: judgeAddNew")
        default:
            print("Segue: default not going anywhere")
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        //        print("ListViewController:fetchedResultsController")
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Judge")
        fetchRequest.fetchBatchSize = 30
        let sortDescriptor1 = NSSortDescriptor(key: "frenchSpeaking", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "frenchSpeaking", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        }
        catch let error as NSError {
            print(error)
        }
        catch {
        }
        
        //        print("FetchedResultsController contains \(frc.fetchedObjects!.count) objects.")
        return frc
    }
    
    // MARK: Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.judgesTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                                      forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            let apd = UIApplication.shared.delegate as! AppDelegate
            let moc = fetchedResultsController!.managedObjectContext
            moc.delete(fetchedResultsController!.object(at: indexPath) as! NSManagedObject)
            apd.saveContext()
            
            // remove the deleted item from the `UITableView`
            self.judgesTableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("judgesTableView:cellForRowAtIndexPath \(indexPath.section), \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "judgeCell", for: indexPath) as! JudgeCell
        let judge = fetchedResultsController!.object(at: indexPath) as! Judge
        
        cell.lblName.text = "\(judge.firstName!) \(judge.lastName!)"
        cell.lblLocation.text = "\(judge.city!), \(provinceNames[judge.province!]!)"
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let secondColor = UIColor(red:0.0, green:0.0, blue:0.8, alpha:0.1)
        gradient.colors = [UIColor.white.cgColor, secondColor.cgColor]
        cell.layer.insertSublayer(gradient, at: 0)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController!.sections {
            //            print("judgesTableView.numberOfSectionsInTableView = \(sections.count)")
            return sections.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController!.sections {
            let currentSection = sections[section]
            //            print("judgesTableView.numberOfRowsInSection \(section) is \(currentSection.numberOfObjects)")
            return currentSection.numberOfObjects
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let ip: IndexPath = IndexPath(row: 0, section: section) as IndexPath? {
            let judge = fetchedResultsController!.object(at: ip) as! Judge
            
            let v: UILabel = UILabel()
            if let jfs = judge.frenchSpeaking {
                if jfs == 0 {
                    v.text = "English Only"
                } else {
                    v.text = "French Speaking"
                }
            } else {
                v.text = "English Only"
            }
            
            v.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            v.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            v.font = UIFont.boldSystemFont(ofSize: 22)
            
            return v
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    // MARK: TableViewDelegate
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        //        print("judgesTableView:didSelectRowAtIndexPath \(indexPath.section):\(indexPath.row)")
////        Don't perform the segue here - it's done automatically. Avoid doing it twice
////        performSegueWithIdentifier("judgeDetail", sender: self)
//    }
//    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("ListViewController:didSelectRowAtIndexPath \(indexPath.section):\(indexPath.row)")
        performSegue(withIdentifier: "edit", sender: self)
    }
}

