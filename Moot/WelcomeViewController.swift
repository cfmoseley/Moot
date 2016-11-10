//
//  WelcomeViewController.swift
//  Moot
//
//  Created by Colin Moseley on 8/24/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {
    
    var fetchedSchools: [School] = []
    
    let apd = UIApplication.shared.delegate as! AppDelegate

    //Schools data
    let sNames = ["Pacific School of Law", "Winnebago Law School", "Atlantic Law School", "Excelsior School of Law", "Tragically Hip Academy", "Habitant School of Law", "Maisonneuve Law School"]
    let sCities = ["Vancouver", "Winnipeg", "Halifax", "Toronto", "Kingston", "Montreal", "Quebec City"]
    let sProvinces = ["BC", "MB", "NS", "ON", "ON", "QC", "QC"]
    
    //Judges data
    let jFirstNames = ["Jacques", "Harry"]
    let jLastNames = ["Benoit", "Mcgillicuddy"]
    let jCities = ["Quebec City", "Toronto"]
    let jProvinces = ["QC", "ON"]
    let jFrenchSpeakings = [1, 0]

    //Mooters data
    let mFirstNames = ["Douglas", "Richard", "Stephen", "Ollie", "Vincent", "Frances", "Ullah", "George", "Wallace", "Pauline", "Nicholas", "Zippy", "Gabriella", "Yarmina", "Xiomara", "Andrew", "Francois", "Tilly", "Kevin", "Bruce", "Margaret", "Harold", "Lawrence", "Quincy", "Evan", "Ian", "William", "Winnifred"]
    let mLastNames = ["Dewitt", "Robertson", "Suliman", "Overman", "Valance", "Fellows", "Underwood", "Goodfellow", "West", "Petersen", "Newman", "Zeffernon", "Gillard", "Yellowfellow", "Xiphiman", "Anderson", "Charlebois", "Torrance", "Karol", "Bourbois", "Michelmas", "Houseman", "Livermore", "Quarterman", "Ewing", "Ivanovitch", "Johnson", "Wiliams"]
    let mLanguages = ["E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "F", "E", "E", "E", "F", "E", "E", "F", "E", "F", "F", "F", "F", "E", "E", "E"]
    let mNeedsIIs = [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0]
    let mSides = ["A", "A", "R", "R", "A", "A", "R", "R", "A", "A", "R", "R", "A", "A", "R", "R", "A", "A", "R", "R", "A", "A", "R", "R", "A", "A", "R", "R"]
    let mRanks = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    let mSchoolNames = ["Atlantic Law School", "Atlantic Law School", "Atlantic Law School", "Atlantic Law School", "Pacific School of Law", "Pacific School of Law", "Pacific School of Law", "Pacific School of Law", "Excelsior School of Law", "Excelsior School of Law", "Excelsior School of Law", "Excelsior School of Law", "Tragically Hip Academy", "Tragically Hip Academy", "Tragically Hip Academy", "Tragically Hip Academy", "Maisonneuve Law School", "Maisonneuve Law School", "Maisonneuve Law School", "Maisonneuve Law School", "Habitant School of Law", "Habitant School of Law", "Habitant School of Law", "Habitant School of Law", "Winnebago Law School", "Winnebago Law School", "Winnebago Law School", "Winnebago Law School"]

    @IBAction func doLoadData(_ sender: UIButton) {
        print("Would load data")
        
        //Add schools
        let moc = apd.managedObjectContext
        let entSchool = NSEntityDescription.entity(forEntityName: "School", in: moc)
        for sIx in (0..<sNames.count) {
            let school = School(entity: entSchool!, insertInto: moc)
            
            school.name = sNames[sIx]
            school.city = sCities[sIx]
            school.province = sProvinces[sIx]
            print("Saving school: \(sNames[sIx])")
            
            apd.saveContext()
        }
        
        //Add judges
        let entJudge = NSEntityDescription.entity(forEntityName: "Judge", in: moc)
        for jIx in (0..<jFirstNames.count) {
            let judge = Judge(entity: entJudge!, insertInto: moc)
            
            judge.firstName = jFirstNames[jIx]
            judge.lastName = jLastNames[jIx]
            judge.city = sCities[jIx]
            judge.province = sProvinces[jIx]
            judge.frenchSpeaking = jFrenchSpeakings[jIx] as NSNumber?
            print("Saving judge: \(jLastNames[jIx])")
            
            apd.saveContext()
        }

        //Add mooters
        fetchSchools()
        let entMooter = NSEntityDescription.entity(forEntityName: "Mooter", in: moc)
        for mIx in (0..<mFirstNames.count) {
            let mooter = Mooter(entity: entMooter!, insertInto: moc)
            
            mooter.firstName = mFirstNames[mIx]
            mooter.lastName = mLastNames[mIx]
            mooter.side = mSides[mIx]
            mooter.rank = mRanks[mIx] as NSNumber?
            mooter.language = mLanguages[mIx]
            mooter.needsII = mNeedsIIs[mIx] as NSNumber?
            for s in fetchedSchools {
                if s.name! == mSchoolNames[mIx] {
                    mooter.school = s
                    break
                }
            }

            print("Saving mooter: \(mLastNames[mIx])")
            
            apd.saveContext()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSchools() {
        let moc = apd.managedObjectContext
        
        let schoolsFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "School")
        schoolsFetch.fetchBatchSize = 30
        let sortDescriptor1 = NSSortDescriptor(key: "province", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
        schoolsFetch.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            fetchedSchools = try moc.fetch(schoolsFetch) as! [School]
        } catch {
            fatalError("Failed to fetch schools: \(error)")
        }
    }
    

}
