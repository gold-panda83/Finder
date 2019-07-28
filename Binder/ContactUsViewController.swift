//
//  ContactUsViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 12/17/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController,UITextViewDelegate  {
    
    @IBOutlet weak var txt_contact: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.txt_contact.delegate = self
        
        txt_contact.text = "Type your problem here...."
        txt_contact.textColor = UIColor.black
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your problem here...."
            textView.textColor = UIColor.black
        }
    }
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated:false, completion: nil)
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        if(self.txt_contact.text != "Type your problem here...."){
            
            self.dismiss(animated:false, completion: nil)
        }
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
