//
//  PhoneViewController.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/2/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import CountryList
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
import StoreKit
class PhoneViewController: UIViewController,CountryListDelegate,UITextFieldDelegate {
    
    var countryList = CountryList()

    @IBOutlet weak var btn_next: UIBarButtonItem!
    @IBOutlet weak var txt_country: UITextField!
    
    @IBOutlet weak var txt_code: UITextField!
    
    @IBOutlet weak var txt_phone: UITextField!
    
    var phone:String! = ""
    
     //var childRef333 = Database.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        txt_phone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.txt_phone.becomeFirstResponder()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "IAPViewController") as! IAPViewController
//        self.present(controller, animated: true, completion: nil)
        
       
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
         btn_next.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Verdana", size: 15)!], for: .normal)
    }
    
    @IBAction func countryaction(_ sender: Any) {
        
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func selectedCountry(country: Country) {
        txt_code.text =  "+"+country.phoneExtension
        txt_country.text =  country.flag!+"  "+country.name!
    }
    
    @IBAction func next(_ sender: Any) {
     
        
        if(txt_country.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please select your country.")
        }else if(txt_phone.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Phone Number.")
        }
        else{
            self.view.isUserInteractionEnabled = false
            let sv = SliderViewController.displaySpinner(onView: self.view)
        let charsToRemove: Set<Character> = Set(" ".characters)
        let newNumberCharacters = String(self.txt_phone.text!.characters.filter { !charsToRemove.contains($0) })
        
            print(self.txt_code.text!+newNumberCharacters)
        PhoneAuthProvider.provider().verifyPhoneNumber(self.txt_code.text!+newNumberCharacters, uiDelegate: nil) { (verificationID, error) in
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
            StaticData.singleton.phonenumber = self.txt_code.text!+newNumberCharacters
            self.performSegue(withIdentifier:"gotoverify", sender:self)
        }
        }
        
        
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        txt_phone.text = self.formattedNumber(number:textField.text!)
        
       
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
       
        var mask = "XXX XXX XXXXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask.characters {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func terms(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:"http://bringthings.com/AnonymousMessaging/terms_and_conditions.html")! as URL)
        
    }
    
    
    @IBAction func privacy(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:"https://termsfeed.com/privacy-policy/c97a312789233ea32edae3e8014bcaa2")! as URL)
    }
    

}

