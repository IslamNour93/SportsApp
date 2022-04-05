//
//  TabViewController.swift
//  Sports App
//
//  Created by Islam Noureldeen on 23/02/2022.
//

import UIKit

class TabViewController: UITabBarController {

    private let imageview : UIImageView = {
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 414, height: 900))
        imageview.image=UIImage(named: "Sports App")
        return imageview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageview)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageview.center=view.center

        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            self.animate()
        })
    }

    func animate(){
        UIView.animate(withDuration: 0.4, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size

            self.imageview.frame = CGRect(x: -(CGFloat(Int(diffX)/2)), y: CGFloat(Int(diffY)/2), width: size, height: size)
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.imageview.alpha=0
        })


    }


}
