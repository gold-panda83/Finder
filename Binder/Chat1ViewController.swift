//
//  Chat1ViewController.swift
//  Jalebi
//
//  Created by Rao Mudassar on 10/15/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import Alamofire


class Chat1ViewController:JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var timer = Timer()
    var messages = NSMutableArray()
    var timearray = NSMutableArray()
    var seenStatus = NSMutableArray()
    var seenTime = NSMutableArray()
    let imagePicker = UIImagePickerController()
    var type = NSMutableArray()
    var chat_ids = NSMutableArray()
    var urls = NSMutableArray()
    
    var start_index:UInt! = 20

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var downloadURL:String! = ""
    
   var childRef30 = Database.database().reference().child("Inbox")
    var childRef31 = Database.database().reference().child("Inbox")
     var childRef32 = Database.database().reference().child("Match")
    
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        
        return JSQMessagesBubbleImageFactory(bubble: UIImage(named: "Untitled-1-30"), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with:UIColor.init(red:255/255.0, green:101/255.0, blue:96/255.0, alpha: 1.0))
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory(bubble: UIImage(named: "Untitled-1-29"), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with:UIColor.init(red:234/255.0, green:234/255.0, blue:234/255.0, alpha: 1.0))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        imagePicker.delegate = self
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
        
       
        
        
        self.inputToolbar.contentView.textView.tintColor = UIColor.init(red:31/255, green:128/255, blue:193/255, alpha: 1.0)
        self.inputToolbar.contentView.backgroundColor = UIColor.white
        self.inputToolbar.contentView.textView.font = UIFont(name: "Verdana", size:14)
//        self.inputToolbar.contentView.rightBarButtonItem.setBackgroundImage(UIImage(named: "Send-41") as UIImage?, for:.normal)
//        self.inputToolbar.contentView.rightBarButtonItem.setBackgroundImage(UIImage(named: "Send-41") as UIImage?, for:.disabled)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("Send", for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("Send", for: .disabled)
        self.inputToolbar.contentView.textView.layer.cornerRadius = self.inputToolbar.contentView.textView.frame.size.height/2
        self.inputToolbar.contentView.textView.clipsToBounds = true
        
        self.senderId = UserDefaults.standard.string(forKey:"uid")!
       // print(self.senderId)
        senderDisplayName = ""
        //UserDefaults.standard.string(forKey:"uid")!
        // collectionView.backgroundColor = UIColor.white
        
        //inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
         collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        
        let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!).queryLimited(toLast:self.start_index)
        
        childRef.keepSynced(true)
    
        
        childRef.observe(DataEventType.value, with: { (snapshot) in
          
            if snapshot.childrenCount > 0 {
                self.timearray = []
                self.seenTime = []
                self.seenStatus = []
                self.messages = []
                self.chat_ids = []
                self.urls = []
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject = artists.value as? [String: AnyObject]
                    print(artistObject!)
                    //let artistObject = artists.value as? [String: AnyObject]
                    
                    let key1 = artists.key
                    print(key1)
                    
                    //let data        = (snapshot).value as? NSDictionary
                    //print(data!)
                    let id          = artistObject!["sender_id"]
                    let rece_id          = artistObject!["receiver_id"] as! String
                    let chat_id          = artistObject!["chat_id"] as! String
                    let name        = artistObject!["sender_name"]
                    let text        = artistObject!["text"] as! String
                    let time        = artistObject!["timestamp"]
                    let status        = artistObject!["status"] as! String
                    let seenTime        = artistObject!["time"] as! String
                    let type        = artistObject!["type"] as! String
                    let imgurl        = artistObject!["pic_url"] as! String
                    if(type == "image"){
                      
                        let imageView = AsyncPhotoMediaItem(withURL: URL(string: imgurl)!)
                        
                        
                        if id as? String == self.senderId {
                            imageView.appliesMediaViewMaskAsOutgoing = true
                          
                        }
                        else
                        {
                            imageView.appliesMediaViewMaskAsOutgoing = false
                          
                           
                        }
                        let message = JSQMessage(senderId:id as? String, displayName: name as? String, media: imageView)
                      
                        self.messages.add(message!)
             
                       
                    }else if(type == "text"){
                    let message = JSQMessage(senderId: id as? String , displayName: name as? String , text: text )
                    self.messages.add(message!)
                    }
                    
                    self.timearray.add(time!)
                    
                    self.seenTime.add(seenTime)
                    self.seenStatus.add(status)
                    self.type.add(type)
                    self.chat_ids.add(chat_id)
                    self.urls.add(imgurl)
                    
                    if(self.senderId != id as? String ){
                        if(status == "0"){
                            let childRef23 = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                           // let childRef24 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                            
                            //let key = childRef.childByAutoId().key
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            let result = formatter.string(from: date)
                            let fullNameArr = result.components(separatedBy: " ")
                            
                            // let name    = fullNameArr[0]
                            let surname = fullNameArr[1]
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:surname)
                            dateFormatter1.dateFormat = "hh:mm a"
                            let starting_time = dateFormatter1.string(from:date1!)
                            
                            let message = ["sender_id":id as! String,"receiver_id":rece_id,"sender_name":name!,"text":text,"timestamp":time!,"status":"1","time":starting_time,"type":"text","pic_url":"","chat_id":chat_id] as [String : Any]
                            childRef23.child(key1).updateChildValues(message)
                            //childRef24.child(key1).updateChildValues(message)
                            
                        }
                    }
                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
//                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                        
                         self.finishReceivingMessage()
                    }
                  
                    
                   
                    
                }
            }
           
            
          
        })
        
        
        
        let childRef25 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!).queryLimited(toLast:self.start_index)
        childRef25.keepSynced(true)
        childRef25.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject = artists.value as? [String: AnyObject]
                    //print(artistObject!)
                    //let artistObject = artists.value as? [String: AnyObject]
                    
                    let key1 = artists.key
                    print(key1)
                    
                    //let data        = (snapshot).value as? NSDictionary
                    //print(data!)
                    let id          = artistObject!["sender_id"]
                    let rece_id          = artistObject!["receiver_id"] as! String
                    let chat_id          = artistObject!["chat_id"] as! String
                    let name        = artistObject!["sender_name"]
                    let text        = artistObject!["text"]
                    let time        = artistObject!["timestamp"]
                    let status        = artistObject!["status"] as! String
                    let seenTime        = artistObject!["time"] as! String
//                    let message = JSQMessage(senderId: (id as! String) , displayName: (name as! String) , text: text as? String )
//                                        self.timearray.add(time!)
//                                        self.messages.add(message!)
//                                        self.seenTime.add(seenTime)
//                                        self.seenStatus.add(status)
                    if(self.senderId != id as? String ){
                        if(status == "0"){
                            //let childRef23 = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                            let childRef24 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                            
                            //let key = childRef.childByAutoId().key
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            let result = formatter.string(from: date)
                            let fullNameArr = result.components(separatedBy: " ")
                            
                            // let name    = fullNameArr[0]
                            let surname = fullNameArr[1]
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:surname)
                            dateFormatter1.dateFormat = "hh:mm a"
                            let starting_time = dateFormatter1.string(from:date1!)
                            
                            let message = ["sender_id":id as! String,"receiver_id":rece_id,"sender_name":name!,"text":text!,"timestamp":time!,"status":"1","time":starting_time,"type":"text","pic_url":"","chat_id":chat_id] as [String : Any]
                           // childRef23.child(key1).updateChildValues(message)
                            childRef24.child(key1).updateChildValues(message)
                            
                        }
                    }
                    //self.finishReceivingMessage()
                    
                }
            }
            
        })
        
        //}
        
        // }
        //                    !text.isEmpty
        //                {
        //                    if let message = JSQMessage(senderId: id as! String, displayName: name as! String, text: text as! String)
        //                    {
        //                        self.timearray.add(time as! String)
        //                        self.messages.add(message)
        //
        //                        self.finishReceivingMessage()
        //                    }
        //                }
        //                }
        //            }
        //}
        
    }
    

    
    
    func refresh() {
        
     
        
        let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!).queryLimited(toLast:self.start_index)
        
        childRef.keepSynced(true)
        
        
        childRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.childrenCount > 0 {
                self.timearray = []
                self.seenTime = []
                self.seenStatus = []
                self.messages = []
                self.chat_ids = []
                self.urls = []
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject = artists.value as? [String: AnyObject]
                    print(artistObject!)
                    //let artistObject = artists.value as? [String: AnyObject]
                    
                    let key1 = artists.key
                    print(key1)
                    
                    //let data        = (snapshot).value as? NSDictionary
                    //print(data!)
                    let id          = artistObject!["sender_id"]
                    let rece_id          = artistObject!["receiver_id"] as! String
                    let chat_id          = artistObject!["chat_id"] as! String
                    let name        = artistObject!["sender_name"]
                    let text        = artistObject!["text"] as! String
                    let time        = artistObject!["timestamp"]
                    let status        = artistObject!["status"] as! String
                    let seenTime        = artistObject!["time"] as! String
                    let type        = artistObject!["type"] as! String
                    let imgurl        = artistObject!["pic_url"] as! String
                    if(type == "image"){
                        
                        let imageView = AsyncPhotoMediaItem(withURL: URL(string: imgurl)!)
                        
                        
                        if id as? String == self.senderId {
                            imageView.appliesMediaViewMaskAsOutgoing = true
                            
                        }
                        else
                        {
                            imageView.appliesMediaViewMaskAsOutgoing = false
                            
                            
                        }
                        let message = JSQMessage(senderId:id as? String, displayName: name as? String, media: imageView)
                        
                        self.messages.add(message!)
                        
                        
                    }else if(type == "text"){
                        let message = JSQMessage(senderId: id as? String , displayName: name as? String , text: text )
                        self.messages.add(message!)
                    }
                   
                    self.timearray.add(time!)
                    
                    self.seenTime.add(seenTime)
                    self.seenStatus.add(status)
                    self.type.add(type)
                    self.chat_ids.add(chat_id)
                    self.urls.add(imgurl)
                    
                    if(self.senderId != id as? String ){
                        if(status == "0"){
                            let childRef23 = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                            // let childRef24 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                            
                            //let key = childRef.childByAutoId().key
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            let result = formatter.string(from: date)
                            let fullNameArr = result.components(separatedBy: " ")
                            
                            // let name    = fullNameArr[0]
                            let surname = fullNameArr[1]
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:surname)
                            dateFormatter1.dateFormat = "hh:mm a"
                            let starting_time = dateFormatter1.string(from:date1!)
                            
                            let message = ["sender_id":id as! String,"receiver_id":rece_id,"sender_name":name!,"text":text,"timestamp":time!,"status":"1","time":starting_time,"type":"text","pic_url":"","chat_id":chat_id] as [String : Any]
                            childRef23.child(key1).updateChildValues(message)
                            //childRef24.child(key1).updateChildValues(message)
                            
                        }
                    }
                   
                    DispatchQueue.main.async {
              
                        self.collectionView.reloadData()
                    
                    }
                    
                    
                    
                }
            }
            
            
            
        })
        
        
        
        let childRef25 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!).queryLimited(toLast:self.start_index)
        childRef25.keepSynced(true)
        childRef25.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.childrenCount > 0 {
                
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject = artists.value as? [String: AnyObject]
                    //print(artistObject!)
                    //let artistObject = artists.value as? [String: AnyObject]
                    
                    let key1 = artists.key
                    print(key1)
                    
                    //let data        = (snapshot).value as? NSDictionary
                    //print(data!)
                    let id          = artistObject!["sender_id"]
                    let rece_id          = artistObject!["receiver_id"] as! String
                    let chat_id          = artistObject!["chat_id"] as! String
                    let name        = artistObject!["sender_name"]
                    let text        = artistObject!["text"]
                    let time        = artistObject!["timestamp"]
                    let status        = artistObject!["status"] as! String
                    let seenTime        = artistObject!["time"] as! String
                    //                    let message = JSQMessage(senderId: (id as! String) , displayName: (name as! String) , text: text as? String )
                    //                                        self.timearray.add(time!)
                    //                                        self.messages.add(message!)
                    //                                        self.seenTime.add(seenTime)
                    //                                        self.seenStatus.add(status)
                    if(self.senderId != id as? String ){
                        if(status == "0"){
                            //let childRef23 = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                            let childRef24 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                            
                            //let key = childRef.childByAutoId().key
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            let result = formatter.string(from: date)
                            let fullNameArr = result.components(separatedBy: " ")
                            
                            // let name    = fullNameArr[0]
                            let surname = fullNameArr[1]
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:surname)
                            dateFormatter1.dateFormat = "hh:mm a"
                            let starting_time = dateFormatter1.string(from:date1!)
                            
                            let message = ["sender_id":id as! String,"receiver_id":rece_id,"sender_name":name!,"text":text!,"timestamp":time!,"status":"1","time":starting_time,"type":"text","pic_url":"","chat_id":chat_id] as [String : Any]
                            // childRef23.child(key1).updateChildValues(message)
                            childRef24.child(key1).updateChildValues(message)
                            
                        }
                    }
                    //self.finishReceivingMessage()
                    
                }
            }
            
        })
        
    }
    
  
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        self.showTypingIndicator = false
        
        childRef.removeValue()
        childRef1.removeValue()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
       
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        if(textView.text == nil || textView.text == "" || textView.text == " "){

            self.showTypingIndicator = false

            childRef.removeValue()
            childRef1.removeValue()


        }else{



            let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id]
            childRef.setValue(message)
            childRef1.setValue(message)




        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
    
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        childRef.observe(.value) { (snapshot) in
            let firebaseDic = snapshot.value as? [String: AnyObject]
            if(firebaseDic != nil){
                print(firebaseDic!)

                let r_id = firebaseDic!["receiver_id"] as! String
                if(self.senderId == r_id){
                    self.showTypingIndicator = true
                    self.scrollToBottom(animated: true)
                }else{
                    self.showTypingIndicator = false
                }
            }else{

                self.showTypingIndicator = false
            }

        }
        
        childRef1.observe(.value) { (snapshot) in
            let firebaseDic = snapshot.value as? [String: AnyObject]
            if(firebaseDic != nil){
                print(firebaseDic!)

                let r_id = firebaseDic!["receiver_id"] as! String
                if(self.senderId == r_id){
                    self.showTypingIndicator = true
                    self.scrollToBottom(animated: true)
                }else{
                    self.showTypingIndicator = false
                }
            }else{

                self.showTypingIndicator = false
            }

        }
    }
    
 
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {

        let message = self.messages[indexPath.row] as! JSQMessage
//       if message.isMediaMessage{
//
//
//
//
//        let photoImage = JSQPhotoMediaItem(image: message.media as? UIImage)
//
//            let message = JSQMessage(senderId:message.senderId, displayName:message.senderDisplayName, media: photoImage)
//
//            return (message)
//
//        }
        //else{
            
            return (message as JSQMessageData)
       // }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
        return (messages[indexPath.item] as AnyObject).senderId == senderId ? outgoingBubble : incomingBubble
        
    }
 
  

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
//        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
//        view1.backgroundColor = UIColor.init(red:64/255, green:151/255, blue:212/255, alpha: 1.0)
//        self.navigationController?.view.addSubview(view1)
        return (messages[indexPath.item] as AnyObject).senderId == senderId ? nil : NSAttributedString(string:"")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {

        return (messages[indexPath.item] as AnyObject).senderId == senderId ? 10 : 10
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {

        let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        
        let key = childRef.childByAutoId().key
        //let key1 = refchat1.childByAutoId().key
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let result = formatter.string(from: date)
//        let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id,"sender_name":UserDefaults.standard.string(forKey: "first_name")!+" "+UserDefaults.standard.string(forKey: "last_name")!,"text":text,"timestamp":result,"status":"0","time":""]
        let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id,"sender_name":UserDefaults.standard.string(forKey:"Username")!,"text":text,"timestamp":result,"status":"0","time":"","type":"text","pic_url":"","chat_id":key]
        
        
        childRef.child(key!).setValue(message)
        childRef1.child(key!).setValue(message)
        
        let childRef22 = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef222 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        self.showTypingIndicator = false
        
        childRef22.removeValue()
        childRef222.removeValue()
       
        let inbox = ["date":result,"msg":text,"timestamp":result,"rid":StaticData.singleton.receiver_id!,"status":"1","name":StaticData.singleton.receiver_name!,"pic":StaticData.singleton.receiver_img!]
        let inbox1 = ["date":result,"msg":text,"timestamp":result,"rid":UserDefaults.standard.string(forKey:"uid")!,"status":"0","name":UserDefaults.standard.string(forKey:"Username")!,"pic":UserDefaults.standard.string(forKey:"image_url")!]
        self.childRef30.child(UserDefaults.standard.string(forKey:"uid")!).child(StaticData.singleton.receiver_id!).updateChildValues(inbox as [AnyHashable : Any])
        
        self.childRef31.child(StaticData.singleton.receiver_id!).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(inbox1 as [AnyHashable : Any])
       
        self.childRef32.child(UserDefaults.standard.string(forKey:"uid")!).child(StaticData.singleton.receiver_id!).removeValue()
    
            Database.database().reference().child("Users").child(StaticData.singleton.receiver_id!).observeSingleEvent(of: .value) {
                (snapshot) in
                 let firebaseDic = snapshot.value as? [String: AnyObject]
                if let phoneDB = firebaseDic?["token"] as? String {
                    let notkey =  Database.database().reference().child("notifications").key
                    Database.database().reference().child("notifications").child(UserDefaults.standard.string(forKey:"uid")!).child(notkey!).updateChildValues([
                        "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"message":text,"picture":"https://graph.facebook.com/1126252230860258/picture?width=500&width=500","token":phoneDB,"receiverid":StaticData.singleton.receiver_id!])
                }
        }
        
        
        finishSendingMessage()
        
        let url : String = StaticData.singleton.baseUrl!+"sendPushNotification"
        
        
        let parameter:[String:Any]?  = ["tokon":UserDefaults.standard.string(forKey:"DeviceToken")!,"title":UserDefaults.standard.string(forKey:"Username")!,"message":text,"icon":UserDefaults.standard.string(forKey:"image_url")!,"senderid":UserDefaults.standard.string(forKey:"uid")!,"receiverid":StaticData.singleton.receiver_id!,"action_type":"message"]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    
                    
                    
                }
                    
                else{
                    
                    
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                
                
                
            }
        })
        
        
        
        if(StaticData.singleton.matchORinbox == "match"){
            self.CallApi()
        }else{
            
        }
    }
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item] as! JSQMessage
        let typ = self.type[indexPath.item] as! String
       
        
        var isOutgoing = false
        
        if (message as AnyObject).senderId == senderId{
            isOutgoing = true
            
        }
        
        if isOutgoing {
           if message.isMediaMessage{
        
            
            }else{
            
            cell.textView.textColor = UIColor.white
            cell.textView.isUserInteractionEnabled = false
            cell.textView.textAlignment = .left
            }
            
        } else {
            if message.isMediaMessage{
             // cell.messageBubbleImageView.image = UIImage(named: "place")
            }else{
            
            cell.textView.textColor = UIColor.black
            cell.textView.isUserInteractionEnabled = false
            cell.textView.textAlignment = .left
            }
            
        }
        
        
        cell.cellTopLabel.font = UIFont(name: "Verdana", size:12)
        
        // cell.cellTopLabel.text =
        
        
        return cell
            
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {

        if indexPath.item == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.item] as? String
            print(str!)
            let myDate = dateFormatter.date(from:str!)
            
            
            return
                JSQMessagesTimestampFormatter.shared().attributedTimestamp(for:myDate)
        }
        
        if indexPath.item -  1 > 0{
            let previousMessage = self.timearray[indexPath.row-1] as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate2 = dateFormatter1.date(from:previousMessage!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.row] as? String
            let myDate = dateFormatter.date(from:str!)
            if  ( ( (myDate?.timeIntervalSince(myDate2!))! / 60) > 1){
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: myDate)
            }
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
 
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        if indexPath.item -  1 > 0{
            let previousMessage = self.timearray[indexPath.row-1] as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate2 = dateFormatter1.date(from:previousMessage!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.row] as? String
            let myDate = dateFormatter.date(from:str!)
            if  (((myDate?.timeIntervalSince(myDate2!))! / 60) > 1){
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {

        let message = self.messages[indexPath.item]
        let Str = self.seenTime[indexPath.item] as! String
      
        if(self.senderId == (message as AnyObject).senderId){
            if(self.seenStatus[indexPath.item] as! String == "1"){
                return NSAttributedString(string: "Seen at "+Str)
                
            }else{
                return NSAttributedString(string: "")
            }
            
        }else{
            
            return NSAttributedString(string: "")
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {

        return 20
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
      
        let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id]
        childRef.setValue(message)
        childRef1.setValue(message)
        
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
//        let Giphy = UIAlertAction(title: "Giphy", style: .default, handler: {
//            (_:UIAlertAction)in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let yourVC: GiphsViewController = storyboard.instantiateViewController(withIdentifier: "GiphsViewController") as! GiphsViewController
//
//            self.present(yourVC, animated: true, completion: nil)
//
//        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction)in
        
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
        
        self.showTypingIndicator = false
        
        childRef.removeValue()
        childRef1.removeValue()
        })
        actionSheet.addAction(camera)
       
        actionSheet.addAction(gallery)
        //actionSheet.addAction(Giphy)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
       
      
        self.dismiss(animated:true, completion: nil)
        let number = Int.random(in: 0 ... 1000)
        let pickedImage = info[.originalImage] as? UIImage
        let storageRef = Storage.storage().reference().child(String(number)+"_myImage.png")
        
       let sv = Chat1ViewController.displaySpinner(onView: self.view)
        
        if let uploadData = pickedImage!.jpeg(.lowest) {
   
         
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error ) in
         
                guard let metadata = metadata else{
                    print(error!)
                  
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    print(url!)
                    self.downloadURL = String(describing: url!)
                
                    let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                    _ = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                    
                    let key = childRef.childByAutoId().key
                    //let key1 = refchat1.childByAutoId().key
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let result = formatter.string(from: date)
                    
                    //        let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id,"sender_name":UserDefaults.standard.string(forKey: "first_name")!+" "+UserDefaults.standard.string(forKey: "last_name")!,"text":text,"timestamp":result,"status":"0","time":""]
                    
                   
                    let message = ["sender_id":UserDefaults.standard.string(forKey:"uid")!,"receiver_id":StaticData.singleton.receiver_id,"sender_name":UserDefaults.standard.string(forKey:"Username")!,"text":"","timestamp":result,"status":"0","time":"","type":"image","pic_url":self.downloadURL,"chat_id":key]
                    
                    let childRef2 = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                    let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                    let inbox = ["date":result,"msg":"send an image...","timestamp":result,"rid":StaticData.singleton.receiver_id!,"status":"1","name":StaticData.singleton.receiver_name!,"pic":StaticData.singleton.receiver_img!]
                    let inbox1 = ["date":result,"msg":"send an image...","timestamp":result,"rid":UserDefaults.standard.string(forKey:"uid")!,"status":"0","name":UserDefaults.standard.string(forKey:"Username")!,"pic":UserDefaults.standard.string(forKey:"image_url")!]
                    self.childRef30.child(UserDefaults.standard.string(forKey:"uid")!).child(StaticData.singleton.receiver_id!).updateChildValues(inbox as [AnyHashable : Any])
                    
                    self.childRef31.child(StaticData.singleton.receiver_id!).child(UserDefaults.standard.string(forKey:"uid")!).updateChildValues(inbox1 as [AnyHashable : Any])
                    
                    self.childRef32.child(UserDefaults.standard.string(forKey:"uid")!).child(StaticData.singleton.receiver_id!).removeValue()
                    
                    
                    
                    self.showTypingIndicator = false
                    SliderViewController.removeSpinner(spinner: sv)
                    
                   
                   
                    //self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    
                    childRef2.removeValue()
                    childRef1.removeValue()
                    
                    childRef.child(key!).updateChildValues(message as [AnyHashable : Any])
                    childRef.child(key!).updateChildValues(message as [AnyHashable : Any])
                    Database.database().reference().child("Users").child(StaticData.singleton.receiver_id!).observeSingleEvent(of: .value) {
                        (snapshot) in
                        let firebaseDic = snapshot.value as? [String: AnyObject]
                        if let phoneDB = firebaseDic?["token"] as? String {
                           
                            let notkey =  Database.database().reference().child("notifications").key
                            Database.database().reference().child("notifications").child(UserDefaults.standard.string(forKey:"uid")!).child(notkey!).updateChildValues([
                                "name":UserDefaults.standard.string(forKey:"first_name")!+" "+UserDefaults.standard.string(forKey:"last_name")!,"message":"sending an image....","picture":StaticData.singleton.receiver_img!,"token":phoneDB,"receiverid":StaticData.singleton.receiver_id!])
                        }
                    }
                    
                    self.finishSendingMessage()
                    
                    self.SendNotification()
                    
                    if(StaticData.singleton.matchORinbox == "match"){
                        self.CallApi()
                    }else{
                        
                    }
                    
                    guard let downloadURL = url else {
                        Chat1ViewController.removeSpinner(spinner: sv)
                        return
                    }
                }
            })
           
        }
        
        
        
    }
    
  
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        
       
        let childRef = Database.database().reference().child("typing_indicator").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
        let childRef1 = Database.database().reference().child("typing_indicator").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
            
            self.showTypingIndicator = false
            
            childRef.removeValue()
            childRef1.removeValue()
        
        self.dismiss(animated: true, completion: nil)
      
            
        
    }
    
    
    func SendNotification(){
        
        
         let url : String = StaticData.singleton.baseUrl!+"sendPushNotification"
        
        let parameter:[String:Any]?  = ["tokon":UserDefaults.standard.string(forKey:"DeviceToken")!,"title":UserDefaults.standard.string(forKey:"Username")!,"message":"Sent an image","icon":UserDefaults.standard.string(forKey:"image_url")!,"senderid":UserDefaults.standard.string(forKey:"uid")!,"receiverid":StaticData.singleton.receiver_id!,"action_type":"message"]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    
                    
                    
                }
                    
                else{
                    
                    
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                
                
                
            }
        })
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(indexPath.row)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) {
      
        
        let chat_id = self.chat_ids[indexPath.row] as! String
        let message = self.messages[indexPath.item] as! JSQMessage
       
        
        if (message as AnyObject).senderId == senderId{

            if (message.isMediaMessage) {
           
            let actionSheet =  UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Preview", style: .default, handler: {
                (_:UIAlertAction)in
               
                StaticData.singleton.UrlImage = self.urls[indexPath.row] as? String
                if(message.text == "Sticker"){

                    StaticData.singleton.isSticker = "yes"
                }else{
                    StaticData.singleton.isSticker = "no"
                }

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let yourVC: PreviewViewController = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController

                self.present(yourVC, animated: true, completion: nil)
            })
            
            let gallery = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (_:UIAlertAction)in
                
                
                let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                let childRef1 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
               
                
                childRef.child(chat_id).removeValue()
                childRef1.child(chat_id).removeValue()
                self.messages.removeObject(at:indexPath.row)
                self.finishReceivingMessage()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
            })
            actionSheet.addAction(camera)
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
           
            
            let gallery = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (_:UIAlertAction)in
                
                let childRef = Database.database().reference().child("chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+StaticData.singleton.receiver_id!)
                let childRef1 = Database.database().reference().child("chat").child(StaticData.singleton.receiver_id!+"-"+UserDefaults.standard.string(forKey:"uid")!)
                
                
                childRef.child(chat_id).removeValue()
                childRef1.child(chat_id).removeValue()
                self.messages.removeObject(at:indexPath.row)
                self.finishReceivingMessage()
               
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_:UIAlertAction)in
                
            })
           
            
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview() // This will remove image from full screen
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.start_index = self.start_index+20
        self.refresh()
    }
       
    
    
    func CallApi(){
        
        let url : String = StaticData.singleton.baseUrl!+"firstchat"
       
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey:"uid")!,"effected_id":StaticData.singleton.receiver_id!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
               
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! String
                if(String(describing: code) == "200"){
                    
                   
                    
                }
                    
                else{
                    
                    
                   
                    
                }
                
                
            case .failure(let error):
                
                print(error)
              
                
                
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
extension Chat1ViewController {
    class func displaySpinner(onView : UIView) -> UIView {
     let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.color = UIColor.init(red:255/255.0, green:101/255.0, blue:96/255.0, alpha: 1.0)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}



