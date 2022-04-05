//
//  LeagueTableViewCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 23/02/2022.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var leagueView: UIView!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var leagueLabel: UILabel!
    
    @IBOutlet weak var leagueIcon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        leagueView.frame = leagueView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
 

}
