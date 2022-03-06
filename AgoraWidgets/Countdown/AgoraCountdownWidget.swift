//
//  AgoraCountdownWidget.swift
//  AgoraWidgets
//
//  Created by LYY on 2022/3/5.
//

import Armin
import Masonry
import AgoraLog
import AgoraWidget

@objcMembers public class AgoraCountdownWidget: AgoraBaseWidget {
    /**Data**/
    private var logger: AgoraLogger
    
    /**View**/
    private lazy var countdownView: AgoraCountdownView = {
        return AgoraCountdownView(delegate: self)
    }()
    
    private var curFrame: CGRect = .zero {
        didSet {
            if curFrame != oldValue {
                handleRoomProperties()
            }
        }
    }
    private var curExtra = AgoraCountdownExtraModel() {
        didSet {
            if curExtra != oldValue {
                handleRoomProperties()
            }
        }
    }
    
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
           let countdownExtraModel = roomProps.toObj(AgoraCountdownExtraModel.self) {
            curExtra = countdownExtraModel
        }
        
        if info.syncFrame != .zero {
            curFrame = info.syncFrame
        }
        
        if isTeacher {
            
        } else {
            view.addSubview(countdownView)
            countdownView.mas_makeConstraints { make in
//                make?.left.equalTo()(0)
//                make?.top.equalTo()(0)
//                make?.width.equalTo()(0)
//                make?.height.equalTo()(0)
                // TODO: temp
                make?.centerX.centerY().equalTo()(0)
                make?.width.equalTo()(195)
                make?.height.equalTo()(120)
            }
        }
        
        handleRoomProperties()
    }
    
    public override func onWidgetRoomPropertiesUpdated(_ properties: [String : Any],
                                                       cause: [String : Any]?,
                                                       keyPaths: [String]) {
        if let countdownExtraModel = properties.toObj(AgoraCountdownExtraModel.self) {
            curExtra = countdownExtraModel
        }
    }

    public override func onSyncFrameUpdated(_ syncFrame: CGRect) {
        curFrame = syncFrame
    }
    
    public override func onMessageReceived(_ message: String) {
        logInfo("onMessageReceived:\(message)")
        
        if let signal = message.toCountdownSignal() {
            // TODO: 教师更新frame，需要updateRoomProps
            switch signal {
            case .sendTimestamp(let ts):
                countdownView.invokeCountDown(duration: calculateCountdown(curTs: ts))
            default:
                break
            }
        }
    }
    
    deinit {
        countdownView.cancelCountDown()
    }
}

// MARK: - AgoraCountdownViewDelegate
extension AgoraCountdownWidget: AgoraCountdownViewDelegate {
    func countDownDidStop() {
        
    }
    func countDownUpTo(currrentSeconds: Int64) {
        
    }
}

// MARK: - private
private extension AgoraCountdownWidget {
    func handleRoomProperties() {
        guard curExtra != AgoraCountdownExtraModel() else {
                  return
              }
        if isTeacher {
            
        } else {
            switch curExtra.state {
            case .during:
                sendMessage(.getTimestamp)
                break
            case .initial:
                countdownView.cancelCountDown()
            default:
                break
            }
        }
    }
    
    // 根据服务端ts，extra的startTime及duration，计算出UI开始的倒计时
    func calculateCountdown(curTs: Int64) -> Int64 {
        let timeGap = (curTs - curExtra.startTime) / 1000
        let gap = (timeGap < 0) ? 0 : timeGap
        let duration = curExtra.duration - gap
        return (duration < 0) ? 0 : duration
    }
    
    func sendMessage(_ signal: AgoraCountdownInteractionSignal) {
        guard let text = signal.toMessageString() else {
            logError("signal encode error!")
            return
        }
        sendMessage(text)
    }
    
    func logInfo(_ log: String) {
        logger.log("[Poller Widget \(info.widgetId)] \(log)",
                   type: .info)
    }
    
    func logError(_ log: String) {
        logger.log("[Poller Widget \(info.widgetId)] \(log)",
                   type: .error)
    }
}
