//
//  ViewController.swift
//  ECG
//
//  Created by Mohammad Ahmad on 13/05/22.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
 
    @IBOutlet var scanButton: UIButton!
    @IBOutlet var resultLabel: UITextView!
    @IBOutlet var capturedImage: UIImageView!
    
    var capturedImageList : [UIImage] = []
    
    private lazy var module: TorchModule = {
        if let filePath = Bundle.main.path(forResource: "model_lit1", ofType: "pt"),
            let module = TorchModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()
    
    private lazy var labels: [String] = {
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
            let labels = try? String(contentsOfFile: filePath) {
            return labels.components(separatedBy: .newlines)
        } else {
            fatalError("Can't find the text file!")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ECG graph classification"
        
        resultLabel.isUserInteractionEnabled = false
        
        capturedImage.layer.masksToBounds = true
        capturedImage.layer.borderWidth = 0.5
        capturedImage.layer.borderColor = UIColor.lightGray.cgColor
        capturedImage.layer.cornerRadius = 2
        
        if (capturedImageList.count == 0){
            capturedImage.image = UIImage(systemName: "photo.on.rectangle")
            
            resultLabel.text = "Please Scan your ECG."
        }
        scanButton.addTarget(self, action: #selector(configureDocumentView), for: .touchUpInside)

    }
    
    @objc private func configureDocumentView(){
        
      let scanningDocumentVC=VNDocumentCameraViewController()
       scanningDocumentVC.delegate=self
      self.present(scanningDocumentVC, animated: true, completion: nil)
        
    }

    func predict(ecgImage: UIImage){
        
        let resizedImage = ecgImage.resized(to: CGSize(width: 512, height: 512))
        guard var pixelBuffer = resizedImage.normalized() else {
            return
        }
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
            return
        }
        print("The prediction is -- ")
        print(outputs)
        
        let zippedResults = zip(labels.indices, outputs)
        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(3)
        var text = ""
        for result in sortedResults {
            print(result)
            text += "\u{2022} \(labels[result.0]) (\(result.1)) \n\n"
        }
        
        capturedImage.image = ecgImage
        resultLabel.text = text
    }

}

extension ViewController:VNDocumentCameraViewControllerDelegate{
  func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan){
    for pageNumber in 0..<scan.pageCount{
       let image=scan.imageOfPage(at: pageNumber)
       print(image)
        capturedImageList.append(image)
    }
      self.predict(ecgImage: capturedImageList.first!)
    controller.dismiss(animated: true, completion: nil)
  }
}

