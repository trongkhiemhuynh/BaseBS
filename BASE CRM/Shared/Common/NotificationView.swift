//
//  NotificationView.swift
//  BaseDemo
//
//  Created by macOS on 9/9/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var photos: [PhotosNotification] = []
    let pendingOperations = PendingOperations()
    
    @IBAction func didBack() {
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.register(NotificationTableViewCell.self)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.init(hex: "#EBEBEB")
        tableView.rowHeight = height100Cell
        
        btnBack.centerButtonAndImageWithSpacing(spacing: 8.0)
        
        setupDumData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

extension NotificationView : XibInitalization {
    typealias Element = NotificationView
}

extension NotificationView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        
        //1
        if cell.accessoryView == nil {
          let indicator = UIActivityIndicatorView(style: .gray)
          cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        //2 get item
        let photoDetails = photos[indexPath.row]
        
        cell.lblName.text = photoDetails.name
        
        cell.lblTime.text = "\(indexPath.row) minutes ago"
        cell.iv.image = photoDetails.image
        
        //4
        switch (photoDetails.state) {
        case .filtered:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            cell.lblTime.text = "Failed to load image"
        case .new, .downloaded:
            if !tableView.isDragging && !tableView.isDecelerating{
                startOperations(for: photoDetails, at: indexPath)
            }
            indicator.startAnimating()
        }
        
        return cell
    }
}

extension NotificationView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperation()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
          loadImagesForOnscreenCells()
          resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperation() {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
        //1
        if let pathsArray = tableView.indexPathsForVisibleRows {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            allPendingOperations.formUnion(pendingOperations.filtrationsInProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let recordToProcess = photos[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
}

extension NotificationView {
    func setupDumData() {
        for i in 0 ..< arrTitles.count {
            let url = URL(string: arrUrls[i])!
            let photo = PhotosNotification(name: arrTitles[i], url: url)
            
            photos.append(photo)
        }
    }
}

extension NotificationView {
    func startOperations(for photoRecord: PhotosNotification, at indexPath: IndexPath) {
      switch (photoRecord.state) {
      case .new:
        startDownload(for: photoRecord, at: indexPath)
      case .downloaded:
        startFiltration(for: photoRecord, at: indexPath)
      default:
        NSLog("do nothing")
      }
    }
    
    func startDownload(for photoRecord: PhotosNotification, at indexPath: IndexPath) {
      //1
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
          
      //2
      let downloader = ImageDownloader(photoRecord)
      
      //3
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }

        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      
      //4
      pendingOperations.downloadsInProgress[indexPath] = downloader
      
      //5
      pendingOperations.downloadQueue.addOperation(downloader)
    }
        
    func startFiltration(for photoRecord: PhotosNotification, at indexPath: IndexPath) {
      guard pendingOperations.filtrationsInProgress[indexPath] == nil else {
          return
      }
          
      let filterer = ImageFiltration(photoRecord)
      filterer.completionBlock = {
        if filterer.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      
      pendingOperations.filtrationsInProgress[indexPath] = filterer
      pendingOperations.filtrationQueue.addOperation(filterer)
    }
}

//extension NotificationView {
    let arrTitles = ["George Washington", "John Adams", "Thomas Jefferson",
    "James Madison","James Monroe","John Quincy Adams",
    "Andrew Jackson","Martin Van Buren",
     "William Henry Harrison", "John Tyler",
     "James K. Polk", "Zachary Taylor", "Millard Fillmore",
     "Franklin Pierce","James Buchanan","Abraham Lincoln","Andrew Johnson"]
    
    let arrUrls = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg/320px-Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/John_Adams%2C_Gilbert_Stuart%2C_c1800_1815.jpg/320px-John_Adams%2C_Gilbert_Stuart%2C_c1800_1815.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Thomas_Jefferson_by_Rembrandt_Peale%2C_1800.jpg/320px-Thomas_Jefferson_by_Rembrandt_Peale%2C_1800.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/James_Madison.jpg/320px-James_Madison.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/James_Monroe_White_House_portrait_1819.jpg/320px-James_Monroe_White_House_portrait_1819.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/JQA_Photo.tif/lossy-page1-320px-JQA_Photo.tif.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Andrew_jackson_head.jpg/330px-Andrew_jackson_head.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Martin_Van_Buren_edit.jpg/320px-Martin_Van_Buren_edit.jpg",

    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/William_Henry_Harrison_daguerreotype_edit.jpg/320px-William_Henry_Harrison_daguerreotype_edit.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/John_Tyler%2C_Jr.jpg/320px-John_Tyler%2C_Jr.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/JKP.jpg/320px-JKP.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Zachary_Taylor_restored_and_cropped.jpg/320px-Zachary_Taylor_restored_and_cropped.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Millard_Fillmore_by_Brady_Studio_1855-65-crop.jpg/320px-Millard_Fillmore_by_Brady_Studio_1855-65-crop.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Mathew_Brady_-_Franklin_Pierce_-_alternate_crop_%28cropped%29.jpg/320px-Mathew_Brady_-_Franklin_Pierce_-_alternate_crop_%28cropped%29.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/James_Buchanan.jpg/320px-James_Buchanan.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Abraham_Lincoln_O-77_matte_collodion_print.jpg/320px-Abraham_Lincoln_O-77_matte_collodion_print.jpg",
    
    "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Andrew_Johnson_photo_portrait_head_and_shoulders%2C_c1870-1880-Edit1.jpg/320px-Andrew_Johnson_photo_portrait_head_and_shoulders%2C_c1870-1880-Edit1.jpg"]
//}
