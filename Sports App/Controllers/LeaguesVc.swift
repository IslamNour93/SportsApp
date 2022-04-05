//
//  LeaguesVc.swift
//  Sports App
//
//  Created by Islam Noureldeen on 23/02/2022.
//

import UIKit
import Alamofire
import Reachability
import SDWebImage
import SkeletonView

class LeaguesVc: UIViewController {
    
    let sportsVc = SportsCollectionViewController()
    let reachability = try! Reachability()
    var arrOfLeague : [Country] = []
    var sportName = ""
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData(arrOfLeague)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
               do{
                 try reachability.startNotifier()
               }catch{
                 print("could not start reachability notifier")
               }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
    }
    
    
    func loadData(_ data:[Country]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.arrOfLeague = data
//            self.tableView.stopSkeletonAnimation()
//            self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.tableView.reloadData()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray, secondaryColor: .lightText), animation: nil, transition: .crossDissolve(0.25))
    }
    
    @objc func reachabilityChanged(note: Notification) {

          let reachability = note.object as! Reachability

          switch reachability.connection {
              
          case .wifi:
              print("Reachable Via Wifi")
              NetworkServices.getLeagueData(strSport: sportName, completion: loadData)
              loadData(arrOfLeague)
          case .cellular:
              print("Reachable via Cellular")
              
          case .unavailable:
              print("Network not reachable")
              let alert = UIAlertController(title: "Connection Failed", message: "You are not connected with Internet", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
              alert.addAction(okAction)
              present(alert, animated: true, completion: nil)
              print("Network not reachable")
          case .none:
              print("None")
          }
        }
    
}

extension LeaguesVc :SkeletonTableViewDataSource,UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfLeague.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueTableViewCell

        cell.leagueLabel.text = arrOfLeague[arrOfLeague.count-indexPath.row-1].strLeague
        cell.leagueIcon.sd_setImage(with: URL(string: arrOfLeague[arrOfLeague.count-indexPath.row-1].strBadge!))
        cell.youtubeButton.addAction(UIAction(handler: { _ in
            if let youtubeStr = self.arrOfLeague[self.arrOfLeague.count-indexPath.row-1].strYoutube {
                UIApplication.shared.open(URL(string: "https://\(youtubeStr)")!, options: [:], completionHandler: nil)}
        }), for: .touchUpInside)
        cell.leagueView.layer.cornerRadius = 15
        cell.leagueView.layer.masksToBounds = true
        cell.leagueView.layer.borderWidth = 0.3
        cell.leagueView.layer.borderColor = UIColor.black.cgColor
        cell.leagueView.layer.shadowOpacity = 4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let league = arrOfLeague[arrOfLeague.count-indexPath.row-1]
        let eventsVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
        eventsVC.title = "League Details"
        eventsVC.league = league
        UserDefaults.standard.set(arrOfLeague[arrOfLeague.count-indexPath.row-1].idLeague, forKey: "leagueID")
        UserDefaults.standard.set(arrOfLeague[arrOfLeague.count-indexPath.row-1].strLeague, forKey: "leagueName")
        self.navigationController?.pushViewController(eventsVC, animated: true)
        
    }
   
}
