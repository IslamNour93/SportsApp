//
//  LatestTableCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 28/02/2022.
//

import UIKit
import Alamofire
class LatestTableCell: UITableViewCell {
    
    @IBOutlet weak var latestView: UIView!
    @IBOutlet weak var latestDateLabel: UILabel!
    @IBOutlet weak var latestTimeLabel: UILabel!
    @IBOutlet weak var latestScoreLabel: UILabel!
    @IBOutlet weak var latestHomeLabel: UILabel!
    @IBOutlet weak var latestEventImage: UIImageView!
    @IBOutlet weak var latestAwayLabel: UILabel!
    static let identifier = "LatestTableCell"
    static func nib()->UINib{
        
    return  UINib(nibName: "LatestTableCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
