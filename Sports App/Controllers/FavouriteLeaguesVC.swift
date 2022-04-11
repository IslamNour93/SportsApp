//
//  FavouriteLeaguesVC.swift
//  Sports App
//
//  Created by Islam Noureldeen on 02/03/2022.
//

import UIKit

class FavouriteLeaguesVC: UIViewController {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var favouriteLeagueTableView: UITableView!
    
    @IBOutlet weak var placeholderImage: UIImageView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrOfFavouriteLeagues = [LeaguesCoreData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLeagues()
        favouriteIsEmpty()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteLeagueTableView.dataSource = self
        favouriteLeagueTableView.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        favouriteLeagueTableView.separatorStyle = .none
        getLeagues()

    }
    
    func getLeagues(){
        do{
            
        arrOfFavouriteLeagues = try context.fetch(LeaguesCoreData.fetchRequest())
            favouriteIsEmpty()
            DispatchQueue.main.async {
                self.favouriteLeagueTableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteLeagueFromFavourite(league:LeaguesCoreData){
        context.delete(league)
        do {
            try context.save()
            getLeagues()
        }
        catch{
            print(error)
        }
    }
    private func favouriteIsEmpty(){
        if arrOfFavouriteLeagues.isEmpty{
            favouriteLeagueTableView.isHidden = true
            placeholderImage.isHidden = false
        }
        else {
          favouriteLeagueTableView.isHidden = false
            placeholderImage.isHidden = true
        }
    }
    
    
}

extension FavouriteLeaguesVC :UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfFavouriteLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavourtieLeagueaCell") as! FavourtieLeagueaCell
        let favouriteLeague = arrOfFavouriteLeagues[indexPath.row]
        cell.favouriteLeagueImage.sd_setImage(with: URL(string: favouriteLeague.leagueBadge!), completed: nil)
        cell.favouriteLeagueName.text = favouriteLeague.leagueName
        cell.favouriteYoutubeButton.addAction(UIAction(handler: { _ in
            if let youtubeStr = favouriteLeague.leagueYoutube {
                UIApplication.shared.open(URL(string: "https://\(youtubeStr)")!, options: [:], completionHandler: nil)}
        }),for: .touchUpInside)
        cell.favouriteView.layer.cornerRadius = 15
        cell.favouriteView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        tableView.beginUpdates()
        let alert = UIAlertController(title: "Delete League", message: "Are you sure you want to delete this League ?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            self.userDefaults.set(false, forKey: "\(self.arrOfFavouriteLeagues[indexPath.row].leagueId!)")
            self.deleteLeagueFromFavourite(league: self.arrOfFavouriteLeagues[indexPath.row])
            self.favouriteLeagueTableView.deleteRows(at: [indexPath], with: .automatic)
            self.favouriteIsEmpty()
            do {
            
                try self.context.save()
            }
            catch{
                print(error)
            }
        }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(arrOfFavouriteLeagues[indexPath.row].leagueId, forKey: "leagueID")
        UserDefaults.standard.set(arrOfFavouriteLeagues[indexPath.row].leagueName, forKey: "leagueName")
        let eventsVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
            present(eventsVC, animated: true, completion: nil)
        
    }
}
