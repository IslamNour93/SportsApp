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
        
        getEventsData(completed: loadData)
        
        loadData(arrOfTeams)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getEventsData(completed:@escaping([Team])->Void){
        
        guard let leagueName = UserDefaults.standard.object(forKey: "leagueName") as? String else{return}
        let replacingString = leagueName.replacingOccurrences(of: " ", with: "%20")
        let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/search_all_teams.php?l=\(replacingString)"
        guard let url = URL(string: jsonUrlString) else {return}
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
            response in switch response.result{
            case.failure(_):
                print("error")
            case.success(_):
                guard let data = response.data else{return}
                do{
                let json = try JSONDecoder().decode(TeamModel.self, from: data)
                    guard let resultArr = json.teams else{ return }
                    completed(resultArr)
                }
                catch {
                    print(error.localizedDescription)
                }
               
            }
        }
    }
    
    func loadData(_ data:[Team]) -> Void {
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
