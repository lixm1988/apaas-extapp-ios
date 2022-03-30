//
//  AgoraStreamWindowWidget.swift
//  AgoraWidgets
//
//  Created by LYY on 2022/3/25.
//

import AgoraWidget

@objcMembers public class AgoraStreamWindowWidget: AgoraBaseWidget, AgoraWidgetLogTube {
    var logger: AgoraWidgetLogger
    
    var renderInfo: AgoraStreamWindowRenderInfo?
    
    override init(widgetInfo: AgoraWidgetInfo) {
        let logger = AgoraWidgetLogger(widgetId: widgetInfo.widgetId)
        #if DEBUG
        logger.isPrintOnConsole = true
        #endif
        self.logger = logger
        
        super.init(widgetInfo: widgetInfo)
    }
    
    public override func onWidgetDidLoad() {
        initData()
    }
}

private extension AgoraStreamWindowWidget {
    func sendMessage(_ signal: AgoraStreamWindowInteractionSignal) {
        if let message = signal.toMessageString() {
            sendMessage(message)
        }
    }
    
    func initData() {
        let streamId = String(info.widgetId.split(separator: "-")[1])
        
        guard let propsDic = info.roomProperties as? Dictionary<String, String>,
              let info = AgoraStreamWindowExtraInfo.decode(propsDic),
              streamId != "" else {
                  return
              }
        
        let renderInfo = AgoraStreamWindowRenderInfo(userUuid: info.userUuid,
                                                     streamId: streamId)
        self.renderInfo = renderInfo
        sendMessage(.RenderInfo(renderInfo))
    }
}
