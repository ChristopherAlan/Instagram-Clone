//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Christopher Alan on 12/28/14.
//  Copyright (c) 2014 CA Studios. All rights reserved.
//

import UIKit

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var photoSelected:Bool = false
    
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var shareText: UITextField!
    
    @IBAction func selectImage(sender: AnyObject) {
    
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        var error = ""
        if photoSelected == false {
            error = "Please select an image to post."
            
        } else if shareText == "" {
            error = "Please enter a description."
            
        }
        
        if error != "" {
            
            displayAlert("Error", error: error)
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                
                if success == false {
                    
                    activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.displayAlert("Error", error: "Please try again later.")
                
                } else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    
                    post["ImageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                        
                        activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            
                            self.displayAlert("Error", error: "Please try again later.")
                            
                        } else {
                            
                            self.displayAlert("Image Posted", error: "Your image has posted successfully!")
                            
                            // resets on each load.
                            self.photoSelected = false
                            self.imageToPost.image = UIImage(named: "placeholder-image.jpg")
                            self.shareText.text = ""
                            
                            println("Posted successfully")
                        }
                    }
                    
                }
            
            }
        }
        
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        //self.performSegueWithIdentifier("logout", sender: self)
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        photoSelected = true
    }
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // resets on each load.
        photoSelected = false
        imageToPost.image = UIImage(named: "placeholder-image.jpg")
        shareText.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
