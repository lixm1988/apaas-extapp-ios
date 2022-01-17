//
//  AgoraRenderSpreadWidgetDT.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/7.
//

import Foundation

class AgoraRenderSpreadWidgetDT {
    lazy var logFolder: String = {
        let cachesFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                               .userDomainMask,
                                                               true)[0]
        let folder = cachesFolder.appending("/AgoraLog")
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: folder,
                               isDirectory: nil) {
            try? manager.createDirectory(atPath: folder,
                                         withIntermediateDirectories: true,
                                         attributes: nil)
        }
        return folder
    }()
    
    var renderUserInfo: InAgoraSpreadRenderUserInfo? {
        didSet {
            guard let renderUser = renderUserInfo else {
                return
            }
//            spreadView.updateRenderInfo(renderInfo: renderUser.toViewInfo())
        }
    }
}
