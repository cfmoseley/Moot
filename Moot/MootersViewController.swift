//
//  MootersViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/21/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class MootersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mootersTableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        //        print("MooterViewController:fetchedResultsController")
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Mooter")
        fetchRequest.fetchBatchSize = 30
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        }
        catch let error as NSError {
            print(error)
        }
        catch {
        }
        
//        print("MootersViewController: FetchedResultsController contains \(frc.fetchedObjects!.count) objects.")
        return frc
    }

    override func viewDidLoad() {
//        print("MootersViewController: viewDidLoad")
        super.viewDidLoad()
        
        mootersTableView.delegate = self
        mootersTableView.dataSource = self
        
//        mootersTableView.setEditing(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        print("viewWillAppear")
        self.mootersTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        NOTA BENE: Segues are handled automatically by UIKit - don't invoke in code
//        print("Preparing for segue: \(segue.identifier)")
        let dest = segue.destination as! MooterViewController
        dest.vc = self
        switch segue.identifier! {
        case "mooterDetail" :
//            print("Segue: mooterDetail")
            let ip = self.mootersTableView.indexPathForSelectedRow
            dest.mooter = fetchedResultsController!.object(at: ip!) as? Mooter
        case "mooterAddNew" :
            print("Segue: mooterAddNew")
        default:
            print("Segue: default not going anywhere")
        }
    }
    
    // MARK: Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.mootersTableView.setEditing(editing, animated: animated)
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
            self.mootersTableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("MootersTableView:cellForRowAtIndexPath \(indexPath.section), \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "mooterCell", for: indexPath) as! MooterCell
        let mooter = fetchedResultsController!.object(at: indexPath) as! Mooter
        
        cell.lblName.text = "\(mooter.lastName!), \(mooter.firstName!)"
        cell.lblSchool.text = mooter.school?.name
        let mr = mooter.rank!
        let ms = mooter.side!
        let sn = sideNames[ms]!
        var rl = "   \(mooter.language!)"
        if mooter.needsII == 1 {
            rl = "\(rl)+"
        }
        cell.lblRole.text = "\(rankNames[mr.intValue]) \(sn)   \(rl)"
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let secondColor = UIColor(red:0.8, green:0.0, blue:0.0, alpha:0.1)
        gradient.colors = [UIColor.white.cgColor, secondColor.cgColor]
        cell.layer.insertSublayer(gradient, at: 0)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController!.sections {
//            print("MootersTableView.numberOfSectionsInTableView = \(sections.count)")
            return sections.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController!.sections {
            let currentSection = sections[section]
//            print("MootersTableView.numberOfRowsInSection \(section) is \(currentSection.numberOfObjects)")
            return currentSection.numberOfObjects
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("SchoolsTableView:didSelectRowAtIndexPath \(indexPath.section):\(indexPath.row)")
//        Don't perform the segue here - it's done automatically. Avoid doing it twice
//        performSegueWithIdentifier("mooterDetail", sender: self)
    }
    
}
