//
//  MooterViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/22/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class MooterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var vc: MootersViewController?
    var mooter: Mooter?
    var fetchedSchools: [School] = []
    var rightRow: Int = 0
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var pkrSchool: UIPickerView!
    @IBOutlet weak var segSide: UISegmentedControl!
    @IBOutlet weak var segRank: UISegmentedControl!
    @IBOutlet weak var segLanguage: UISegmentedControl!
    @IBOutlet weak var swInterpretation: UISwitch!
    
    @IBAction func doSave(_ sender: UIBarButtonItem) {
        print("About to doSave")
        
        if ((txtFirstName.text == "") || (txtLastName.text == "")) {
            print("Incomplete entry")
        } else {
            
            let apd = UIApplication.shared.delegate as! AppDelegate
            let moc = apd.managedObjectContext
            
            //Add the school to the moc
            if let _ = mooter {
                if let _ = mooter!.school {
                    print("Editing mooter school: \(mooter!.school!.name)")
                } else {
                    print("Editing mooter school: nil")
               }
            } else {
                print("Adding new mooter")
                let entSchool = NSEntityDescription.entity(forEntityName: "Mooter", in: moc)
                mooter = Mooter(entity: entSchool!, insertInto: moc)
            }
            mooter!.firstName = txtFirstName.text
            mooter!.lastName = txtLastName.text
            mooter!.school = fetchedSchools[pkrSchool.selectedRow(inComponent: 0)]
            mooter!.side = (segSide.selectedSegmentIndex == 0 ? "A": "R")
            mooter!.rank = segRank.selectedSegmentIndex as NSNumber?
            mooter!.language = (segLanguage.selectedSegmentIndex == 0 ? "E": "F")
            mooter!.needsII = swInterpretation.isOn as NSNumber?
            print("Mooter: \(txtFirstName.text!), \(txtLastName.text!), \(txtLastName.text!) language: \(mooter!.language!)")
            
            apd.saveContext()
            
            vc!.navigationController!.popViewController(animated: true)
            print("Saved Mooter")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pkrSchool.delegate = self
        pkrSchool.dataSource = self
        
        setUpSchools()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = mooter {
            txtFirstName.text = mooter?.firstName
            txtLastName.text = mooter?.lastName
            segSide.selectedSegmentIndex = (mooter?.side == "A" ? 0:1)
            segRank.selectedSegmentIndex = (mooter?.rank?.intValue)!
            if let _ = mooter?.school {
                print("Mooter school: \(mooter!.school!.name!)")
            } else {
                print("Mooter school: nil")
            }
            segLanguage.selectedSegmentIndex = (mooter?.language == "E" ? 0:1)
            if let _ = mooter?.needsII {
                swInterpretation.isOn = (mooter?.needsII!.intValue == 0 ? false:true)
            } else {
                swInterpretation.isOn = false
            }
             pkrSchool.selectRow(rightRow, inComponent: 0, animated: true)
        } else {
            txtFirstName.text = ""
            txtLastName.text = ""
            segSide.selectedSegmentIndex = 0
            segRank.selectedSegmentIndex = 0
            segLanguage.selectedSegmentIndex = 0
            swInterpretation.isOn = false
            pkrSchool.selectRow(3, inComponent: 0, animated: true)
        }
        txtFirstName.isFirstResponder
    }
    
// MARK: Picker view datasource
    
    func setUpSchools() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let schoolsFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "School")
        schoolsFetch.fetchBatchSize = 30
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        schoolsFetch.sortDescriptors = [sortDescriptor]
        
        do {
            fetchedSchools = try moc.fetch(schoolsFetch) as! [School]
            if let _ = mooter {
                for ix in (0..<fetchedSchools.count) {
                    let sn = fetchedSchools[ix].name!
                    //                var hitS = ""
                    if sn == mooter!.school!.name! {
                        //                    hitS = "This is it!"
                        rightRow = ix
                    }
                    //                print("School \(ix): \(sn)   \(hitS)")
                }
            }
        } catch {
            fatalError("Failed to fetch schools: \(error)")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fetchedSchools.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    
// MARK: Picker view delegate
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return fetchedSchools[row].name
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 12)
            pickerLabel?.textAlignment = NSTextAlignment.left
        }
        let pName = fetchedSchools[row].name
        pickerLabel?.text = pName
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(fetchedSchools[row].name)")
    }
}
