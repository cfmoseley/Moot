//
//  SchoolsViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/21/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class SchoolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var schoolsTableView: UITableView!
    
    override func viewDidLoad() {
//        print("SchoolsViewController: viewDidLoad")
        super.viewDidLoad()
        
        schoolsTableView.delegate = self
        schoolsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear")
        self.schoolsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Preparing for segue: \(segue.identifier)")
        let dest = segue.destination as! SchoolViewController
        dest.vc = self
        switch segue.identifier! {
        case "schoolDetail" :
            print("Segue: schoolDetail")
            let ip = self.schoolsTableView.indexPathForSelectedRow
            dest.school = fetchedResultsController!.object(at: ip!) as? School
//        case "schoolAddNew" :     //This is automatic
//            print("Segue: schoolAddNew")
        default:
            print("Segue: default not going anywhere")
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
//        print("ListViewController:fetchedResultsController")
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "School")
        fetchRequest.fetchBatchSize = 30
        let sortDescriptor1 = NSSortDescriptor(key: "province", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "province", cacheName: nil)
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
        self.schoolsTableView.setEditing(editing, animated: animated)
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
            self.schoolsTableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("SchoolsTableView:cellForRowAtIndexPath \(indexPath.section), \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! SchoolCell
        let school = fetchedResultsController!.object(at: indexPath) as! School
        
        cell.lblName.text = school.name!
        cell.lblCity.text = "\(school.city!), \(school.province!)"
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let secondColor = UIColor(red:0.8, green:0.0, blue:0.0, alpha:0.1)
        gradient.colors = [UIColor.white.cgColor, secondColor.cgColor]
        cell.layer.insertSublayer(gradient, at: 0)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController!.sections {
//            print("SchoolsTableView.numberOfSectionsInTableView = \(sections.count)")
            return sections.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController!.sections {
            let currentSection = sections[section]
//            print("SchoolsTableView.numberOfRowsInSection \(section) is \(currentSection.numberOfObjects)")
            return currentSection.numberOfObjects
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let ip: IndexPath = IndexPath(row: 0, section: section) {
            let school = fetchedResultsController!.object(at: ip) as! School
            
            let v: UILabel = UILabel()
            if let pn = provinceNames[school.province!] {
                v.text = pn
            } else {
                v.text = "Unidentified Province"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("SchoolsTableView:didSelectRowAtIndexPath \(indexPath.section):\(indexPath.row)")
//        Don't perform the segue here - it's done automatically. Avoid doing it twice
//        performSegueWithIdentifier("schoolDetail", sender: self)
    }
    
}
