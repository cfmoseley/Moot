//
//  SchoolCellTableViewCell.swift
//  Moot
//
//  Created by Colin Moseley on 8/21/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//

import UIKit
import CoreGraphics

class SchoolCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func draw(_ rect: CGRect) {
        //        let context = UIGraphicsGetCurrentContext();
        
        //        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor);
        //        CGContextFillRect(context, self.bounds);
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        //        let secondColor = UIColor(netHex:0x2D5AE3)
        let secondColor = UIColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 0.05)
        gradient.colors = [UIColor.white.cgColor, secondColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
