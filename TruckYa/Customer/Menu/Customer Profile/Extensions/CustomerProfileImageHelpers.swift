//
//  CustomerProfileImageHelpers.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Photos

extension CustomerProfileViewController {
    //Prompt
    func checkPhotoLibraryPermissions() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default: fatalError()
        }
    }
    fileprivate func checkCameraPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: break
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for clicking photo",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Please allow camera access for clicking photo",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.async() {
                    self.checkCameraPermissions()
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    internal func promptPhotosPickerMenu() {
        let alert = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
            self.handleSourceTypeCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (action) in
            self.handleSourceTypeGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    private func viewCurrentProfileImage() {
        
    }
    private func handleSourceTypeCamera() {
        checkCameraPermissions()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
    }
    private func handleSourceTypeGallery() {
        checkPhotoLibraryPermissions()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
    private func uploadImage(_ image: UIImage) {
        guard let userId:String = UserDefaults.standard.userID else {
            print("Error: UserID not set in UserDefaults")
            return
        }
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            print("Unable to get scaled compressed image")
            return
        }
        self.scaledProfileImage = scaledImage
        let imageName = [UUID().uuidString, String(Int(Date().timeIntervalSince1970)*1000)].joined(separator: "-") + ".jpg"
        print("Image Name => \(imageName)")
        DispatchQueue.main.async {
            self.callUpdateProfilePictureSequence(userId: userId, imageData: data, imageName: imageName)
            self.showProgressBar()
        }
    }
    internal func handleProfileUploadSuccess() {
        print("Handling Success")
        HapticFeedbackGenerator.generateFeedback(ofType: .Success)
        DispatchQueue.main.async {
            self.alertVC.dismiss(animated: true) {
                self.progressBar.setProgress(0.0, animated: false)
                self.progressTitleLabel.text = "0 %"
                AssertionModalController(title: "Updated").show()
                self.subView.profileImageURL = AppData.userDetails?.profilepic
            }
        }
    }
    func setupProgressAlertController() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("Cancelling Upload")
            ProfilePictureAPI.shared.uploadTask.cancel()
            ProfilePictureAPI.shared.uploadProgress = Progress(totalUnitCount: 0)
            self.alertVC.dismiss(animated: true, completion: {
                self.progressBar.setProgress(0, animated: false)
            })
        }
        alertVC.addAction(cancelAction)
        alertVC.view.addSubview(progressTitleLabel)
        alertVC.view.addSubview(progressBar)
        let constraintHeight = NSLayoutConstraint(
           item: alertVC.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
           NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 140)
        alertVC.view.addConstraint(constraintHeight)
    }
    
    func showProgressBar() {
        HapticFeedbackGenerator.generateFeedback(ofType: .Medium)
        self.present(alertVC, animated: true)
    }
}
extension CustomerProfileViewController: ProfilePictureUploadTaskDelegate {
    func getUploadProgress(progress: Progress) {
//        sleep(1)
        DispatchQueue.main.async {
            self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
            self.progressTitleLabel.text = "\(Int(progress.fractionCompleted * 100)) %"
        }
        if progressBar.progress == 1.0 {
            print("Progress Completed")
            DispatchQueue.main.async {
                self.alertVC.dismiss(animated: true, completion: {
                    self.progressTitleLabel.text = "0 %"
                    self.progressBar.setProgress(0.0, animated: false)
                })
            }
        }
        print("Upload Progress => \(Int(progress.fractionCompleted * 100)) %")
    }
}
extension CustomerProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImage(image)
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage(image)
        } else {
            print("Unknown stuff")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

