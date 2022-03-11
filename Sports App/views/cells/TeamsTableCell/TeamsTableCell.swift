//
//  TeamsTableCell.swift
//  Sports App
//
//  Created by Islam Noureldeen on 01/03/2022.
//

import UIKit
import Alamofire
import SDWebImage
class TeamsTableCell: UITableViewCell {


    
    @IBOutlet weak var TeamsCollectionView: UICollectionView!
    var teamDelegate : TeamProtocol?
    
    static let identifier = "TeamsTableCell"
    var arrOfTeams = [Team]()
    static func nib()->UINib{
        return UINib(nibName: "TeamsTableCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TeamsCollectionView.register(TeamsCollectionCell.nib(), forCellWithReuseIdentifier: TeamsCollectionCell.identifier)
        TeamsCollectionView.delegate = self
        TeamsCollectionView.dataSource = self
        
        NetworkServices.getTeamsData(completed: loadData)
        
        loadData(arrOfTeams)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
   private func loadData(_ data:[Team]) -> Void {
        DispatchQueue.main.async {
            self.arrOfTeams = data
            print(self.arrOfTeams.count)
            self.TeamsCollectionView.reloadData()
        }
    }
}

extension TeamsTableCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrOfTeams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let team = arrOfTeams[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamsCollectionCell.identifier, for: indexPath) as! TeamsCollectionCell
        guard team.strTeamBadge != nil else{return cell}
        cell.teamIcon.sd_setImage(with: URL(string: team.strTeamBadge!), completed: nil)
        cell.teamName.text = team.strTeam
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
    UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 150, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        teamDelegate?.getTeam(team: arrOfTeams[indexPath.row])
    }
}
