//
//  SettingsViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/03/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var soonze_img: UIImageView!
    
    @IBOutlet weak var women_img: UIImageView!
    
    @IBOutlet weak var men_img: UIImageView!
    
    @IBOutlet weak var every_img: UIImageView!
    
    @IBOutlet weak var age_lbl: UILabel!
    
    @IBOutlet weak var distace_lbl: UILabel!
    
    @IBOutlet weak var age_slider: UISlider!
    
    @IBOutlet weak var distance_slider: UISlider!
    
   
    
    var gender:String! = ""
    var snooze:String! = ""
    var noti:String! = ""
    var age:String! = "18"
    var dist:String! = "100"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(UserDefaults.standard.string(forKey: "gender") == "men"){
            
            self.men_img.alpha = 1
        }else if(UserDefaults.standard.string(forKey: "gender") == "women"){
            
            
            self.women_img.alpha = 1
        }else if(UserDefaults.standard.string(forKey: "gender") == "every") {
            self.every_img.alpha = 1
        }
        
        if(UserDefaults.standard.string(forKey: "snooze") == "true"){
            
            self.soonze_img.alpha = 1
        }else{
           self.soonze_img.alpha = 0
        }
        
       
        
        if(UserDefaults.standard.string(forKey:"age") != nil && UserDefaults.standard.string(forKey:"age") != ""){
           
        self.age_slider.value = Float(UserDefaults.standard.string(forKey:"age")!)!
        
        self.age_lbl.text = "Between 18 and "+UserDefaults.standard.string(forKey:"age")!
        }
        
        if(UserDefaults.standard.string(forKey:"distance") != nil && UserDefaults.standard.string(forKey:"distance") != ""){
            
          
        
        self.distance_slider.value = Float(UserDefaults.standard.string(forKey:"distance")!)!
        
        self.distace_lbl.text = UserDefaults.standard.string(forKey:"distance")!
    }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
       
        
        self.dismiss(animated:true, completion:nil)
    }
    
    @IBAction func showSoonze(_ sender: Any) {
        
        if soonze_img.alpha == 0{
            
            soonze_img.alpha = 1
            
            self.snooze = "true"
            UserDefaults.standard.set(self.snooze, forKey:"snooze")
            
            
            
        }else{
            self.snooze = "false"
           
            soonze_img.alpha = 0
            UserDefaults.standard.set(self.snooze, forKey:"snooze")
        }
        
        
        
        
    }
    @IBAction func men(_ sender: Any) {
        
        
            men_img.alpha = 1
        women_img.alpha = 0
        every_img.alpha = 0
        
        self.gender = "men"
        UserDefaults.standard.set(self.gender, forKey:"gender")
        
        
        
    }
    
    
    @IBAction func women(_ sender: Any) {
        
        men_img.alpha = 0
        women_img.alpha = 1
        every_img.alpha = 0
        
        self.gender = "women"
        UserDefaults.standard.set(self.gender, forKey:"gender")
        
    }
    
    @IBAction func everyOne(_ sender: Any) {
        
        men_img.alpha = 0
        women_img.alpha = 0
        every_img.alpha = 1
        
        self.gender = "every"
        UserDefaults.standard.set(self.gender, forKey:"gender")
        
        
    }
    
//    @IBAction func notification(_ sender: Any) {
//
//        if notification_img.alpha == 0{
//
//            notification_img.alpha = 1
//            self.noti = "true"
//
//            UserDefaults.standard.set(self.noti, forKey:"noti")
//
//
//
//        }else{
//            self.noti = "false"
//            notification_img.alpha = 0
//            UserDefaults.standard.set(self.noti, forKey:"noti")
//
//        }
//    }
    
    @IBAction func logout(_ sender: Any) {
        
      
        let alert = UIAlertController(title: "Finder", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { action in
            
            UserDefaults.standard.set("", forKey:"email")
            UserDefaults.standard.set("", forKey:"uid")
            
            UserDefaults.standard.set("", forKey:"first_name")
            UserDefaults.standard.set("", forKey:"last_name")
            UserDefaults.standard.set("", forKey:"Username")
            UserDefaults.standard.set("", forKey:"image_url")
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: SliderViewController = storyboard.instantiateViewController(withIdentifier: "SliderViewController") as! SliderViewController
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        self.deleteAccountApi()
        
    }
    
    @IBAction func Done(_ sender: Any) {
 
        
        self.dismiss(animated:true, completion:nil)
    }
    
    
    @IBAction func ageDifference(_ sender: Any) {
        
        let currentValue = Int((sender as! UISlider).value)
        
        self.age_lbl.text = "Between 18 and "+String(currentValue)
        
        self.age = String(currentValue)
        UserDefaults.standard.set(self.age, forKey:"age")
      
        
    }
    
    @IBAction func distanceDifference(_ sender: Any) {
        
        let currentValue = Int((sender as! UISlider).value)
        
        self.dist = String(currentValue)
        self.distace_lbl.text = String(currentValue)+" miles"
        UserDefaults.standard.set(self.dist, forKey:"distance")
        
    }
    
    
    func deleteAccountApi(){
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"deleteAccount"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                SliderViewController.removeSpinner(spinner: sv)
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    
                    
                    UserDefaults.standard.set("", forKey:"email")
                    UserDefaults.standard.set("", forKey:"uid")
                    
                    UserDefaults.standard.set("", forKey:"first_name")
                    UserDefaults.standard.set("", forKey:"last_name")
                    UserDefaults.standard.set("", forKey:"Username")
                    UserDefaults.standard.set("", forKey:"image_url")
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: SliderViewController = storyboard.instantiateViewController(withIdentifier: "SliderViewController") as! SliderViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }else{
                    
                    self.dismiss(animated:true, completion:nil)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }


}
