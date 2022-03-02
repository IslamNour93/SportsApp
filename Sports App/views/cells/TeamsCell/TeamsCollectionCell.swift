//
//  TeamsCollectionCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 01/03/2022.
//

import UIKit

class TeamsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var teamIcon: UIImageView!

    @IBOutlet weak var teamName: UILabel!
    
    
    
    static let identifier = "TeamsCollectionCell"
    static func nib()->UINib{
        
        return UINib(nibName: "TeamsCollectionCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    
}
