//
//  ViewController.swift
//  seaFood
//
//  Created by krutika on 2/15/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idetifierableLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }

    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let imageCI = CIImage(image: userPickedImage) else{
                fatalError("Couldn't convert")
            }
            detectImage(image: imageCI)
        }
        dismiss(animated: true, completion: nil)

        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func detectImage(image : CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Couldn't get model")
        }
        let requestCoreMl = VNCoreMLRequest(model: model) { [self] (request, error) in
            guard let result = request.results as? [VNClassificationObservation]else{
                fatalError("Couldn't get result")
            }
            print(result)
            if let  re = result.first{
                idetifierableLbl.text = re.identifier + String(re.confidence * 100)
                
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([requestCoreMl])
        }catch{
            
        }
        
        
        
    }
}

