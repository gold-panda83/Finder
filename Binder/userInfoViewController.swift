//
//  userInfoViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/14/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import SDWebImage
import  ImageSlideshow


class userInfoViewController: UIViewController {
    
    
    
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var user_loc: UILabel!
    
  
    

    var name:String! = ""
    var loc:String! = ""
    var det:String! = ""
    
  
    @IBOutlet weak var slideShow: ImageSlideshow!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        var alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!]
        if(AlamofireSource(urlString:StaticData.singleton.image02!) != nil){
            
            alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!,AlamofireSource(urlString:StaticData.singleton.image02!)!]
        }else if(AlamofireSource(urlString:StaticData.singleton.image03!) != nil){
            alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!,AlamofireSource(urlString:StaticData.singleton.image02!)!,AlamofireSource(urlString:StaticData.singleton.image03!)!]
        }else if(AlamofireSource(urlString:StaticData.singleton.image04!) != nil){
            
            alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!,AlamofireSource(urlString:StaticData.singleton.image02!)!,AlamofireSource(urlString:StaticData.singleton.image03!)!,AlamofireSource(urlString:StaticData.singleton.image04!)!]
            
        }else if(AlamofireSource(urlString:StaticData.singleton.image05!) != nil){
            
            alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!,AlamofireSource(urlString:StaticData.singleton.image02!)!,AlamofireSource(urlString:StaticData.singleton.image03!)!,AlamofireSource(urlString:StaticData.singleton.image04!)!,AlamofireSource(urlString:StaticData.singleton.image05!)!]
            
        }else if(AlamofireSource(urlString:StaticData.singleton.image06!) != nil){
            
            alamofireSource = [AlamofireSource(urlString:StaticData.singleton.image01!)!,AlamofireSource(urlString:StaticData.singleton.image02!)!,AlamofireSource(urlString:StaticData.singleton.image03!)!,AlamofireSource(urlString:StaticData.singleton.image04!)!,AlamofireSource(urlString:StaticData.singleton.image05!)!,AlamofireSource(urlString:StaticData.singleton.image06!)!]
        }
    
       
       
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: CGFloat(235.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(73.0/255.0), alpha: CGFloat(1.0))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideShow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideShow.activityIndicator = DefaultActivityIndicator()
       
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideShow.setImageInputs(alamofireSource)

        
        self.user_name.text = name+" "+det
     
        self.detail.text = loc
    }
    
 
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
    }
    
    
    
    @IBAction func flag(_ sender: Any) {
        
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Report "+name, style: .default, handler: {
            (_:UIAlertAction)in
            
        })
        
        let gallery = UIAlertAction(title: "Block", style: .destructive, handler: {
            (_:UIAlertAction)in
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction)in
            
        })
        actionSheet.addAction(camera)
        
        actionSheet.addAction(gallery)
        //actionSheet.addAction(Giphy)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
        
        
    
    

}
