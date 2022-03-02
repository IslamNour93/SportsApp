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
        updateUi()
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
        getLeagueData(strSport: sportName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        
    }
    
    
    func updateUi(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.getLeagueData(strSport: self.sportName)
            self.tableView.stopSkeletonAnimation()
            self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.tableView.reloadData()
        })
    }
    func getLeagueData(strSport:String){
        
        let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/search_all_leagues.php?c=England&s=\(strSport)"
        guard let url = URL(string: jsonUrlString) else {return}
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
            response in switch response.result{
            case.failure(_):
                print("error")
            case.success(_):
                guard let data = response.data else{return}
                do{
                let json = try JSONDecoder().decode(LeagueModel.self, from: data)
                    guard let resultArr = json.countrys else{return}
                    self.arrOfLeague = resultArr
                }
                catch {
                    print(error.localizedDescription)
                }

            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray, secondaryColor: .lightText), animation: nil, transition: .crossDissolve(0.25))
    }
    
    @objc func reachabilityChanged(note: Notification) {

          let reachability = note.object as! Reachability

          switch reachability.connection {
              
          case .wifi:
              print("Reachable Via Wifi")
              
          case .cellular:
              print("Reachable via Cellular")
              
          case .unavailable:
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

        cell.leagueLabel.text = arrOfLeague[indexPath.row].strLeague
        cell.leagueIcon.sd_setImage(with: URL(string: arrOfLeague[indexPath.row].strBadge!))
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 22
        cell.layer.borderWidth = 0.3
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.backgroundColor = .lightText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let eventsVC = self.storyboard?.instantiateViewController(withIdentifier: "eventsTable") as! EventsTableView
        eventsVC.title = "League Details"
        UserDefaults.standard.set(arrOfLeague[indexPath.row].idLeague, forKey: "leagueID")
        UserDefaults.standard.set(arrOfLeague[indexPath.row].strLeague, forKey: "leagueName")
        self.navigationController?.pushViewController(eventsVC, animated: true)
        
    }
   
}
