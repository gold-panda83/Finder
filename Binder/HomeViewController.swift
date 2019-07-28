//
//  HomeViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/6/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

import Alamofire
import SDWebImage
import FirebaseDatabase
import Firebase
import Pulsator
import CoreLocation
import Hero
import Koloda
import CoreLocation
import AlamofireImage

class HomeViewController: UIViewController,CLLocationManagerDelegate,CAAnimationDelegate{

    
    @IBOutlet weak var shadowimage: UIImageView!
    
    var locationManager:CLLocationManager!
    
    
    var sampleCards = [Card]()
    
    var inn:Int! = 0
   
  
    @IBOutlet weak var brn_allow: UIButton!
    
    var nearArray:NSMutableArray = []
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var cancel_btn: UIButton!
    var currentIndex:Int! = 0
    var lastIndex:Int! = 0
    
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var refresh_btn: UIButton!
    
    @IBOutlet weak var myImage: UIImageView!
    var childRef1 = Database.database().reference().child("Match")
    
   var image2 = UIImageView()
    
    @IBOutlet weak var myview: KolodaView!
    
    
    @IBOutlet weak var innerview: UIView!
    
    
    @IBOutlet weak var backbutton: UIBarButtonItem!
    
    
    
    @IBOutlet weak var pulsateView: UIView!
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
       
        self.dropShadow()
        
        
        if(UserDefaults.standard.string(forKey:"lat") != "" && UserDefaults.standard.string(forKey:"lat") != nil){
            
            self.innerview.alpha = 0
            self.ShowPeopleApi()
        }
        
        
        
        self.determineMyCurrentLocation()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
       
   
        myImage.layer.masksToBounds = false
        myImage.layer.cornerRadius = myImage.frame.height/2
        myImage.clipsToBounds = true
        
       
        let myImage11 = UserDefaults.standard.string(forKey:"image_url")!
        self.myImage.sd_setImage(with: URL(string:myImage11), placeholderImage: UIImage(named: "Unknown"))
        
        if(UserDefaults.standard.string(forKey:"DeviceToken") == nil){
            
            UserDefaults.standard.set("abc", forKey: "DeviceToken")
        }
        Database.database().reference().child("Users").child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(["token":UserDefaults.standard.string(forKey:"DeviceToken")!])
        
    
        
       
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        myImage.isUserInteractionEnabled = true
//        myImage.addGestureRecognizer(tapGestureRecognizer)
    }
    

    
    
    func determineMyCurrentLocation() {
        
        UserDefaults.standard.set("", forKey:"lat")
        UserDefaults.standard.set("", forKey:"lon")
        
       
        
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("filename.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            
            
            let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
            //set image for button
            button.setImage(UIImage(contentsOfFile: filePath), for: .normal)
            //add function for button
            button.addTarget(self, action:#selector(actionWithoutParam), for: .touchUpInside)
            //set frame
            button.frame = CGRect(x:0, y:0, width:31 , height:31)
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.widthAnchor.constraint(equalToConstant: 31).isActive = true
            button.heightAnchor.constraint(equalToConstant: 31).isActive = true
            
            
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.leftBarButtonItem = barButton
        }else{
            
           
            let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
            //set image for button
            button.setImage(UIImage(named:"Unknown"), for: .normal)
            
            Alamofire.request(UserDefaults.standard.string(forKey:"image_url")!).responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    
                    do {
                        
                        button.setImage(image, for: .normal)
                    
                } catch { }
            }
        }
            //add function for button
            button.addTarget(self, action:#selector(actionWithoutParam), for: .touchUpInside)
            //set frame
            button.frame = CGRect(x:0, y:0, width:31 , height:31)
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.widthAnchor.constraint(equalToConstant: 31).isActive = true
            button.heightAnchor.constraint(equalToConstant: 31).isActive = true
            
            
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.leftBarButtonItem = barButton
            
            
        }
       
        
       
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // use the feature only available in iOS 9
        // for ex. UIStackView
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                locationManager.startUpdatingLocation()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                
            }
            
        } else {
            print("Location services are not enabled")
            print("location")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey:"lat")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey:"lon")
 
        manager.stopUpdatingLocation()
        
        
    }
    
    @IBAction func allowlocation(_ sender: Any) {
        
        if(UserDefaults.standard.string(forKey:"lat") == ""){
            
            let alertController = UIAlertController(title: NSLocalizedString("Finder", comment: ""), message: NSLocalizedString("Please enable your location.", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            self.innerview.alpha = 0
            self.ShowPeopleApi()
            
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
    
        self.ShowPeopleApi()
    }
    
    @objc func actionWithoutParam(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let controller = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
     
        
        let transition = CATransition.init()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push //Transition you want like Push, Reveal
        transition.subtype = CATransitionSubtype.fromLeft // Direction like Left to Right, Right to Left
        transition.delegate = self
        
        self.navigationController?.view!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: true)
        //...
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let pulsator = Pulsator()
        myImage.layer.superlayer?.insertSublayer(pulsator, below: self.myImage.layer)
        pulsator.position = self.myImage.layer.position
        pulsator.numPulse = 3
        pulsator.radius = 150.0
        pulsator.backgroundColor = UIColor(red:253/252, green: 98/252, blue:94/252, alpha: 1).cgColor
        pulsator.start()
        
        if(StaticData.singleton.reloadOrnot == "true"){
            
            StaticData.singleton.reloadOrnot = "false"
           // self.sampleCards = []
            
            self.ShowPeopleApi()
        }
        
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        
    }
   
    
    
    func ShowPeopleApi(){

   
        self.refresh_btn.alpha = 0
        self.cancel_btn.alpha = 0
        self.fav_btn.alpha = 0
        self.pulsateView.alpha = 1
        self.shadowimage.alpha = 0
        self.myview.alpha = 0
    
        let url : String = StaticData.singleton.baseUrl!+"userNearByMe"
        
        var floatVersion:String! = "1.0"
        
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("iOS\(String(describing: text))")
            floatVersion = text
            
        }
        
    
        
        if(UserDefaults.standard.string(forKey: "gender") == nil || UserDefaults.standard.string(forKey: "gender") == "") {
            
            UserDefaults.standard.set("men", forKey:"gender")
        }
        
        if(UserDefaults.standard.string(forKey: "age") == nil || UserDefaults.standard.string(forKey: "age") == "") {
            
            UserDefaults.standard.set("75", forKey:"age")
        }
        
        if(UserDefaults.standard.string(forKey: "distance") == nil || UserDefaults.standard.string(forKey: "distance") == "") {
            
            UserDefaults.standard.set("1000", forKey:"distance")
        }
       
       
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"lat_long":UserDefaults.standard.string(forKey:"lat")!+","+UserDefaults.standard.string(forKey:"lon")!,"device":"iOS","distance":UserDefaults.standard.string(forKey: "distance")!,"age_range":UserDefaults.standard.string(forKey: "age")!,"gender":UserDefaults.standard.string(forKey: "gender")!,"version":floatVersion!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
              
                //self.nearArray = []
                //self.sampleCards = []
                self.view.isUserInteractionEnabled = true
                
                let json  = value
                //activityIndicatorView.stopAnimating()
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let fb_id = Dict["fb_id"] as! String
                        let about_me = Dict["school"] as! String
                        let birthday = Dict["birthday"] as! String
                        let distance = Dict["distance"] as! String
                        let last_name = Dict["last_name"] as! String
                        if let block = Dict["block"] as? String{
                        if(block == "1"){
                            
                            UserDefaults.standard.set("", forKey:"email")
                            UserDefaults.standard.set("", forKey:"uid")
                            
                            UserDefaults.standard.set("", forKey:"first_name")
                            UserDefaults.standard.set("", forKey:"last_name")
                            UserDefaults.standard.set("", forKey:"Username")
                            UserDefaults.standard.set("", forKey:"image_url")
                            
                            self.performSegue(withIdentifier:"hometologin", sender: self)
                            
                        }
                        }
                        let first_name = Dict["first_name"] as! String
                        let gender = Dict["gender"] as! String
                        let image1 = Dict["image1"] as! String
                        let image2 = Dict["image2"] as! String
                        let image3 = Dict["image3"] as! String
                        let image4 = Dict["image4"] as! String
                        let image5 = Dict["image5"] as! String
                        let image6 = Dict["image6"] as! String
                        
                        let obj = People(fb_id: fb_id,first_name:first_name, last_name:last_name, birthday:birthday, gender:gender, image1:image1, about_me: about_me,distance:distance,image2:image2,image3:image3,image4:image4,image5:image5,image6:image6)
                        
                        self.nearArray.add(obj)
                        let card =  Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
                        
                        card.prepareUI(text:obj.first_name+" "+obj.birthday,text_title:obj.distance, img: obj.image1)
                        self.sampleCards.append(card)
                    }
                    
                    
                   
                    if(self.nearArray.count == 0){
                        
                        self.refresh_btn.alpha = 0
                        self.cancel_btn.alpha = 0
                        self.fav_btn.alpha = 0
                        self.pulsateView.alpha = 1
                        self.shadowimage.alpha = 0
                        self.myview.alpha = 0
                        
                    }else{
                        
                        
                        self.refresh_btn.alpha = 1
                        self.cancel_btn.alpha = 1
                        self.fav_btn.alpha = 1
                        self.pulsateView.alpha = 0
                        self.shadowimage.alpha = 1
                        self.myview.alpha = 1
                        
                        self.myview.delegate = self
                        self.myview.dataSource = self
                       // self.myview.reloadData()
                        
                        
                        self.myview.layer.borderColor = UIColor.init(red:219/255, green:221/255, blue:222/255, alpha:1).cgColor
                        self.myview.layer.borderWidth = 1
                        
                        self.shadowimage.alpha = 1


                    }
//
//                        if(self.sampleCards.count == 0){
//
//
//                        }else if(self.sampleCards.count > 0){
//
//
//                        }
                    
                        

                    
               
                    
                  
                }else{
                    
                    self.view.isUserInteractionEnabled = true
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
               
                print(error)
                self.view.isUserInteractionEnabled = true
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }


    
    @IBAction func refresh(_ sender: Any) {
        
      myview?.revertAction()
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
    
    
    @IBAction func inbox(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
        
    }
    
    
    @IBAction func dislike(_ sender: Any) {
     
         myview?.swipe(.left)
        
    }
    
    @IBAction func like(_ sender: Any) {
        myview?.swipe(.right)
       
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func dropShadow() {


        myview.layer.cornerRadius = 5
        myview.layer.masksToBounds = true
//        myview.layer.shadowColor = UIColor.lightGray.cgColor
//        myview.layer.shadowOffset = CGSize(width: 0, height: 3)
//        myview.layer.shadowOpacity = 0.7
//        myview.layer.shadowRadius = 4.0
        
       
       
        
    }
    
 
    
    
}

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        
       // self.view.isUserInteractionEnabled = false
        
                self.refresh_btn.alpha = 0
                self.cancel_btn.alpha = 0
                self.fav_btn.alpha = 0
                self.pulsateView.alpha = 1
                self.myview.alpha = 0
                self.shadowimage.alpha = 0
                self.myview.layer.borderWidth = 0
        
        
        
                //self.ShowPeopleApi()
        
       
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
     
        if( index <= self.nearArray.count){
            
            
        
        let obj = self.nearArray[index] as! People
        StaticData.singleton.image01 = obj.image1
        StaticData.singleton.image02 = obj.image2
        StaticData.singleton.image03 = obj.image3
        StaticData.singleton.image04 = obj.image4
        StaticData.singleton.image05 = obj.image5
        StaticData.singleton.image06 = obj.image6
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfoViewController") as! userInfoViewController
        
        
        
        
        vc.det = obj.birthday
        vc.name = obj.first_name+" "+obj.last_name
        vc.loc = obj.distance
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .zoom
        present(vc, animated: true, completion: nil)
    }
    }
    
}

// MARK: KolodaViewDataSource

extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return sampleCards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
       return sampleCards[index]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? CustomOverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
     
        
                let now = Date()
        
                let formatter = DateFormatter()
        
                formatter.timeZone = TimeZone.current
        
                formatter.dateFormat = "hh"
        
                let dateString = formatter.string(from: now)
                 let obj = self.nearArray[self.currentIndex] as! People
               if (direction == SwipeResultDirection.right) {
                
                print(UserDefaults.standard.string(forKey:"uid")!)
                self.childRef1.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.fb_id).observeSingleEvent(of: .value, with: { snapshot in
                    
                    if snapshot.exists(){
                        let firebaseDic = snapshot.value as! [String:AnyObject]
                        
                        print(firebaseDic)
                        let toggle = firebaseDic["type"] as! String
                        
                        
                        if(toggle == "like"){
                            let effect = firebaseDic["effect"] as! String
                            self.childRef1.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.fb_id!).updateChildValues(["match":"true",
                                                                                                                                   "name":obj.first_name+" "+obj.last_name,"type":"like","effect":effect,"status":"0","time":dateString])
                            self.childRef1.child(obj.fb_id!).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(["match":"true",
                                                                                                                                   "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"type":"like","effect":effect,"status":"0","time":dateString])
                            Database.database().reference().child("Users").child(obj.fb_id!).observeSingleEvent(of: .value) {
                                (snapshot) in
                                let firebaseDic = snapshot.value as? [String: AnyObject]
                                if (firebaseDic?["token"] as? String) != nil {
                                    
                                    let notkey =  Database.database().reference().child("notifications").key
                                    Database.database().reference().child("notifications").child(UserDefaults.standard.string(forKey:"uid")!).child(notkey!).updateChildValues([
                                        "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"message":"Congrats! you got a match","picture":"","token":UserDefaults.standard.string(forKey:"DeviceToken")!,"receiverid":obj.fb_id!])
                                    
                                    let url : String = StaticData.singleton.baseUrl!+"sendPushNotification"
                                    
                                    let parameter:[String:Any]?  = ["tokon":UserDefaults.standard.string(forKey:"DeviceToken")!,"title":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"message":"Sent an image","icon":UserDefaults.standard.string(forKey:"image_url")!,"senderid":UserDefaults.standard.string(forKey:"uid")!,"receiverid":obj.fb_id!,"action_type":"match"]
                                    
                                    print(url)
                                    print(parameter!)
                                    
                                    Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
                                        
                                        respones in
                                        
                                        switch respones.result {
                                        case .success( let value):
                                            
                                            let json  = value
                                            
                                            print(json)
                                            let dic = json as! NSDictionary
                                            let code = dic["code"] as! String
                                            if(String(describing: code) == "200"){
                                                
                                                
                                                
                                            }
                                                
                                            else{
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                        case .failure(let error):
                                            
                                            print(error)
                                            
                                            
                                            
                                        }
                                    })
                                }
                            }
                            
                            
                            
                        }else{
                            
                            self.childRef1.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.fb_id).updateChildValues(["match":"false",
                                                                                                                                  "name":obj.first_name+" "+obj.last_name,"type":"like","effect":"true","status":"0","time":dateString])
                            self.childRef1.child(obj.fb_id).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(["match":"false",
                                                                                                                                  "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"type":"like","effect":"false","status":"0","time":dateString])
                            
                        }
                    }else{
                        self.childRef1.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.fb_id).updateChildValues(["match":"false",
                                                                                                                              "name":obj.first_name+" "+obj.last_name,"type":"like","effect":"true","status":"0","time":dateString])
                        self.childRef1.child(obj.fb_id).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(["match":"false",
                                                                                                                              "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"type":"like","effect":"false","status":"0","time":dateString])
                    }
                    
                    
                    
                    
                })
                
                
        }
                

                else if (direction == SwipeResultDirection.left) {
    
    print(obj.fb_id!)
    
    
    
    StaticData.singleton.lastfb_id = obj.fb_id
    StaticData.singleton.lastfirst_name = obj.first_name
    StaticData.singleton.lastlast_name = obj.last_name
    StaticData.singleton.lastgender = obj.gender
    StaticData.singleton.lastimage1 = obj.image1
    StaticData.singleton.lastimage2 = obj.image2
    StaticData.singleton.lastimage3 = obj.image3
    StaticData.singleton.lastimage4 = obj.image4
    StaticData.singleton.lastimage5 = obj.image5
    StaticData.singleton.lastimage6  = obj.image6
    StaticData.singleton.lastbirthday = obj.birthday
    StaticData.singleton.lastdistance = obj.distance
    StaticData.singleton.lastabout_me = obj.about_me
    self.lastIndex = self.currentIndex
    
    
    
    
    print(obj.fb_id!)
    print(UserDefaults.standard.string(forKey:"uid")!)
    self.childRef1.child(UserDefaults.standard.string(forKey:"uid")!).child(obj.fb_id!).updateChildValues(["match":"false",
    "name":obj.first_name+" "+obj.last_name,"type":"dislike","effect":"true","status":"0","time":dateString])
    self.childRef1.child(obj.fb_id!).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(["match":"false",
    "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"type":"dislike","effect":"false","status":"0","time":dateString])
        
                
    }
        
    }
        
    
    
    
}
