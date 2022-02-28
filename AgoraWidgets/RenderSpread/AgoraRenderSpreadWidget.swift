//
//  AgoraRenderSpreadWidget.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/7.
//

import Masonry
import AgoraLog
import AgoraWidget

@objcMembers public class AgoraRenderSpreadWidget: AgoraBaseWidget {
    private var logger: AgoraLogger
    
    private var curFrame: CGRect = .zero {
        didSet {
            if curFrame != oldValue {
                handleRoomProperties()
            }
        }
    }
    private var curExtra = AgoraSpreadExtraModel() {
        didSet {
            if curExtra != oldValue {
                handleRoomProperties()
            }
        }
    }
    
    private var initedFlag = false
    
    // MARK: - AgoraBaseWidget
    public override init(widgetInfo: AgoraWidgetInfo) {
        let cachesFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                               .userDomainMask,
                                                               true)[0]
        let logFolder = cachesFolder.appending("/AgoraLog")
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: logFolder,
                               isDirectory: nil) {
            try? manager.createDirectory(atPath: logFolder,
                                         withIntermediateDirectories: true,
                                         attributes: nil)
        }
        self.logger = AgoraLogger(folderPath: logFolder,
                                  filePrefix: widgetInfo.widgetId,
                                  maximumNumberOfFiles: 5)
        
        super.init(widgetInfo: widgetInfo)

    }
    
    // MARK: widget callback
    public override func onWidgetDidLoad() {
        if let roomProps = info.roomProperties,
           let spreadExtraModel = roomProps.toObj(AgoraSpreadExtraModel.self) {
            curExtra = spreadExtraModel
        }
        
        if info.syncFrame != .zero {
            curFrame = info.syncFrame
        }
        handleRoomProperties()
    }
    
    public override func onMessageReceived(_ message: String) {
        logInfo("onMessageReceived:\(message)")
        if let vcSignal = message.vcMessageToSignal() {
            handleVCMessage(vcSignal)
        }
    }
    
    public override func onWidgetRoomPropertiesUpdated(_ properties: [String : Any],
                                                       cause: [String : Any]?,
                                                       keyPaths: [String]) {
        logInfo(properties.description)
        if let spreadExtraModel = properties.toObj(AgoraSpreadExtraModel.self) {
            curExtra = spreadExtraModel
        }
    }
    
    public override func onSyncFrameUpdated(_ syncFrame: CGRect) {
        curFrame = syncFrame
    }
}

fileprivate extension AgoraRenderSpreadWidget {
    func handleRoomProperties() {
        guard curExtra != AgoraSpreadExtraModel(),
              curFrame != .zero else {
                  return
              }
        let streamId = info.widgetId.components(separatedBy: "-")[1]
        let user = AgoraSpreadUserInfo(userId: curExtra.userUuid,
                                       streamId: streamId)
        let renderInfo = AgoraSpreadRenderInfo(frame: curFrame,
                                               user: user)
        if initedFlag {
            sendMessage(.changeFrame(renderInfo))
        } else {
            sendMessage(.start(renderInfo))
            initedFlag = true
        }
    }
    
    func handleVCMessage(_ signal: AgoraSpreadInteractionSignal) {
        // TODO: 教师操作
        switch signal {
        case .start(let agoraSpreadRenderInfo):
            logInfo("SpreadUIController start")
            // updateUserProperties
            break
        case .changeFrame(let agoraSpreadRenderInfo):
            logInfo("SpreadUIController changeFrame")
            // updateUserProperties
            break
        case .stop:
            logInfo("SpreadUIController stop")
            // deleteUserProperties
            break
        default:
            break
        }
    }
    
    func sendMessage(_ signal: AgoraSpreadInteractionSignal) {
        guard let text = signal.toMessageString() else {
            logError("signal encode error!")
            return
        }
        sendMessage(text)
    }
    
    func logInfo(_ log: String) {
        logger.log("[RenderSpread Widget \(info.widgetId)] \(log)",
                   type: .info)
    }
    
    func logError(_ log: String) {
        logger.log("[RenderSpread Widget \(info.widgetId)] \(log)",
                   type: .error)
    }
}
