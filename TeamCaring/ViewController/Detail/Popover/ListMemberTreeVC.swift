//
//  ListMemberTreeVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/4/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ListMemberTreeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 95)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberListCViewCellId", for: indexPath as IndexPath) as! MemberListCViewCell
        cell.layer.cornerRadius = 5.0
        cell.lbLevel.layer.cornerRadius = 10.0
        cell.lbLevel.layer.masksToBounds = true
//        let urlImg = ""
//        cell.imgAvata.setBackgroundImage(UIImage.image(fromURL: urlImg, placeholder: UIImage(named: "Avata")!, shouldCacheImage: true) { (image) in
//            cell.imgAvata.setBackgroundImage(nil, for: .normal)
//            cell.imgAvata.setBackgroundImage(image, for: .normal)
//        }, for: .normal)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
