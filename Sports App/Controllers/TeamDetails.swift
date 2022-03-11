//
//  TeamDetails.swift
//  Sports App
//
//  Created by Islam Noureldeen on 01/03/2022.
//

import UIKit
import SDWebImage
import SafariServices
class TeamDetails: UIViewController {


    var teamObj : Team?
    
    enum SocialMedia {
        case facebook,instagram,youtube,twitter
    }
    
    @IBAction func twitterButton(_ sender: Any) {
        openUrl(social: .twitter)
    }
    
    @IBAction func facebookButton(_ sender: Any) {
        openUrl(social: .facebook)
    }
    @IBAction func instagramButton(_ sender: Any) {
        openUrl(social: .instagram)
    }
    @IBAction func youtubeButton(_ sender: Any) {
        openUrl(social: .youtube)
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
        
        guard let teamObj = teamObj else {
            return
        }

        teamName.text = teamObj.strTeam
        guard let strStadiumThumb = teamObj.strStadiumThumb,let jersey = teamObj.strTeamJersey,let description = teamObj.strDescriptionEN ,let badge = teamObj.strTeamBadge,let fanar = teamObj.strTeamFanart4  else {
            return
        }
        stadiumImage.sd_setImage(with: URL(string: (strStadiumThumb)))
        teamImage.sd_setImage(with: URL(string: badge), completed: nil)
        kitImage.sd_setImage(with: URL(string: jersey), completed: nil)
        descriptionField.text = description
        backGroundImage.sd_setImage(with: URL(string: fanar), completed: nil)
        descripView.layer.borderWidth = 0.3
        descripView.layer.borderColor = UIColor.black.cgColor
        descripView.layer.shadowColor = UIColor.black.cgColor
        descripView.layer.shadowOpacity = 20
        descripView.layer.cornerRadius = 25
        descriptionField.layer.cornerRadius = 25
        descriptionField.isEditable = false
    }

    private func openUrl(social:SocialMedia){
        
        let urlString : String
        switch social {
        case .facebook:
            urlString = (teamObj?.strFacebook)!
        case .instagram:
            urlString = (teamObj?.strInstagram)!
        case .youtube:
            urlString = (teamObj?.strYoutube)!
        case .twitter:
            urlString = (teamObj?.strTwitter)!
        }
        guard let url = URL(string: "https://\(urlString)") else{
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
   

}
