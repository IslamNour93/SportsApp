//
//  EventsViewController.swift
//  Sports App
//
//  Created by Islam Noureldeen on 02/03/2022.
//

import UIKit
import Alamofire
import SDWebImage
import CoreData


class EventsViewController: UIViewController {

    var favouriteBtnIsPressed = false
    var league : Country?
    var arrOfLatestEvents = [Event]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userDefaults = UserDefaults.standard
    var arrOfFavoritesCoreData = [LeaguesCoreData]()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    @IBOutlet weak var favouriteBtnOutlet: UIBarButtonItem!
    
    @IBAction func favouriteButton(_ sender: Any) {
        guard let league = league else {
            return
        }

        
        if userDefaults.bool(forKey: league.idLeague!)==false{
            favouriteBtnIsPressed = true
            userDefaults.set(favouriteBtnIsPressed, forKey: "\(league.idLeague!)")
            print(userDefaults.bool(forKey: "\(league.idLeague!)"))
            print("fav button pressed successfully")
            addLeagueToCoreData()
            showToast(message: "League has been added to Favourites", font: .boldSystemFont(ofSize: 15))
            favouriteBtnOutlet.image = UIImage(systemName: "heart.fill")
            
        }
        else{
            favouriteBtnIsPressed = false
            print("league has been removed")
            removeFromFavoritesBybutton()
            showToast(message: "League has been removed from Favourites", font: .boldSystemFont(ofSize: 15))
            userDefaults.set(favouriteBtnIsPressed, forKey: "\(league.idLeague!)")
            print(userDefaults.bool(forKey: "\(league.idLeague!)"))
            favouriteBtnOutlet.image = UIImage(systemName: "heart")
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let league = league else {
            return
        }

        if !userDefaults.bool(forKey: "\(league.idLeague!)"){
            favouriteBtnOutlet.image = UIImage(systemName: "heart")
            favouriteBtnOutlet.customView?.isUserInteractionEnabled = true
        }
        else {
            favouriteBtnOutlet.image = UIImage(systemName: "heart.fill")
            favouriteBtnOutlet.customView?.isUserInteractionEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.showsVerticalScrollIndicator = false
        guard let idLeague = UserDefaults.standard.object(forKey: "leagueID") else {return}
        NetworkServices.getLatestEventsData(idLeague: idLeague as! String, completion: loadData)
        loadData(arrOfLatestEvents)
        eventsTableView.separatorStyle = .none
        eventsTableView.register(UpComingTableViewCell.nib(), forCellReuseIdentifier: UpComingTableViewCell.identifier)
        eventsTableView.register(LatestTableCell.nib(), forCellReuseIdentifier: LatestTableCell.identifier)
        eventsTableView.register(TeamsTableCell.nib(), forCellReuseIdentifier: TeamsTableCell.identifier)
    getLeagues()
    }
    
    
   private func loadData(_ data:[Event]) -> Void {
       self.arrOfLatestEvents = data
       DispatchQueue.main.async {
            self.eventsTableView.reloadData()
        }
    }
    
 private func addLeagueToCoreData(){
        let favouriteLeague = LeaguesCoreData(context: context)
        favouriteLeague.leagueName = league?.strLeague
        favouriteLeague.leagueBadge = league?.strBadge
        favouriteLeague.leagueYoutube = league?.strYoutube
        favouriteLeague.leagueId = league?.idLeague 
        
        do{
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
   private func getLeagues(){
        do{
            
        arrOfFavoritesCoreData = try context.fetch(LeaguesCoreData.fetchRequest())
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeFromFavoritesBybutton(){
        
            do{
                self.arrOfFavoritesCoreData = try context.fetch(LeaguesCoreData.fetchRequest())
                for i in 0..<arrOfFavoritesCoreData.count{
                    guard let league = league else {
                        return
                    }

                    if  league.strLeague == arrOfFavoritesCoreData[i].leagueName{
                        context.delete(arrOfFavoritesCoreData[i])
                        try context.save()
                    }
                }
            }catch{
                print(error)
            }
            
    }
  private  func showToast(message : String, font: UIFont) {

            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-200, y: self.view.frame.size.height-200, width: 400, height: 40))
            toastLabel.backgroundColor = UIColor.gray
            toastLabel.textColor = UIColor.black
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.layer.cornerRadius = 8;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.4, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
}

extension EventsViewController: UITableViewDelegate,UITableViewDataSource,TeamProtocol{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
            
        case 0:
            return 175
        case 1:
            return 240
        case 2:
            return 175
            
        default:
            return 100
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return arrOfLatestEvents.count

        default:
            return 1
        }
        
    }
            
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
          let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
            headerView.backgroundColor = .systemBackground
            var headerSection : String = ""
            switch section {
            case 0:
                headerSection = "Teams"
            case 1:
                headerSection = "Upcoming Events"
            case 2:
                headerSection = "Latest Events"
            default:
                headerSection="Events"
            }
            headerView.backgroundColor = .systemBackground
            let header = UILabel(frame: CGRect(x: 10, y: -8, width: tableView.bounds.size.width, height: 25))
            header.text=headerSection
            header.textColor =  .secondaryLabel
            header.font = .boldSystemFont(ofSize: 22)
            headerView.addSubview(header)
          
          return headerView
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {

        case 0:
            let teamsCell = tableView.dequeueReusableCell(withIdentifier: TeamsTableCell.identifier, for: indexPath) as! TeamsTableCell
            teamsCell.teamDelegate = self
            
            return teamsCell
        case 1:
            let upcomingCell = tableView.dequeueReusableCell(withIdentifier: UpComingTableViewCell.identifier, for: indexPath) as! UpComingTableViewCell
            return upcomingCell

        case 2:
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
            latestCell.homeScoreLabel.text = latestEvent.intHomeScore
            latestCell.awayScoreLabel.text = latestEvent.intAwayScore
            return latestCell
            
       
        default:
           
            return UITableViewCell()
        }
    }

    func getTeam(team: Team) {
        let teamDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetails
        teamDetailsVC.teamObj = team
        present(teamDetailsVC, animated: true, completion: nil)
    }
    
    
    
}
