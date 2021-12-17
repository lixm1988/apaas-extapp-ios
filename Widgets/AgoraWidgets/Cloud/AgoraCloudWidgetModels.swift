//
//  AgoraCloudWidgetModels.swift
//  AgoraWidgets
//
//  Created by LYY on 2021/12/17.
//

import Foundation
@objcMembers public class AgoraCloudCourseware: NSObject {
    public let resourceName: String
    public let resourceUuid: String
    public let scenePath: String
    public let resourceURL: String
    public let scenes: [AgoraCloudWhiteScene]
    /// 原始文件的扩展名
    public let ext: String
    /// 原始文件的大小 单位是字节
    public let size: Double
    /// 原始文件的更新时间
    public let updateTime: Double
    
    public init(resourceName: String,
                resourceUuid: String,
                scenePath: String,
                resourceURL: String,
                scenes: [AgoraCloudWhiteScene],
                ext: String,
                size: Double,
                updateTime: Double) {
        self.resourceName = resourceName
        self.resourceUuid = resourceUuid
        self.scenePath = scenePath
        self.resourceURL = resourceURL
        self.scenes = scenes
        self.ext = ext
        self.size = size
        self.updateTime = updateTime
    }
}

@objcMembers public class AgoraCloudWhiteScene: NSObject {
    public var name: String
    public var ppt: AgoraCloudWhitePptPage
    
    public init(name: String,
                ppt: AgoraCloudWhitePptPage) {
        self.name = name
        self.ppt = ppt
    }
}

@objcMembers public class AgoraCloudWhitePptPage: NSObject {
    /// 图片的 URL 地址。
    public var src: String
    /// 图片的 URL 宽度。单位为像素。
    public var width: Float
    /// 图片的 URL 高度。单位为像素。
    public var height: Float
    /// 预览图片的 URL 地址
    public var previewURL: String?
    
    public init(src: String,
                width: Float,
                height: Float,
                previewURL: String?) {
        self.src = src
        self.width = width
        self.height = height
        self.previewURL = previewURL
    }
}
