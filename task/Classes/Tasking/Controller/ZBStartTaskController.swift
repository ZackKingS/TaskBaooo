//
//  ZBStartTaskController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/27.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import Alamofire
import SwiftyJSON

import  SVProgressHUD
class ZBStartTaskController: UIViewController  ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
       //MARK:======================  属性  ============================
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var picV: UIImageView!
    
    @IBOutlet weak var takeCame: UIButton!
    
    
    @IBOutlet weak var pivH: NSLayoutConstraint!
    
    @IBOutlet weak var btnCons: NSLayoutConstraint!
    
    var taskid :String?
    
    static  var picImage :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        if isIPhone6 {
            
            pivH.constant = 130
            btnCons.constant = -10
        }
        
        
        
    }
    
    // 完成拍照
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let mediaType = info[UIImagePickerControllerMediaType] as! String;
        if mediaType == kUTTypeImage as String { // 图片类型
            var image: UIImage? = nil

            if picker.isEditing { // 拍照图片运行编辑，则优先尝试从编辑后的类型中获取图片
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            }else{
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            picV.image = image;
            
            ZBStartTaskController.picImage = image
            

        }
    }
  
    

  
    //MARK:=============================  添加图片   ============================
    
    @IBAction func photoComeIn(_ sender: Any) {
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        alert.view.tintColor = UIColor.black
        
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
            self.selectByCamera()
        }
        
        let actionPhoto = UIAlertAction.init(title: "从手机照片中选择", style: .default) { (UIAlertAction) -> Void in
            self.selectFromPhoto()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // 拍照获取
    private func selectByCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera // 调用摄像头
        imagePicker.cameraDevice = .rear // 后置摄像头拍照
        imagePicker.cameraCaptureMode = .photo // 拍照
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        imagePicker.modalPresentationStyle = .popover
        self.show(imagePicker, sender: nil)
    }
    
    
    /**
     * 用户相册未授权，Dialog提示
     */
    private func showNoPermissionDailog(){
        let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    /**
     * 从相册中选择图片
     */
    private func selectFromPhoto(){
        PHPhotoLibrary.requestAuthorization {[unowned self] (status) -> Void in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.showLocalPhotoGallery()
                    break
                default:
                    self.showNoPermissionDailog()
                    break
                }
            }
        }
    }
    /**
     * 打开本地相册列表
     */
    private func showLocalPhotoGallery(){
       let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum // 调用摄像头
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        imagePicker.modalPresentationStyle = .popover
        self.show(imagePicker, sender: nil)
    }

    
    
    
    
       //MARK:=============================  上传图片 ===========================
    @IBAction func next(_ sender: Any) {
        
  
        if picV.image == nil  {
            
//            SVProgressHUD.showInfo(withStatus: "请上传照片")
            self.showHint(hint: "请上传照片")
            return
            
        }
        
        
//        SVProgressHUD.show()
        
        let data = UIImageJPEGRepresentation( ZBStartTaskController.picImage!, 0.5)!
        
        let para = ["userid":User.GetUser().id,"taskid":taskid]
        upLoadImageRequest(urlString: API_UPLOADIMAGE_URL, params: para as! [String : String], data:data, name: ["result"], success: { (dic ) in
            print(dic)
        }, failture: { (error) in
            
            print(error)
            
        })

 
    }
    
    

    func upLoadImageRequest(urlString : String, params:[String:String], data: Data, name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in

                multipartFormData.append((params["userid"]!.data(using: String.Encoding.utf8)!), withName: "userid")
                multipartFormData.append( (params["taskid"]!.data(using: String.Encoding.utf8)!), withName: "taskid")
                multipartFormData.append( data, withName: "result", fileName: "na.png", mimeType: "image/jpeg")
        },
            to: API_UPLOADIMAGE_URL,
            
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        SVProgressHUD.dismiss()
                        
                        
                        let  under = ZBTaskUnderReviewController()
                        under.taskid = self.taskid
                        self.navigationController?.pushViewController(under , animated: true)
                        
                    }
         
               
                   
                case .failure(let encodingError):
                    print(encodingError)
                    
                  
                      self.showHint(hint: "上传失败")
                }
        }
        )
        
        
    }
    
    
    
     //MARK:============================= 配置 ============================
    
    func setConfig(){
        
        topView.layer.masksToBounds = true;
        topView.layer.borderWidth = 1
        topView.layer.borderColor  = UIColor.init(r: 179, g: 179, b: 179 ).cgColor
        topView.layer.cornerRadius = 8
        bottomView.layer.masksToBounds = true;
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor  = UIColor.init(r: 179, g: 179, b: 179 ).cgColor
        bottomView.layer.cornerRadius = 8
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "开始任务";
        
        nextBtn.layer.cornerRadius = kScornerRadius
        nextBtn.layer.masksToBounds = true
        
    }


}
