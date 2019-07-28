//
//  VerificationViewController.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/3/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SDWebImage
import FirebaseStorage
import Alamofire
import AlamofireImage


class VerificationViewController: UIViewController,UITextFieldDelegate {

        @IBOutlet var textFieldA: UITextField!
        
        @IBOutlet var textFieldB: UITextField!
        
        @IBOutlet var textFieldC: UITextField!
        
        @IBOutlet var textFieldD: UITextField!
        
         @IBOutlet var textFieldE: UITextField!
        
        @IBOutlet var textFieldF: UITextField!
    
    var childRef332 = Database.database().reference().child("Users")

        
    @IBOutlet weak var btn_confm: UIBarButtonItem!
    @IBOutlet weak var txt_phone: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
    
         
        txt_phone.text = "Sent to "+StaticData.singleton.phonenumber!
        
        self.textFieldA.becomeFirstResponder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btn_confm.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Verdana", size: 15)!], for: .normal)
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 15)!]
        
        
        
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if(textField == textFieldA){
                
                textFieldA.text = ""
                
            }else if(textField == textFieldB){
                
                textFieldB.text = ""
                
            }else if(textField == textFieldC){
                
                textFieldC.text = ""
            }else if(textField == textFieldD){
                
                textFieldD.text = ""
            }else if(textField == textFieldE){
                
                textFieldE.text = ""
            }else
            {
                textFieldF.text = ""
                
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            let newLength: Int = newString.length
            if textField == textFieldA {
                if newLength == 1 {
                    textField.text = newString as String
                    textFieldB.becomeFirstResponder()
                }
            }
            if textField == textFieldB{
                if newLength == 1 {
                    textField.text = newString as String
                    textFieldC.becomeFirstResponder()
                }
            }
            if textField  == textFieldC {
                if newLength == 1 {
                    textField.text = newString as String
                    textFieldD.becomeFirstResponder()
                }
            }
            if textField == textFieldD {
                if newLength == 1 {
                    textField.text = newString as String
                    textFieldE.becomeFirstResponder()
                }
            }
            
            if textField == textFieldE {
                if newLength == 1 {
                    textField.text = newString as String
                    textFieldF.becomeFirstResponder()
                }
            }
            
            if textField == textFieldF {
                if newLength == 1 {
                    textField.text = newString as String
                    self.view.endEditing(true)
                }
            }
            return true
        }
        
        
        @IBAction func ConfirmCode(_ sender: Any) {
            
          
            
            if(textFieldA.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }else if(textFieldB.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }else if(textFieldC.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }
            else if(textFieldD.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }else if(textFieldE.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }else if(textFieldF.text?.isEmpty)!{
                
                self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
            }
            else{
                self.view.isUserInteractionEnabled = false
                let sv = SliderViewController.displaySpinner(onView: self.view)
                let str:String! = textFieldA.text!+textFieldB.text!+textFieldC.text!
                let str2:String! = textFieldD.text!+textFieldE.text!+textFieldF.text!
                let result:String! = str+str2
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: UserDefaults.standard.string(forKey:"authVerificationID")!,
                    verificationCode: result)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if error != nil {
                        self.view.isUserInteractionEnabled = true
                        SliderViewController.removeSpinner(spinner: sv)
                        return
                    }
                    guard let user = authResult?.user else { return }
                    print(user.uid)
                    
                    let text2:String! = StaticData.singleton.phonenumber!.replacingOccurrences(of: "+", with: "")
                    UserDefaults.standard.set(text2, forKey: "uid")
                    self.view.isUserInteractionEnabled = true
                    SliderViewController.removeSpinner(spinner: sv)
                  
                   self.ShowUserApi()
                    
                    
                    
                    
                 
                }

            }
            
        }
    
    func ShowUserApi(){
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"getUserInfo"
        
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
                    
                    let myCountry = dic["msg"] as? NSArray
                    let mycountry1 = myCountry![0] as! NSDictionary
                  
                    
                    let image1 = mycountry1["image1"] as? String
                    
                    Alamofire.request(image1!).responseImage { response in
                        debugPrint(response)
                        
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            
                            do {
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let fileURL = documentsURL.appendingPathComponent("filename.png")
                                if let pngImageData = image.pngData() {
                                    try pngImageData.write(to: fileURL, options: .atomic)
                                }
                            } catch { }
                        }
                    }
                    
                    let firstname:String! = mycountry1["first_name"] as? String
                    let last_name:String! = mycountry1["last_name"] as? String
                    
                    
                    UserDefaults.standard.set(mycountry1["email"] as? String, forKey:"email")
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey:"uid")!, forKey:"uid")
                    
                    
                    
                    UserDefaults.standard.set(firstname, forKey:"first_name")
                    UserDefaults.standard.set(last_name, forKey:"last_name")
                    UserDefaults.standard.set(firstname+" "+last_name , forKey:"Username")
                    UserDefaults.standard.set(image1, forKey:"image_url")
                    
                    
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "navbar") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                
                }else{
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: InfoViewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                    self.present(vc, animated: true, completion: nil)
                
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    @IBAction func resend(_ sender: Any) {
        
        self.view.isUserInteractionEnabled = false
        let sv = SliderViewController.displaySpinner(onView: self.view)
        PhoneAuthProvider.provider().verifyPhoneNumber(StaticData.singleton.phonenumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                //self.showMessagePrompt(error.localizedDescription)
                self.view.isUserInteractionEnabled = true
                SliderViewController.removeSpinner(spinner: sv)
                print(error.localizedDescription)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                return
            }
            
            self.view.isUserInteractionEnabled = true
            SliderViewController.removeSpinner(spinner: sv)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
         
        }

    }
    
        
        
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
        
        
}
