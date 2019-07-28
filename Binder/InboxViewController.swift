//
//  InboxViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/13/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import FirebaseDatabase
import Firebase

class InboxViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate {
    
    var matchesArray:NSMutableArray = []
    var inboxArray:NSMutableArray = []
    
    @IBOutlet weak var match_label: UILabel!
    
    @IBOutlet weak var shadoview: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    var childRef02 = Database.database().reference().child("Match")
    var childRef03 = Database.database().reference().child("Inbox")

    override func viewDidLoad() {
        super.viewDidLoad()
        
       

       tableview.tableFooterView = UIView()
        
      
        childRef03.child(UserDefaults.standard.string(forKey:"uid")!).observe(.value) { (snapshot) in
            self.inboxArray = []
            
            if snapshot.childrenCount > 0 {
                
                
                if snapshot.exists(){
                    
                    for artists in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        
                        let firebaseDic = artists.value as? [String: AnyObject]
                        
                        
                        print(firebaseDic!)
                       
                        
                        let username = firebaseDic!["name"] as! String
                        
                        let msg = firebaseDic!["msg"] as! String
                        let timestamp = firebaseDic!["date"] as! String
                        let rid = firebaseDic!["rid"] as! String
                        let status = firebaseDic!["status"] as! String
                         let pic = firebaseDic!["pic"] as! String
                        let picture = pic
                        
                        let obj = Inbox(timestamp:timestamp, msg:msg, rid: rid, status:status, picture:picture, username:username)
                       
                            
                            self.inboxArray.add(obj)
                        
                        
                    }
                    
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                    
                }
                
            }
            
            
        }
        
       
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        ShowMatchApi()
    }
    
    
    func ShowMatchApi(){
        
        self.view.isUserInteractionEnabled = false
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"myMatch"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                self.view.isUserInteractionEnabled = true
                
                self.matchesArray = []
                let json  = value
                SliderViewController.removeSpinner(spinner: sv)
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                   
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let match_id = Dict["effect_profile"] as! String
                        let effect_profile_name = Dict["effect_profile_name"] as! NSDictionary
                        let first_name = effect_profile_name["first_name"] as! String
                        let last_name = effect_profile_name["last_name"] as! String
                        let user_name = first_name+" "+last_name
                        
                        let user_image = effect_profile_name["image1"] as! String
                    
                        let obj = Match(match_id:match_id, user_name:user_name,user_image:user_image)
                        
                         self.matchesArray.add(obj)
                    }
                    
                    
                    if(self.matchesArray.count == 0){
                        
                        self.match_label.alpha = 1
                        self.collectionview.delegate = self
                        self.collectionview.dataSource = self
                        self.collectionview.reloadData()
                        
                        }else{
                        self.match_label.alpha = 0
                     self.collectionview.delegate = self
                    self.collectionview.dataSource = self
                    self.collectionview.reloadData()
                        
                    }
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                self.view.isUserInteractionEnabled = true
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    
    
    @IBAction func home(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
        
        
    }
    
    @IBAction func profile(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1    //return number of sections in collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matchesArray.count   //return number of rows in section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell0", for: indexPath as IndexPath) as! MatchCollectionViewCell
        
        let obj = self.matchesArray[indexPath.row] as! Match
        cell.user_img.sd_setImage(with: URL(string:obj.user_image), placeholderImage: UIImage(named: "Unknown"))
        cell.user_img.layer.masksToBounds = false
        cell.user_img.layer.cornerRadius = cell.user_img.frame.height/2
        cell.user_img.clipsToBounds = true
        cell.user_name.text = obj.user_name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = self.matchesArray[indexPath.row] as! Match
        StaticData.singleton.receiver_id = obj.match_id
        StaticData.singleton.receiver_name = obj.user_name
        StaticData.singleton.receiver_img = obj.user_image
        StaticData.singleton.matchORinbox = "match"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
   
            return self.inboxArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:InboxCell = self.tableview.dequeueReusableCell(withIdentifier: "cell01") as! InboxCell
    
            let obj = inboxArray[indexPath.row] as! Inbox
            
            cell.inbox_msg.text = obj.msg
            cell.inbox_name.text = obj.username
            
            let fullNameArr = obj.timestamp.components(separatedBy: " ")
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ssZZ"
            let date = dateFormatter1.date(from:fullNameArr[1])
            dateFormatter1.dateFormat = "hh:mm a"
            cell.inbox_time.text = ""
            cell.inbox_img.layer.masksToBounds = false
            cell.inbox_img.layer.cornerRadius = cell.inbox_img.frame.height/2
            cell.inbox_img.clipsToBounds = true
            cell.inbox_img.sd_setImage(with: URL(string:obj.picture), placeholderImage: UIImage(named: "unknown"))
            cell.inbox_time.text = dateFormatter1.string(from:date!)
            cell.inbox_dot.layer.masksToBounds = false
            cell.inbox_dot.layer.cornerRadius = cell.inbox_dot.frame.height/2
            cell.inbox_dot.clipsToBounds = true
        
            
            
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 111
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.inboxArray[indexPath.row] as! Inbox
        StaticData.singleton.receiver_id = obj.rid
        StaticData.singleton.receiver_name = obj.username
        StaticData.singleton.matchORinbox = "inbox"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            let obj = self.inboxArray[indexPath.row] as! Inbox
            self.childRef03.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.rid).removeValue()
            self.inboxArray.removeObject(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            
            completionHandler(true)
        }
        
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func dropShadow() {
//        self.shadoview.layer.shadowColor = UIColor.lightGray.cgColor
//        self.shadoview.layer.shadowOffset = CGSize(width: 0, height: 3.0)
//        self.shadoview.layer.shadowOpacity = 0.5
//        self.shadoview.layer.shadowRadius = 4
//        self.shadoview.layer.cornerRadius = 2
//        self.shadoview.layer.masksToBounds = false
//
//    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

}


