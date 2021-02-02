//
//  BASEOperations.swift
//  BaseDemo
//
//  Created by macOS on 12/2/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

enum PhotoNotificationState {
    case new, downloaded, filtered, failed
}

class PhotosNotification {
    let name: String
    let url: URL
    var state = PhotoNotificationState.new
    var image = UIImage(named: "no_image")
    
    init(name:String, url:URL) {
      self.name = name
      self.url = url
    }
}

class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
  lazy var filtrationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Image Filtration queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}

class ImageDownloader: Operation {
  //1
  let photoRecord: PhotosNotification
  
  //2
  init(_ photoRecord: PhotosNotification) {
    self.photoRecord = photoRecord
  }
  
  //3
  override func main() {
    //4
    if isCancelled {
      return
    }

    //5
    guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
    
    //6
    if isCancelled {
      return
    }
    
    //7
    if !imageData.isEmpty {
      photoRecord.image = UIImage(data:imageData)
      photoRecord.state = .downloaded
    } else {
      photoRecord.state = .failed
      photoRecord.image = UIImage(named: "Failed")
    }
  }
}

class ImageFiltration: Operation {
  let photoRecord: PhotosNotification
  
  init(_ photoRecord: PhotosNotification) {
    self.photoRecord = photoRecord
  }
  
  override func main () {
    if isCancelled {
        return
    }
      
    guard self.photoRecord.state == .downloaded else {
      return
    }
      
    if let image = photoRecord.image,
       let filteredImage = applySepiaFilter(image) {
      photoRecord.image = filteredImage
      photoRecord.state = .filtered
    }
  }
    
    func applySepiaFilter(_ image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
      let inputImage = CIImage(data: data)
          
      if isCancelled {
        return nil
      }
          
      let context = CIContext(options: nil)
          
      guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      filter.setValue(0.8, forKey: "inputIntensity")
          
      if isCancelled {
        return nil
      }
          
      guard
        let outputImage = filter.outputImage,
        let outImage = context.createCGImage(outputImage, from: outputImage.extent)
      else {
        return nil
      }

      return UIImage(cgImage: outImage)
    }
}

class TestManager {
    class func loadImage(imageView: UIImageView, urlString: String, completion: @escaping (() -> Void)) {
        if let url = URL(string: urlString) {
            let pendingOperation = PendingOperations()
            let record = PhotosNotification(name: "saiyan", url: url)
            let imageDownloader = ImageDownloader(record)
            
            pendingOperation.downloadQueue.addOperation(imageDownloader)
            imageView.image = record.image
            let v = UIActivityIndicatorView(frame: imageView.bounds)
            v.startAnimating()
            imageView.addSubview(v)
            
            imageDownloader.completionBlock = {
                if record.state == .downloaded {
                    DispatchQueue.main.async {
                        imageView.image = record.image
                        v.removeFromSuperview()
                        completion()
                    }
                }
            }
        }
    }
}
