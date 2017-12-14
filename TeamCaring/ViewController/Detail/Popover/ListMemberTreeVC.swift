//
//  ListMemberTreeVC.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/4/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit

class ListMemberTreeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listMems = [Member]()
    var selectedBlock: ((Member) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 95)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberListCViewCellId", for: indexPath as IndexPath) as! MemberListCViewCell
        let info = self.listMems[indexPath.row]
        cell.layer.cornerRadius = 5.0
        cell.lbLevel.layer.cornerRadius = 10.0
        cell.lbLevel.layer.masksToBounds = true
        cell.imgAvata.layer.cornerRadius = 55/2
        cell.imgAvata.layer.masksToBounds = true
        let urlImg = info.imageUrl ?? ""
        cell.imgAvata.setBackgroundImage(UIImage.image(fromURL: urlImg, placeholder: UIImage(), shouldCacheImage: true) { (image) in
            cell.imgAvata.setBackgroundImage(nil, for: .normal)
            cell.imgAvata.setBackgroundImage(image, for: .normal)
        }, for: .normal)
        cell.imgAvata.tag = indexPath.row
        cell.imgAvata.addTarget(self, action:#selector(self.selectedItem), for: .touchUpInside)
        cell.lbLevel.text = "\(info.level?.level ?? 0)"
        return cell
    }
    
    func selectedItem(sender: UIButton!) {
        let index = sender.tag
        if let selectedBlock = self.selectedBlock {
            selectedBlock(self.listMems[index])
        }
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
