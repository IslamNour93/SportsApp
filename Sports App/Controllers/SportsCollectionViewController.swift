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
import ViewAnimator
class SportsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    var sport : String = ""
    let reachability = try! Reachability()
    private var arrOfSports : [SportApi] = []
    let animation = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkServices.getSportsData(completion: loadData)
        loadData(arrOfSports)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
               do{
                 try reachability.startNotifier()
               }catch{
                 print("could not start reachability notifier")
               }
    }

 // Mark:- Private
    
    private func loadData(_ data:[SportApi])->Void{

        DispatchQueue.main.async {
            self.arrOfSports = data
//            let animation = AnimationType.from(direction: .bottom, offset: 300)
//            UIView.animate(views: self.collectionView.visibleCells, animations: [animation] ,duration: 2)
            self.collectionView.reloadData()
            self.animation.isHidden = true
            self.animation.removeFromSuperview()
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
              NetworkServices.getSportsData(completion: loadData)
              loadData(arrOfSports)
          case .cellular:
              print("Reachable via Cellular")
              
          case .unavailable:
              
              setupAnimatation()
              let alert = UIAlertController(title: "Connection Failed", message: "You are not connected with Internet", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
              alert.addAction(okAction)
              present(alert, animated: true, completion: nil)
              print("Network not reachable")
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
        cell.contentMode = .scaleAspectFill
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 22
        cell.layer.borderWidth = 0.3
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.backgroundColor = .lightText
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.497, height: self.view.frame.width*0.45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
//        sport = arrOfSports[indexPath.row].strSport!
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesVC") as! LeaguesVc
        vc.sportName = arrOfSports[indexPath.row].strSport!
        vc.title = "Leagues"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let transEffect = CATransform3DTranslate(CATransform3DIdentity, 0, 250 , -500)
        cell.layer.transform = transEffect
        UIView.animate(withDuration: 0.7) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
}


