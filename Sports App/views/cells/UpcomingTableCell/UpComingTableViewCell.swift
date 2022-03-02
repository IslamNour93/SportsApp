//
//  UpComingTableView.swift
//  Sports App
//
//  Created by Islam Noureldeen on 28/02/2022.
//

import UIKit
import Alamofire
import SDWebImage
class UpComingTableViewCell: UITableViewCell{
    
    @IBOutlet weak var upComingCollectionView: UICollectionView!
    static let identifier = "UpComingTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "UpComingTableViewCell", bundle: nil)
    }
    var arrOfEvents: [Event] = []
    var leagueId = UserDefaults.standard.object(forKey: "leagueID")
    
    override func awakeFromNib() {
        super.awakeFromNib()

        upComingCollectionView.dataSource = self
        upComingCollectionView.delegate = self
        upComingCollectionView.register(UpcomingCollectionCell.nib(), forCellWithReuseIdentifier: UpcomingCollectionCell.identifier)

        getEventsData(idLeague: leagueId as! String, completed: loadData)
        
        loadData(arrOfEvents)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getEventsData(idLeague:String,completed:@escaping([Event])->Void){
        
        let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/eventsround.php?id=\(idLeague)&r=38&s=2021-2022#"
        guard let url = URL(string: jsonUrlString) else {return}
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
            response in switch response.result{
            case.failure(_):
                print("error")
            case.success(_):
                guard let data = response.data else{return}
                do{
                let json = try JSONDecoder().decode(UpCommingModel.self, from: data)
                    guard let resultArr = json.events else{ return }
                    completed(resultArr)
                }
                catch {
                    print(error.localizedDescription)
                }
               
            }
        }
    }
    
    func loadData(_ data:[Event]) -> Void {
        DispatchQueue.main.async {
            self.arrOfEvents = data
            print(self.arrOfEvents.count)
            self.upComingCollectionView.reloadData()
           
        }
    }
}
extension UpComingTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrOfEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let event = arrOfEvents[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingCollectionCell.identifier, for: indexPath) as! UpcomingCollectionCell
        
        cell.upcomingPosterView.sd_setImage(with: URL(string: event.strThumb!), completed: nil)
        cell.HomeTeamLabel.text = event.strHomeTeam
        cell.awayTeamLabel.text = event.strAwayTeam
        cell.eventDateLabel.text = event.dateEvent
        cell.eventTimeLabel.text = event.strTime
        cell.upcomingPosterView.layer.cornerRadius = 22
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
    UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.frame.width, height: 240)
    }
 
}
