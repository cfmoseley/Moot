//
//  SchoolViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/21/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData


class SchoolViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var vc: SchoolsViewController?
    var school: School?
    var rightProvinceRow = 0

    @IBOutlet weak var lblTitle: UINavigationItem!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var pkrProvince: UIPickerView!
    @IBOutlet weak var vwMooters: UIView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet var lblMooter: [UILabel]!
    
    @IBAction func doSave(_ sender: UIBarButtonItem) {
        print("About to doSave")
        
        if ((txtName.text == "") || (txtCity.text == "")) {
            print("Incomplete entry")
        } else {
            
            let apd = UIApplication.shared.delegate as! AppDelegate
            let moc = apd.managedObjectContext
            
            //Add the school to the moc
            if let _ = school {
//                print("Editing school")
            } else {
//                print("Adding new school")
                let entSchool = NSEntityDescription.entity(forEntityName: "School", in: moc)
                school = School(entity: entSchool!, insertInto: moc)
            }
            school!.name = txtName.text
            school!.city = txtCity.text
            school!.province = provinces[pkrProvince.selectedRow(inComponent: 0)]
            print("Saving school: \(txtName.text!), \(txtCity.text!), \(school!.province!)")
            
            apd.saveContext()
            
            vc!.navigationController!.popViewController(animated: true)
//            print("Saved School")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pkrProvince.delegate = self
        pkrProvince.dataSource = self
       setUpProvinces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let emptyMooter = "----------"
        if let _ = school {
            txtName.text = school?.name
            txtCity.text = school?.city
            pkrProvince.selectRow(rightProvinceRow, inComponent: 0, animated: true)
            vwMooters.isHidden = false
            for l in lblMooter {
                l.text = emptyMooter
            }
            for m in (school?.mooters!)! {
                let mm = m as! Mooter
                let sideInt = (mm.side == "A" ? 0:2)
                let labelIndex = sideInt + mm.rank!.intValue
                //                print("Putting \(thisM.lastName!) in index \(mooterIndex)")
                var ml = mm.language!
                if mm.needsII! == 1 {
                    ml = "\(ml)+"
                }
                let theLabel = lblMooter[labelIndex]
                if theLabel.text == emptyMooter {
                  theLabel.text = "\(mm.lastName!), \(mm.firstName!)    \(ml)"
                } else {
                    theLabel.text = "**** Duplicate ****"
                }
            }
        } else {
            txtName.text = ""
            txtCity.text = ""
            pkrProvince.selectRow(0, inComponent: 0, animated: true)
            vwMooters.isHidden = true
        }
        txtName.isFirstResponder
    }
    
    // MARK: Picker view datasource
    func setUpProvinces() {
        if let _ = school {
            for ix in (0..<provinces.count) {
                let sn = provinces[ix]
                //            var hitS = ""
                if sn == school!.province! {
                    //                hitS = "This is it!"
                    rightProvinceRow = ix
                }
                //            print("School \(ix): \(sn)   \(hitS)")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print("There are \(provinces.count) provinces in the picker")
        return provinces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 17.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 30.0
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
            pickerLabel?.font = UIFont(name: "Calabri", size: 10.0)
            pickerLabel?.textAlignment = NSTextAlignment.left
        }
        let pName = provinces[row]
//        print("Providing \(pName) to picker")
        pickerLabel?.text = pName
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("Selected: \(provinces[row])")
    }
}
