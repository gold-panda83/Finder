//
//  PreviewViewController.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/30/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SDWebImage
import Alamofire

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var preview_img: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if(StaticData.singleton.isSticker == "yes"){
            
            Alamofire.request(StaticData.singleton.UrlImage!).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    // Show the downloaded image:
                    if let data = response.data {
                    
                        self.preview_img.image = UIImage.gif(data: data)
                        
                    }
                    
                }
            }
            
            
        
        }else{
           
            self.preview_img.sd_setImage(with: URL(string:StaticData.singleton.UrlImage!), placeholderImage: UIImage(named: "place"))
        }
        
        self.preview_img.isUserInteractionEnabled = true
        
        let pinchGrsture = UIPinchGestureRecognizer(target:self, action: #selector(self.pingesture))
        
        self.preview_img.addGestureRecognizer(pinchGrsture)
        
    }
    
    @objc func pingesture(sender:UIPinchGestureRecognizer){
        
        sender.view?.transform = (sender.view?.transform.scaledBy(x:sender.scale, y:sender.scale))!
        sender.scale = 1.0
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated:true, completion:nil)
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        UIGraphicsBeginImageContextWithOptions(self.preview_img.frame.size, self.preview_img.isOpaque, UIScreen.main.scale)
        self.preview_img.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)
        
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        UIGraphicsBeginImageContextWithOptions(self.preview_img.frame.size, self.preview_img.isOpaque, UIScreen.main.scale)
        self.preview_img.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        self.alertModule(title:"Finder", msg: "Image save to photos successfully.")
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
extension UIView {
    
    func capture() -> UIImage? {
        var image: UIImage?
        
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
            image = renderer.image { context in
                drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
            drawHierarchy(in: frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
    @IBInspectable var dropShadow: Bool {
        set{
            if newValue {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.4
                layer.shadowRadius = 4
                layer.shadowOffset = CGSize.zero
            } else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
                layer.shadowOffset = CGSize.zero
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
    
}
