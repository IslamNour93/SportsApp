//
//  Events.swift
//  Sports App
//
//  Created by Islam Noureldeen on 28/02/2022.
//

import UIKit
import Alamofire
class EventsTableView: UITableViewController {
    var arrOfLatestEvents = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let idLeague = UserDefaults.standard.object(forKey: "leagueID") else {return}
        getLatestEventsData(idLeague: idLeague as! String, completed: loadData)
        loadData(arrOfLatestEvents)
        tableView.separatorStyle = .none
        tableView.register(UpComingTableViewCell.nib(), forCellReuseIdentifier: UpComingTableViewCell.identifier)
        tableView.register(LatestTableCell.nib(), forCellReuseIdentifier: LatestTableCell.identifier)
        tableView.register(TeamsTableCell.nib(), forCellReuseIdentifier: TeamsTableCell.identifier)
    }
    
    func getLatestEventsData(idLeague:String,completed:@escaping([Event])->Void){
        
        let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/eventsround.php?id=\(idLeague)&r=21&s=2021-2022#"
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
            self.arrOfLatestEvents = data
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 240
        case 1:
            return 175
            
        case 2:
            return 175
        default:
            return 100
            
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return arrOfLatestEvents.count
        case 2:
            return 1

        default:
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Upcoming Events"
        case 1:
            return "Latest Events"
        case 2:
            return "Teams"

        default:
            return ""
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {

        case 0:
            let upcomingCell = tableView.dequeueReusableCell(withIdentifier: UpComingTableViewCell.identifier, for: indexPath) as! UpComingTableViewCell
            return upcomingCell

        case 1:
            let latestCell = tableView.dequeueReusableCell(withIdentifier: LatestTableCell.identifier, for: indexPath) as! LatestTableCell
            let latestEvent = arrOfLatestEvents[indexPath.row]
            latestCell.latestEventImage.layer.cornerRadius = 25
            latestCell.latestEventImage.layer.shadowColor = UIColor.black.cgColor
            latestCell.latestEventImage.layer.borderWidth = 1.5
            latestCell.latestEventImage.layer.shadowOpacity = 100
            latestCell.latestEventImage.sd_setImage(with: URL(string: latestEvent.strThumb!), completed: nil)
            latestCell.latestHomeLabel.text = latestEvent.strHomeTeam
            latestCell.latestAwayLabel.text = latestEvent.strAwayTeam
            latestCell.latestDateLabel.text = latestEvent.dateEvent
            latestCell.latestTimeLabel.text = latestEvent.strTime
            return latestCell
            
        case 2:
            let teamsCell = tableView.dequeueReusableCell(withIdentifier: TeamsTableCell.identifier, for: indexPath) as! TeamsTableCell
            teamsCell.teamDelegate = self
            
            return teamsCell
        default:
           
            return UITableViewCell()
        }
    }
}

extension EventsTableView : TeamProtocol{
    func getTeam(team: Team) {
        
        let teamDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetails
        teamDetailsVC.teamObj = team
        present(teamDetailsVC, animated: true, completion: nil)
    }
    
    
    
}
