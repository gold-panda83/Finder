//
//  EditProfileViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/15/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import FirebaseDatabase
import Firebase
import DatePicker

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var shadoview: UIView!
    
    var userArray:NSMutableArray = []
    
    var ImagesArray:NSMutableArray = []
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var btn_close1: UIButton!
    
    @IBOutlet weak var btn_close2: UIButton!
    @IBOutlet weak var btn_close3: UIButton!
    
    @IBOutlet weak var btn_close4: UIButton!
    
    @IBOutlet weak var btn_close5: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var photo1: UIImageView!
    
    @IBOutlet weak var photo2: UIImageView!
    
    @IBOutlet weak var photo3: UIImageView!
    
    @IBOutlet weak var photo6: UIImageView!
    
    @IBOutlet weak var photo5: UIImageView!
    @IBOutlet weak var photo4: UIImageView!
    
    var image1:String! = ""
    var image2:String! = ""
    var image3:String! = ""
    var image4:String! = ""
    var image5:String! = ""
    var image6:String! = ""
    
    var image_link:String! = ""
    
    @IBOutlet weak var picker_view: UIDatePicker!
    
    @IBOutlet weak var date_view: UIView!
    
    
    @IBOutlet weak var about_name: UILabel!
    
    
    var Str:String! = "yes"
    
 
    @IBOutlet weak var tableview: UITableView!
    
    var about:String! = ""
    var birthday:String! = ""
    var company:String! = ""
    var gender:String! = ""
    var school:String! = ""
    var job_title:String! = ""
    
    
    
     var childRef322 = Database.database().reference().child("UserImages")
    
    var downloadURL:String! = ""
    
    
    @IBOutlet weak var about_me: UITextView!
    
    
    @IBOutlet weak var txt_job: UITextField!
    
    
    @IBOutlet weak var txt_company: UITextField!
    
    
    @IBOutlet weak var txt_college: UITextField!
    
    @IBOutlet weak var btn_date: UIButton!
    
    @IBOutlet weak var txt_seg: UISegmentedControl!
    
    var longPressGesture:UILongPressGestureRecognizer!
    
    var longPressedEnabled:Bool = false
    var isAnimate:Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropShadow()
        
//        let width = (view.frame.width-20)/3
//        let layout = collectionview.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: width, height: width)
        
      
        
       // about_us.text = "Type something about you...."
       // about_us.textColor = UIColor.lightGray
        imagePicker.delegate = self
//        self.photo1.layer.cornerRadius = 5
//        self.photo1.clipsToBounds = true
//        
//        self.photo2.layer.cornerRadius = 5
//        self.photo2.clipsToBounds = true
//        
//        self.photo3.layer.cornerRadius = 5
//        self.photo3.clipsToBounds = true
//        
//        self.photo4.layer.cornerRadius = 5
//        self.photo4.clipsToBounds = true
//        
//        self.photo5.layer.cornerRadius = 5
//        self.photo5.clipsToBounds = true
//        
//        self.photo6.layer.cornerRadius = 5
//        self.photo6.clipsToBounds = true
        self.ShowUserApi()
        
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        collectionview.addGestureRecognizer(longPressGesture)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type something about you...."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionview.indexPathForItem(at: gesture.location(in: collectionview)) else {
                return
            }
            collectionview.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionview.endInteractiveMovement()
           
            longPressedEnabled = true
            self.collectionview.reloadData()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }
    
    
    
    
    func ShowUserApi(){
        
        self.view.isUserInteractionEnabled = false
 
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"getUserInfo"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                 self.view.isUserInteractionEnabled = true
                self.userArray = []
                self.ImagesArray = []
                let json  = value
                SliderViewController.removeSpinner(spinner: sv)
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    let myCountry = dic["msg"] as? NSArray
                    let mycountry1 = myCountry![0] as! NSDictionary
                   
                        self.image1 = mycountry1["image1"] as? String
                    self.ImagesArray.add(self.image1)
                    self.image2 = mycountry1["image2"] as? String
                    self.ImagesArray.add(self.image2)
                        self.image3 = mycountry1["image3"] as? String
                    self.ImagesArray.add(self.image3)
                        self.image4 = mycountry1["image4"] as? String
                    self.ImagesArray.add(self.image4)
                        self.image5 = mycountry1["image5"] as? String
                    self.ImagesArray.add(self.image5)
                    self.image6 = mycountry1["image6"] as? String
                    self.ImagesArray.add(self.image6)
                    
//                    self.photo1.sd_setImage(with: URL(string:self.image1), placeholderImage: UIImage(named: "placeholder-759x500"))
//                    self.photo2.sd_setImage(with: URL(string:self.image2), placeholderImage: UIImage(named: "placeholder-759x500"))
//                    self.photo3.sd_setImage(with: URL(string:self.image3), placeholderImage: UIImage(named: "placeholder-759x500"))
//                    self.photo4.sd_setImage(with: URL(string:self.image4), placeholderImage: UIImage(named: "placeholder-759x500"))
//                    self.photo5.sd_setImage(with: URL(string:self.image5), placeholderImage: UIImage(named: "placeholder-759x500"))
//                    self.photo6.sd_setImage(with: URL(string:self.image6), placeholderImage: UIImage(named: "placeholder-759x500"))
                    
                    self.about_name.text = "About "+UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!
                    
                    self.about = mycountry1["about_me"] as? String
                    self.birthday = mycountry1["birthday"] as? String
                    self.company = mycountry1["company"] as? String
                    self.gender = mycountry1["gender"] as? String
                    self.school = mycountry1["school"] as? String
                    self.job_title = mycountry1["job_title"] as? String
                    
                    self.about_me.text = self.about
                    self.btn_date.setTitle(self.birthday, for: .normal)
                    
                    self.txt_company.text = self.company
                    
                    self.txt_college.text = self.school
                    
                    self.txt_job.text = self.job_title
                    
                    if(self.gender == "male"){
                        
                        self.txt_seg.selectedSegmentIndex = 0
                    }else{
                        
                        self.txt_seg.selectedSegmentIndex = 1
                    }
                    
                    
                
                    
                  //  self.tableview.reloadData()
                   

//
         
//                if(self.image2 == ""){
//
//                    self.btn_close1.setBackgroundImage(UIImage(named:"Untitled-1-24"), for: .normal)
//                }else{
//                    self.btn_close1.setBackgroundImage(UIImage(named:"Untitled-1-25"), for: .normal)
//                }
//                if(self.image3 == ""){
//                    self.btn_close2.setBackgroundImage(UIImage(named:"Untitled-1-24"), for: .normal)
//                }else{
//                    self.btn_close2.setBackgroundImage(UIImage(named:"Untitled-1-25"), for: .normal)
//                }
//                if(self.image4 == ""){
//                    self.btn_close3.setBackgroundImage(UIImage(named:"Untitled-1-24"), for: .normal)
//                }else{
//                    self.btn_close3.setBackgroundImage(UIImage(named:"Untitled-1-25"), for: .normal)
//                }
//                if(self.image5 == ""){
//                   self.btn_close4.setBackgroundImage(UIImage(named:"Untitled-1-24"), for: .normal)
//                }else{
//                    self.btn_close4.setBackgroundImage(UIImage(named:"Untitled-1-25"), for: .normal)
//                }
//                if(self.image6 == ""){
//                    self.btn_close5.setBackgroundImage(UIImage(named:"Untitled-1-24"), for: .normal)
//                }else{
//                    self.btn_close5.setBackgroundImage(UIImage(named:"Untitled-1-25"), for: .normal)
//                }
                    
                    
                 self.collectionview.delegate = self
                 self.collectionview.dataSource = self
                 self.collectionview.reloadData()
                
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
    
    
    func UploadImageApi(){
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"uploadImages"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image_link]
        
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
                   
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1    //return number of sections in collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6  //return number of rows in section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell00004", for: indexPath as IndexPath) as! CollectionViewCell
        
        let obj = self.ImagesArray[indexPath.row] as! String
        
        
        
        cell.col_img.layer.masksToBounds = false
        cell.col_img.layer.cornerRadius = 5
        cell.col_img.clipsToBounds = true
        
        if(indexPath.row == 0){
           
        
            cell.col_remove.alpha = 0
            cell.col_button.alpha = 0
            cell.col_img.sd_setImage(with: URL(string:obj), placeholderImage: UIImage(named: "placeholder-759x500"))
         
            
        }else{
            
            if(obj == ""){

                cell.col_remove.alpha = 0
                cell.col_button.alpha = 1
                cell.col_button.tag = indexPath.row
                cell.col_button.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
                cell.col_img.image = UIImage(named:"placeholder-759x500")
                
                
                
            }else{

                cell.col_remove.alpha = 1
                cell.col_button.alpha = 0
                cell.col_remove.tag = indexPath.row
                cell.col_img.sd_setImage(with: URL(string:obj), placeholderImage: UIImage(named: "placeholder-759x500"))
                cell.col_remove.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
                
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = self.ImagesArray[indexPath.row] as! String
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  2.5
    }
    

    
    
    @IBAction func removeBtnClick(_ sender: UIButton)   {
        
        let index = self.ImagesArray[sender.tag] as! String
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":index]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
    }
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction)in
            
            
        })
        actionSheet.addAction(camera)
        
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Start index :- \(sourceIndexPath.item)")
        print("End index :- \(destinationIndexPath.item)")
        
        let tmp = ImagesArray[sourceIndexPath.item]
        ImagesArray[sourceIndexPath.item] = ImagesArray[destinationIndexPath.item]
        ImagesArray[destinationIndexPath.item] = tmp
        
        collectionView.reloadData()
    }
    
    
  
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
   
        self.dismiss(animated:true, completion: nil)
        let number = Int.random(in: 0 ... 1000)
        let pickedImage = info[.originalImage] as? UIImage
        let storageRef = Storage.storage().reference().child(String(number)+"_myImage.png")
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
        
        if let uploadData = pickedImage!.jpeg(.lowest) {
            
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error ) in
                
                guard let metadata = metadata else{
                    print(error!)
                    Chat1ViewController.removeSpinner(spinner: sv)
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    print(url!)
                    SliderViewController.removeSpinner(spinner: sv)
                    self.image_link = String(describing: url!)
                    self.UploadImageApi()
                    guard let downloadURL = url else {
                        SliderViewController.removeSpinner(spinner: sv)
                        return
                    }
                }
            })
            
        }
        
        
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
      
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @objc func connected1(sender: UIButton){
        
     
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated:false, completion: nil)
    }
    @IBAction func addImage(_ sender: Any) {
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction)in
            
            
        })
        actionSheet.addAction(camera)
        
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func closeimage1(_ sender: Any) {
        
         if(self.image2 != ""){
        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image2]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
         }else{
            
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeimage2(_ sender: Any) {
        
         if(self.image3 != ""){
        
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
            let sv = SliderViewController.displaySpinner(onView: self.view)
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image3]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
            
         }else{
            
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeimage3(_ sender: Any) {
        
        if(self.image4 != ""){
        
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
            let sv = SliderViewController.displaySpinner(onView: self.view)
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image4]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        }else{
            
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeimage4(_ sender: Any) {
        
         if(self.image5 != ""){
        
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
            let sv = SliderViewController.displaySpinner(onView: self.view)
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image5]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
            
        }else{
            
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeimage5(_ sender: Any) {
        
         if(self.image6 != ""){
        
        let url : String = StaticData.singleton.baseUrl!+"deleteImages"
            let sv = SliderViewController.displaySpinner(onView: self.view)
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"image_link":self.image6]
        
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
                    
                    self.ShowUserApi()
                    
                }
                    
                else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                SliderViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
            
         }else{
            
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Done(_ sender: Any) {
        
//        if(self.about_us.text == nil || self.about_us.text == "Type something about you...."){
//
//            self.about_us.text = ""
//
//        }
        
     
        
        if(self.about_me.text == nil){
            self.about_me.text! = ""
        }
        
        if(self.birthday == nil){
            self.birthday = ""
        }
        
        
        if(self.txt_job.text == nil){
            self.txt_job.text = ""
        }
        
        if(self.txt_college.text == nil){
            self.txt_college.text = ""
        }
        
        if( self.txt_company.text == nil){
            self.txt_company.text = ""
        }
        
        if( self.gender == nil){
            self.gender = "male"
        }
        
        
        let url:String = StaticData.singleton.baseUrl!+"edit_profile"
        
        
        
        let sv = SliderViewController.displaySpinner(onView: self.view)
            
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"about_me":self.about_me.text!,"birthday":self.birthday,"job_title":self.txt_job.text!,"school":self.txt_college.text!,"company":self.txt_company.text!,"gender":self.gender]
        
            
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
                        
                        let alert = UIAlertController(title: "Finder", message: "Your profile is updated.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                           self.dismiss(animated:false, completion:nil)
                            
                        }))
                       
                        
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                        
                    else{
                        
                        
                        self.alertModule(title:"Error",msg:dic["msg"] as! String)
                        
                    }
                    
                    
                case .failure(let error):
                    
                    print(error)
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                    SliderViewController.removeSpinner(spinner: sv)
                    
                    
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
    
    func dropShadow() {
        self.shadoview.layer.shadowColor = UIColor.lightGray.cgColor
        self.shadoview.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadoview.layer.shadowOpacity = 0.5
        self.shadoview.layer.shadowRadius = 4
        self.shadoview.layer.cornerRadius = 2
        self.shadoview.layer.masksToBounds = false
        
    }
    
   
    
    @IBAction func cancel(_ sender: Any) {
        
        self.date_view.alpha = 0
        
    }
    
    
    @IBAction func DonePicker(_ sender: Any) {
        
        
        
        picker_view.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker_view.date)
        
        self.birthday = selectedDate
        self.date_view.alpha = 0
        self.btn_date.setTitle(selectedDate, for: .normal)
        
        self.Str = "no"
        
        //self.tableview.reloadData()
        
        
        
    }
    
    @IBAction func datepick(_ sender: Any) {
        
        self.date_view.alpha = 1
    }
    
    
    
    @IBAction func segment(_ sender: Any) {
        
        if txt_seg.selectedSegmentIndex == 0 {
            self.gender = "male"
            
        }else{
            self.gender = "female"
        }
    }
    
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        
    
        if sender.selectedSegmentIndex == 0 {
           self.gender = "male"
        }else{
            self.gender = "female"
        }
        
        self.Str = "no"
        
       //self.tableview.reloadData()
        
    }
        
      
    

}
