//
//  UpcomingCollectionCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 28/02/2022.
//

import UIKit

class UpcomingCollectionCell: UICollectionViewCell {

    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var HomeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var upcomingPosterView: UIImageView!
    
    static let identifier = "UpcomingCollectionCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "UpcomingCollectionCell", bundle: nil)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
