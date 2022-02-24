//
//  LeaguesVc.swift
//  Sports App
//
//  Created by Islam Noureldeen on 23/02/2022.
//

import UIKit
import Alamofire


class LeaguesVc: UIViewController {
    
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/all_leagues.php"
    var arrOfLeague : [LeagueApi]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLeagueData()
        tableView.dataSource = self
    }
    
    private func getLeagueData(){
        
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
            response in switch response.result{
            case.failure(_):
                print("error")
            case.success(_):
                guard let data = response.data else{return}
                do{
                let json = try JSONDecoder().decode(Leagues.self, from: data)
                    self.arrOfLeague = json.leagues!
                    print(json.leagues?.first?.strLeague! as Any)
                
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension LeaguesVc :UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfLeague.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! LeagueTableViewCell
        
        cell.leagueLabel.text = "islam"
        
        return cell
    }
    
    
   
}
