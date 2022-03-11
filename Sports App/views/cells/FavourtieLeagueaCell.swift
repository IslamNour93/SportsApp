//
//  FavourtieLeagueaCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 02/03/2022.
//

import UIKit

class FavourtieLeagueaCell: UITableViewCell {

    @IBOutlet weak var favouriteYoutubeButton: UIButton!
    @IBOutlet weak var favouriteLeagueName: UILabel!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var favouriteLeagueImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
