//
//  Network.swift
//  Sports App
//
//  Created by Islam Noureldeen on 02/03/2022.
//

import Foundation
import Alamofire
class NetworkServices {
    
    static func getSportsData(completion:@escaping([SportApi])->Void){
        
        let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/all_sports.php#"
        let url = URL(string: jsonUrlString)
       
       AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
           response in switch response.result{
           case.failure(_):
               print("error")
           case.success(_):
               guard let data = response.data else{
                   return
               }
               do{
               let json = try JSONDecoder().decode(Sports.self, from: data)
                   guard let resultArr = json.sports else{return}
                   completion(resultArr)
               }
               catch {
                   print(error.localizedDescription)
               }
           }
       }
    }
    
    
    static  func getLeagueData(strSport:String,completion:@escaping([Country])->Void){
        
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
                    completion(resultArr)
                }
                catch {
                    print(error.localizedDescription)
                }

            }
        }
    }
    //MARK:- get Latest Events Data from Api
    static func getLatestEventsData(idLeague:String,completion:@escaping([Event])->Void){
        
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
                    completion(resultArr)
                }
                catch {
                    print(error.localizedDescription)
                }
               
            }
        }
    }
    
   static func getUpcomingData(idLeague:String,completed:@escaping([Event])->Void){
        
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
    
  static func getTeamsData(completed:@escaping([Team])->Void){
        
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
    
}
