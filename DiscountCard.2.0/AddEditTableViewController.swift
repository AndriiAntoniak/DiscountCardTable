//
//  AddEditTableViewController.swift
//  DiscountCard.2.0
//
//  Created by Andrii Antoniak on 10/31/17.
//  Copyright © 2017 Andrii Antoniak. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation

class AddEditTableViewController: UITableViewController, UIImagePickerControllerDelegate ,
UINavigationControllerDelegate,ScannerResultDelegate{
    
    
    
    var boolEditValue = false
    
    private var cardMan = CardManager()
    
    var editCard : Card?
    
    var addCard : Card?
    
    private var whatIsImage : String?
    
    @IBOutlet weak var frontImageOutlet: UIImageView!
    
    @IBOutlet weak var backImageOutlet: UIImageView!
    
    @IBOutlet weak var titleFiled: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var barcodeImage: UIImageView!
    
    // outlet for button called _Create Barcode_
    @IBOutlet weak var barcodeString: UIButton!
    
    
    //func for adding front image
    @IBAction func addFrontImage(_ sender: UIButton) {
        whatIsImage = "front"
        if frontImageOutlet.image != nil{
        frontImageOutlet.backgroundColor = UIColor.white
        frontImageOutlet.alpha = 1.0
        }
        executeAddingImage()
       
        qwe()
    }
    
    func qwe(){
        performSegue(withIdentifier: "fromAddToCrop", sender: frontImageOutlet.image)
    }
    
    
    //func for adding back image
    @IBAction func addBackImage(_ sender: UIButton) {
        whatIsImage = "back"
        if backImageOutlet.image != nil{
            backImageOutlet.backgroundColor = UIColor.white
            backImageOutlet.alpha = 1.0
        }
        executeAddingImage()
        
        performSegue(withIdentifier: "fromAddToCrop", sender: backImageOutlet.image)
    }
    
    //func for image picker controller
    func executeAddingImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let addImage = UIAlertController(title: "Photo Source", message: "Choose a source of photo", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        addImage.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                let closeAlertAction = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                closeAlertAction.addAction(alertAction)
                self.present(closeAlertAction, animated: true, completion: nil)
            }
        }))
        
        addImage.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        addImage.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addImage, animated: true, completion: nil)
        
        
        
        //
    }
    
   
    
    func returnStringBarcode(barcode str: String) {
        print("-------------------------------------------------------------")
        print("-------------------------------------------------------------")
        self.barcodeString.setTitle(str , for: .normal)
        self.barcodeImage.image = RSUnifiedCodeGenerator.shared.generateCode(self.barcodeString.currentTitle!, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
    }
    
    //Action for button called _Create Button_
    @IBAction func buttonForCreatingBarcode(_ sender: UIButton) {
        
        let addBarcode = UIAlertController(title: "Creating barcode", message: "Choose a way for creating barcode", preferredStyle: UIAlertControllerStyle.actionSheet)

        addBarcode.addAction(UIAlertAction(title: "Generate", style: .default, handler: {(action:UIAlertAction) in
           let textFieldAlertController = UIAlertController(title: "Generate", message: "Please,enter barcode", preferredStyle: .alert)
            
            textFieldAlertController.addTextField{ (textField) in textField.text = "" }
            
            textFieldAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction) in
                let textField = textFieldAlertController.textFields![0]
                self.barcodeString.setTitle(textField.text , for: .normal)
                self.barcodeImage.image = RSUnifiedCodeGenerator.shared.generateCode(self.barcodeString.currentTitle!, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
            }))
           
            let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            textFieldAlertController.addAction(alertAction)
            
            self.present(textFieldAlertController, animated: true, completion: nil)
 
        }))
        
        addBarcode.addAction(UIAlertAction(title: "Scan", style: .default, handler: {(action:UIAlertAction) in
            if TARGET_OS_SIMULATOR == 0{
                self.performSegue(withIdentifier: "fromAddToScanner", sender: nil)
            }else{
                let closeAlertAction = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                closeAlertAction.addAction(alertAction)
                self.present(closeAlertAction, animated: true, completion: nil)
            }
        }))
        //TODO: SCAn
        addBarcode.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(addBarcode, animated: true, completion: nil)
    
        //
        
        //
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifaer = segue.identifier
        if identifaer == "fromAddToScanner"{
        let scann = segue.destination as? ScannerViewController
         scann?.delegate = self
        }else if identifaer == "fromAddToCrop"{
            let crop = segue.destination as? CropImageViewController
            crop?.image = sender as? UIImage
        }
    }
    
    
    //MARK: Choosing color filter, only one is possible !!!
    
    @IBOutlet weak var redColorFilter: UIButton!
    
    @IBOutlet weak var orangeColorFilter: UIButton!
    
    @IBOutlet weak var yellowColorFilter: UIButton!
    
    @IBOutlet weak var greenColorFilter: UIButton!
    
    @IBOutlet weak var blueColorFilter: UIButton!
    
    @IBOutlet weak var violetColorFilter: UIButton!
    
    public var filterColorDictionary :[UIButton:String] = [:]
    
    @IBAction func choosingColorFilter(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.white{
            for filter in filterColorDictionary{
                filter.key.backgroundColor = UIColor.white
            }
            sender.backgroundColor = sender.borderColor
            //
        }else{
            sender.backgroundColor = UIColor.white
        }
        
    }
    
    
    
    // MARK: Image picker controller delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if whatIsImage == "front"{
            frontImageOutlet.image = image
        }else{
            backImageOutlet.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //TODO: function for lighting
    func lightUpGaps(){
        if frontImageOutlet.image == nil{
            frontImageOutlet.backgroundColor = UIColor.red
            frontImageOutlet.alpha = 0.7
        }
        if backImageOutlet.image == nil{
            backImageOutlet.backgroundColor = UIColor.red
            backImageOutlet.alpha = 0.7
        }
        if titleFiled == nil || titleFiled.text == ""{
            titleFiled.backgroundColor = UIColor.red
            titleFiled.alpha = 0.7
        }
    }
    
    
    
    
    // exchange backgroundcolor
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        titleFiled.backgroundColor = UIColor.white
        titleFiled.alpha = 1.0
    }
    
    
    
    @IBAction func SaveCardButton(_ sender: UIButton) {
        
        if frontImageOutlet.image != nil && backImageOutlet.image != nil && titleFiled.text != ""{
            //TODO: ALL REGUIRED IS NOT NILL THAN OKEY
            if boolEditValue{
                editExistCard()
            }else{
                addNewCard()
            }
            performSegue(withIdentifier: "EditToCardTable", sender: nil)
        }else{
            //TODO: Function which light up your not filled gaps
            let closeAlertAction = UIAlertController(title: "Error", message: "Please fill all required (red) fields", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            closeAlertAction.addAction(alertAction)
            self.present(closeAlertAction, animated: true, completion: nil)
            lightUpGaps()
            //TODO function which light up my not filled gaps
        }
    }
    
    
    func fillDictionary(){
        filterColorDictionary[redColorFilter] = "Red"
        filterColorDictionary[orangeColorFilter] = "Orange"
        filterColorDictionary[yellowColorFilter] = "Yellow"
        filterColorDictionary[greenColorFilter] = "Green"
        filterColorDictionary[blueColorFilter] = "Blue"
        filterColorDictionary[violetColorFilter] = "Violet"
    }
    
    
    //
    var cropImage : UIImage?
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        
        fillDictionary()
        if cropImage != nil{
            frontImageOutlet.image = cropImage
        }
        if editCard != nil{
            boolEditValue = true
            insertCartValueWhichMustEditing()
            
        }
    }
    
    func insertCartValueWhichMustEditing(){
        if editCard?.barcode != nil{
            barcodeString.setTitle(editCard?.barcode, for: .normal)
            barcodeImage.image = RSUnifiedCodeGenerator.shared.generateCode(barcodeString.currentTitle!, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
            barcodeString.isEnabled = false
        }
        titleFiled.text = editCard?.title
        for filter in filterColorDictionary{
            if filter.value == editCard?.filterColor{
                filter.key.backgroundColor = filter.key.borderColor
                break
            }
        }
        
        frontImageOutlet.image = cardMan.loadImageFromPath(path: (editCard?.frontImage)!)
        backImageOutlet.image = cardMan.loadImageFromPath(path: (editCard?.backImage)!)
        
        descriptionTextView.text = editCard?.descriptionCard ?? nil
     
    }
    
    
    //func for editing exist card
    func editExistCard(){
        if barcodeString.isEnabled{
            editCard?.barcode = barcodeString.currentTitle
        }
        editCard?.title = titleFiled.text
        fillDictionary()
        for filter in filterColorDictionary{
            if filter.key.backgroundColor != UIColor.white{
                editCard?.filterColor = filter.value
                break
            }
        }
        editCard?.frontImage = cardMan.addToUrl(frontImageOutlet.image!)
        editCard?.backImage = cardMan.addToUrl(backImageOutlet.image!)
        editCard?.descriptionCard = descriptionTextView.text
    }
    
    //func for adding new card
    func addNewCard(){
        addCard = Card()
        addCard?.date = Date()
        addCard?.title = titleFiled.text
        for filter in filterColorDictionary{
            if filter.key.backgroundColor != UIColor.white{
                addCard?.filterColor = filter.value
                break
            }
        }
        addCard?.frontImage = cardMan.addToUrl(frontImageOutlet.image!)
        addCard?.backImage = cardMan.addToUrl(backImageOutlet.image!)
        addCard?.barcode = barcodeString.currentTitle
        addCard?.descriptionCard = descriptionTextView.text
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    
    
    
    
    
    
}//End main class




