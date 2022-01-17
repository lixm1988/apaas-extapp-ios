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
    private(set) var contentView: UIView!
    private lazy var spreadView = AgoraRenderSpreadView(frame: .zero)
    private lazy var editView = AgoraSpreadEditView(frame: .zero)
    
    private var logger: AgoraLogger
    var dt: AgoraRenderSpreadWidgetDT
    
    // MARK: - AgoraBaseWidget
    public override init(widgetInfo: AgoraWidgetInfo) {
        self.dt = AgoraRenderSpreadWidgetDT()
        self.logger = AgoraLogger(folderPath: self.dt.logFolder,
                                  filePrefix: widgetInfo.widgetId,
                                  maximumNumberOfFiles: 5)
        
        super.init(widgetInfo: widgetInfo)
    }
    
    // MARK: widget callback
    public override func onLocalUserInfoUpdated(_ localUserInfo: AgoraWidgetUserInfo) {
        
    }
    
    public override func onMessageReceived(_ message: String) {
        log(.info,
            log: "onMessageReceived:\(message)")
        if let roomSignal = message.roomMessageToSignal(dt.renderUserInfo == nil) {
            handleRoomPropsMessage(roomSignal)
        } else if let vcSignal = message.vcMessageToSignal() {
            handleVCMessage(vcSignal)
        }
    }
    
    public override func onWidgetRoomPropertiesUpdated(_ properties: [String : Any],
                                                       cause: [String : Any]?,
                                                       keyPaths: [String]) {
        log(.info,
            log: properties.description)
    }

    public override func onWidgetRoomPropertiesDeleted(_ properties: [String : Any]?,
                                                       cause: [String : Any]?,
                                                       keyPaths: [String]) {
        log(.info,
            log: keyPaths.description)
    }
    
    func log(_ type: AgoraSpreadLogType,
             log: String) {
        switch type {
        case .info:
            logger.log("[RenderSpread widget] \(log)",
                       type: .info)
        case .warning:
            logger.log("[RenderSpread widget] \(log)",
                       type: .warning)
        case .error:
            logger.log("[RenderSpread widget] \(log)",
                       type: .error)
        default:
            logger.log("[RenderSpread widget] \(log)",
                       type: .info)
        }
    }
}

extension AgoraRenderSpreadWidget: AgoraRenderSpreadViewDelegate {
    func onChangeEditState(open: Bool) {
        guard info.localUserInfo.userRole != "teacher" else {
            return
        }
        // TODO: 教师操作
        editView.isHidden = !open
    }
    
    func onCloseSpreadView(_ view: AgoraBaseUIView) {
        guard info.localUserInfo.userRole != "teacher" else {
            return
        }
        // TODO: 教师操作
    }
}

fileprivate extension AgoraRenderSpreadWidget {
    func initViews() {
        view.backgroundColor = .clear
        view.addSubview(spreadView)
        view.addSubview(editView)
        view.isHidden = true
        spreadView.isHidden = true
        editView.isHidden = true
    }
    
    func initLayout() {
        spreadView.mas_makeConstraints { make in
            make?.top.left().bottom().right().equalTo()(self.view)
        }
        editView.mas_makeConstraints { make in
            make?.centerX.equalTo()(self.view.mas_centerX)
            make?.height.equalTo()(AgoraWidgetsFit.scale(30))
            make?.width.equalTo()(AgoraWidgetsFit.scale(138))
        }
    }
    
    func initData() {
        spreadView.delegate = self
    }
    
    func handleRoomPropsMessage(_ signal: AgoraSpreadInteractionSignal) {
        switch signal {
        case .start(let agoraSpreadRenderInfo):
            view.isHidden = false
            spreadView.isHidden = false
        case .stop:
            view.isHidden = true
            spreadView.isHidden = true
        default:
            break
        }
        sendMessage(signal)
    }
    
    func handleVCMessage(_ signal: AgoraSpreadInteractionSignal) {
        // TODO: 教师操作
    }
    
    func sendMessage(_ signal: AgoraSpreadInteractionSignal) {
        guard let text = signal.toMessageString() else {
            log(.error,
                log: "signal encode error!")
            return
        }
        sendMessage(text)
    }
}
