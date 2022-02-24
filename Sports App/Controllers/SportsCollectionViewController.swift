//
//  SportsCollectionViewController.swift
//  Sports App
//
//  Created by Islam Noureldeen on 22/02/2022.
//

import UIKit
import Alamofire
import SDWebImage
import CloudKit
import Lottie
import Reachability

class SportsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var selectedIndex = 0
    let reachability = try! Reachability()
    private var arrOfSports : [SportApi] = []
    let animation = AnimationView()
    let jsonUrlString = "https://www.thesportsdb.com/api/v1/json/2/all_sports.php#"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // getSportsData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
               do{
                 try reachability.startNotifier()
               }catch{
                 print("could not start reachability notifier")
               }
    }

 // Mark:- Private
    private func getSportsData(){
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
                   self.arrOfSports = json.sports!
                   for i in 0..<self.arrOfSports.count{
                       print(self.arrOfSports[i].strSport!)
                   }
               }
               catch {
                   print(error.localizedDescription)
               }
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
                   self.animation.isHidden = true
                   
               }
           }
       }
    }
    
    private func setupAnimatation(){
        animation.animation = Animation.named("loading")
        animation.frame = view.bounds
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.play()
       view.addSubview(animation)
    }
    
    
    @objc func reachabilityChanged(note: Notification) {

          let reachability = note.object as! Reachability

          switch reachability.connection {
              
          case .wifi:
              print("Reachable Via Wifi")
              getSportsData()
          case .cellular:
              print("Reachable via Cellular")
              
          case .unavailable:
              print("Network not reachable")
              setupAnimatation()
          case .none:
              print("None")
              
   
          }
        }
    // MARK: UICollectionViewDataSource

override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        
        return arrOfSports.count }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! SportsCollectionViewCell
       
        cell.sportImageView.sd_setImage(with: URL(string: arrOfSports[indexPath.row].strSportThumb!), completed: nil)
            cell.sportNameLabel.text = self.arrOfSports[indexPath.row].strSport
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.493, height: self.view.frame.width*0.45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        let vc = TableViewController()
        present(vc, animated: true, completion: nil)
    }
}


