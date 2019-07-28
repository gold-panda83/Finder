//
//  ProfileViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/12/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var shadoview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         self.dropShadow()
        
        
        
        self.navigationItem.setHidesBackButton(true, animated:true);
       
        
         let myImage11 = UserDefaults.standard.string(forKey:"image_url")!
        self.user_img.sd_setImage(with: URL(string:myImage11), placeholderImage: UIImage(named: "Unknown"))
        
        self.user_name.text = UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!
        
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named:"right-arrow"), for: .normal)
        //add function for button
        button.addTarget(self, action:#selector(actionWithoutParam), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x:10, y:0, width:31 , height:31)
        
//        button.layer.cornerRadius = 0.5 * button.bounds.size.width
//        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 31).isActive = true
        button.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        let button2: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named:"gear"), for: .normal)
        //add function for button
        button2.addTarget(self, action:#selector(actionWithoutParam2), for: .touchUpInside)
        //set frame
        button2.frame = CGRect(x:-10, y:0, width:31 , height:31)
        
        //        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        //        button.clipsToBounds = true
        
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        button2.widthAnchor.constraint(equalToConstant: 31).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        
        let barButton2 = UIBarButtonItem(customView: button2)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton2
        
   
        
       


        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    
        
        user_img.layer.masksToBounds = false
        user_img.layer.cornerRadius = user_img.frame.height/2
        user_img.clipsToBounds = true
            
            
        }
    
    
    @objc func actionWithoutParam(){
        
        self.navigationController?.popViewController(animated: true)
        //...
    }
    
    @objc func actionWithoutParam2(){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SettingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
        //...
    }
    
    
    
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
    
    @IBAction func contactus(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
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
    
    @IBAction func inbox(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
        
    }
   
    @IBAction func getprofile(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        let transition = CATransition()
        transition.duration = 0.50
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        //self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(vc, animated: false)
        
    }
    
    func dropShadow() {
        self.shadoview.layer.shadowColor = UIColor.lightGray.cgColor
        self.shadoview.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadoview.layer.shadowOpacity = 0.5
        self.shadoview.layer.shadowRadius = 4
        self.shadoview.layer.cornerRadius = 2
        self.shadoview.layer.masksToBounds = false
        
    }
    
}
