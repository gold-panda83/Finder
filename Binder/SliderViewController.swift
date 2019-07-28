//
//  ViewController.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/2/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import AlamofireImage
import GoogleSignIn

class SliderViewController:  UIViewController, UIScrollViewDelegate,GIDSignInDelegate,GIDSignInUIDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var btn_view: UIView!
    
    @IBOutlet weak var phoneView: UIView!
    
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var my_id:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var img_url:String! = ""
     var birthday:String! = "17/01/1992"
    
    
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        btn_view.layer.cornerRadius = 25
        btn_view.clipsToBounds = true
        
        phoneView.layer.cornerRadius = 25
        phoneView.clipsToBounds = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "Untitled-2-1")
     
        slide1.labelDesc.text = "Discover new and interesting people nearby."
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "Untitled-1-2")
      
        slide2.labelDesc.text = "Swipe right to like someone or swipe left to pass"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "Untitled-1-3")
      
        slide3.labelDesc.text = "If they also swipe right then it's a match!"
        
      
        
        return [slide1, slide2, slide3]
    }
    
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//        
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//            
//            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//            
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//            
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//            
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
    }
    
    
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    @IBAction func loginwithgoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func loginWithFB(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                        
                    }
                }
            }
        }

    }
    
    func getFBUserData(){
        self.view.isUserInteractionEnabled = false
       let sv = SliderViewController.displaySpinner(onView: self.view)
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                            self.view.isUserInteractionEnabled = true
                           SliderViewController.removeSpinner(spinner: sv)
                            
                            self.alertModule(title:"Error", msg:"You cannot login with this facebook account because your facebook is not linked with any email")
                            
                        }else{
                          SliderViewController.removeSpinner(spinner: sv)
                            self.email = dict["email"] as? String
                             self.first_name = dict["first_name"] as? String
                             self.last_name = dict["last_name"] as? String
                             self.my_id = dict["id"] as? String
                            let dic1 = dict["picture"] as! NSDictionary
                            let pic = dic1["data"] as! NSDictionary
                            self.img_url = pic["url"] as? String
                            Alamofire.request(self.img_url).responseImage { response in
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
                            self.SignInApi()
                            
                        }
                    }
                    
                }else{
                    self.view.isUserInteractionEnabled = true
                    SliderViewController.removeSpinner(spinner: sv)
                    
                   
                }
            })
        }
        
    }
    
    func GoogleApi(user: GIDGoogleUser!){
        self.view.isUserInteractionEnabled = false
        let sv = SliderViewController.displaySpinner(onView: self.view)
        
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
            
            
            self.view.isUserInteractionEnabled = true
            SliderViewController.removeSpinner(spinner: sv)
            self.alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
            
        }else{
            
            self.view.isUserInteractionEnabled = true
            SliderViewController.removeSpinner(spinner: sv)
            //SliderViewController.removeSpinner(spinner: sv)
            self.email = user.profile.email
            self.first_name = user.profile.givenName
            self.last_name = user.profile.familyName
            self.my_id = user.userID
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                self.img_url = pic!.absoluteString
               
            }else{
                self.img_url = ""
            }
            Alamofire.request(self.img_url).responseImage { response in
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
            self.SignInApi()
        }
        
        
    }
    
    func SignInApi(){

        let sv = SliderViewController.displaySpinner(onView: self.view)
        let url : String = StaticData.singleton.baseUrl!+"signup"
        
       

        let parameter :[String:Any]? = ["fb_id":self.my_id!,"first_name":self.first_name!,"last_name":self.last_name!,"birthday":self.birthday,"gender":"male","image1":self.img_url!]

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

                    //let dic1 = dic["msg"] as! [[String:Any]]


                    UserDefaults.standard.set(self.email, forKey:"email")
                    UserDefaults.standard.set(self.my_id, forKey:"uid")
                    
                    

                    UserDefaults.standard.set(self.first_name, forKey:"first_name")
                    UserDefaults.standard.set(self.last_name, forKey:"last_name")
                    UserDefaults.standard.set(self.first_name+" "+self.last_name , forKey:"Username")
                    UserDefaults.standard.set(self.img_url, forKey:"image_url")
                    
                    self.performSegue(withIdentifier:"gotolocation", sender:self)
                

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
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
//            self.view.isUserInteractionEnabled = true
//            KRProgressHUD.dismiss {
//                print("dismiss() completion handler.")
//
//            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
    
    @IBAction func terms(_ sender: Any) {
        
        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
        UIApplication.shared.open(url)
        
    }

    
    @IBAction func privact(_ sender: Any) {
        
        
        guard let url = URL(string: "https://termsfeed.com/privacy-policy/502fc23a46657213af04ff23ae6a5454") else { return }
        UIApplication.shared.open(url)
        
    }
    
    

    
}
extension SliderViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView(frame: UIScreen.main.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            
            UIApplication.shared.keyWindow!.addSubview(spinnerView)
            UIApplication.shared.keyWindow!.bringSubviewToFront(spinnerView)
            onView.bringSubviewToFront(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    
    
}

