//
//  TeamDetails.swift
//  Sports App
//
//  Created by Islam Noureldeen on 01/03/2022.
//

import UIKit
import SDWebImage

class TeamDetails: UIViewController {


    var teamObj : Team?
    
    @IBAction func twitterButton(_ sender: Any) {
    }
    
    @IBAction func facebookButton(_ sender: Any) {
    }
    @IBAction func instagramButton(_ sender: Any) {
    }
    @IBAction func youtubeButton(_ sender: Any) {
    }
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var descripView: UIView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var kitImage: UIImageView!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var stadiumImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUi()
        
        
    }
    
    private func updateUi(){
        
        teamName.text = teamObj?.strTeam
        stadiumImage.sd_setImage(with: URL(string: (teamObj?.strStadiumThumb)!))
        teamImage.sd_setImage(with: URL(string: (teamObj?.strTeamBadge)!), completed: nil)
        kitImage.sd_setImage(with: URL(string: (teamObj?.strTeamJersey)!), completed: nil)
        descriptionField.text = teamObj?.strDescriptionEN
        backGroundImage.sd_setImage(with: URL(string: (teamObj?.strTeamFanart4!)!), completed: nil)
        descripView.layer.borderWidth = 0.3
        descripView.layer.borderColor = UIColor.black.cgColor
        descripView.layer.shadowColor = UIColor.black.cgColor
        descripView.layer.shadowOpacity = 20
        descripView.layer.cornerRadius = 25
        descriptionField.layer.cornerRadius = 25
        descriptionField.isEditable = false
    }

   

}
