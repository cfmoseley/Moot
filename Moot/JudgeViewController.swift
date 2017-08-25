//
//  JudgeViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/22/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class JudgeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var vc: JudgesViewController?
    var judge: Judge?
    var rightProvinceRow = 0
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
     @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var pkrProvince: UIPickerView!
    @IBOutlet weak var swFrenchSpeaking: UISwitch!
    
    @IBAction func doSave(_ sender: UIBarButtonItem) {
        print("About to doSave")
        
        if ((txtFirstName.text == "") || (txtLastName.text == "") || (txtCity.text == "")) {
            print("Incomplete entry")
        } else {
            
            let apd = UIApplication.shared.delegate as! AppDelegate
            let moc = apd.managedObjectContext
            
            //Add the school to the moc
            if let _ = judge {
                print("Editing judge")
            } else {
                print("Adding new judge")
                let entJudge = NSEntityDescription.entity(forEntityName: "Judge", in: moc)
                judge = Judge(entity: entJudge!, insertInto: moc)
            }
            judge!.lastName = txtLastName.text
            judge!.firstName = txtFirstName.text
            judge!.city = txtCity.text
            judge!.province = provinces[pkrProvince.selectedRow(inComponent: 0)]
            judge!.frenchSpeaking = swFrenchSpeaking.isOn as NSNumber?
//            print("Saving judge: \(txtFirstName.text!) \(txtLastName.text!), \(txtCity.text!)")
            
            apd.saveContext()
            
            vc!.navigationController!.popViewController(animated: true)
//            print("Saved Judge")
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
        if let _ = judge {
            txtFirstName.text = judge?.firstName
            txtLastName.text = judge?.lastName
            txtCity.text = judge?.city
            pkrProvince.selectRow(rightProvinceRow, inComponent: 0, animated: true)
            swFrenchSpeaking.isOn = (judge?.frenchSpeaking == 1)
        } else {
            txtFirstName.text = ""
            txtLastName.text = ""
            txtCity.text = ""
            pkrProvince.selectRow(0, inComponent: 0, animated: true)
            swFrenchSpeaking.isOn = false
        }
        txtFirstName.becomeFirstResponder()
    }
    
    
    // MARK: Picker view datasource
    func setUpProvinces() {
        for ix in (0..<provinces.count) {
            let sn = provinces[ix]
            //            var hitS = ""
            if sn == judge!.province! {
                //                hitS = "This is it!"
                rightProvinceRow = ix
            }
            //            print("School \(ix): \(sn)   \(hitS)")
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
        print("Selected: \(provinces[row])")
    }
    
}
