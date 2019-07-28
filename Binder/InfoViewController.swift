//
//  InfoViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 08/03/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SDWebImage
import FirebaseStorage
import Alamofire
import ANLoader
import AlamofireImage

class InfoViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var txt_seg: UISegmentedControl!
    
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var txt_first: UITextField!
    
    @IBOutlet weak var txt_last: UITextField!
    
    var downloadURL:String! = ""
    
    var birthday:String! = ""
    
    var gender:String! = "male"
    
    @IBOutlet weak var date_view: UIView!
    
    @IBOutlet weak var pickerview: UIDatePicker!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var btn_bithday: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        
        imagePicker.delegate = self
        
      
    
        
        gender = "male"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        user_img.layer.masksToBounds = false
        user_img.layer.cornerRadius = user_img.frame.height/2
        user_img.clipsToBounds = true
       
    }
    
    
    
    @IBAction func gender(_ sender: Any) {
        
        if txt_seg.selectedSegmentIndex == 0 {
            self.gender = "male"
            
        }else{
            self.gender = "female"
        }
        
    }
    
    
    @IBAction func DOB(_ sender: Any) {
        
       self.date_view.alpha = 1
        self.isEditing = false 
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.date_view.alpha = 0
        
        
    }
    
    @IBAction func done(_ sender: Any) {
        
        pickerview.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: pickerview.date)
        
        self.birthday = selectedDate
        self.date_view.alpha = 0
        self.btn_bithday.setTitle(selectedDate, for: .normal)
    }
    
    
    @IBAction func Next(_ sender: Any) {
        
        if(txt_first.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your first name.")
            
        }else if(txt_last.text?.isEmpty)!{
            
             self.alertModule(title:"Error", msg:"Please enter your last name.")
        }else if(self.birthday == ""){
            
            self.alertModule(title:"Error", msg:"Please enter your date of birth.")
        }else if(self.downloadURL == ""){
            
            self.alertModule(title:"Error", msg:"Please select your profile image.")
        }
        else{
            
            self.SignInApi()
        }
    }
    
    
    func SignInApi(){
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"signup"
        
        
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"first_name":self.txt_first.text!,"last_name":self.txt_last.text!,"birthday":self.birthday,"gender":self.gender,"image1":downloadURL!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.view.isUserInteractionEnabled = true
                SliderViewController.removeSpinner(spinner: sv)
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(code == "200"){
                    
                    let myCountry = dic["msg"] as? NSArray
                    
                    let mycountry1 = myCountry![0] as! NSDictionary
                    
                    let image1 = mycountry1["image1"] as? String
                    
                    
                    
                    UserDefaults.standard.set(mycountry1["email"] as? String, forKey:"email")
                    UserDefaults.standard.set(mycountry1["fb_id"] as? String, forKey:"uid")
                    
                    
                    
                    UserDefaults.standard.set(self.txt_first.text!, forKey:"first_name")
                    UserDefaults.standard.set(self.txt_last.text!, forKey:"last_name")
                    UserDefaults.standard.set(self.txt_first.text!+" "+self.txt_last.text! , forKey:"Username")
                    UserDefaults.standard.set(image1, forKey:"image_url")
                    
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "navbar") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        
        
        
    }
    
    
    
    
    @IBAction func pickImage(_ sender: Any) {
        
        let actionSheet =  UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (_:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
            } else {
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                self.present(
                    alertVC,
                    animated: true,
                    completion: nil)
            }
        })
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {
            (_:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let number = Int.random(in: 1000 ... 10000)
        let pickedImage = info[.originalImage] as? UIImage
        
        let storageRef = Storage.storage().reference().child(String(number)+"_myImage.png")
       ANLoader.showLoading("Uploading....", disableUI: true)
        
        if let uploadData = pickedImage!.jpeg(.lowest) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error ) in
                
                guard metadata != nil else{
                    print(error!)
                   
                    ANLoader.hide()
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    print(url!)
                    self.downloadURL = String(describing: url!)
                    self.user_img.image = pickedImage
                    Alamofire.request(self.downloadURL!).responseImage { response in
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
                    
                   
                    ANLoader.hide()
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    guard url != nil else {
                        
                        ANLoader.hide()
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                }
            })
            
        }
        
        
        
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


