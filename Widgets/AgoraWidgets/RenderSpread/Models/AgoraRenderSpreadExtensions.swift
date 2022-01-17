//
//  AgoraRenderSpreadExtensions.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/7.
//

import Foundation

extension AgoraSpreadInteractionSignal {
    func toMessageString() -> String? {
        var dic = [String: Any]()
        dic["signal"] = self.rawValue
        switch self {
        case .start(let renderInfo):
            dic["body"] = renderInfo.toDictionary()
        case .changeFrame(let frameInfo):
            dic["body"] = frameInfo.toDictionary()
        default:
            break
        }
        return dic.jsonString()
    }
}

extension String {
    func roomMessageToSignal(_ firstRender: Bool) -> AgoraSpreadInteractionSignal? {
        guard let dic = self.json() else {
            return nil
        }
        if let remove = dic["remove"] as? Bool,
           remove {
            return .stop
        }
        
        guard let messageModel = AgoraSpreadRoomMessageModel.decode(dic) else {
            return nil
        }
        
        if messageModel.extra.initial {
            let user = AgoraSpreadUserInfo(userId: messageModel.extra.userId,
                                           streamId: messageModel.extra.streamId)
            if firstRender {
                let renderInfo = AgoraSpreadRenderInfo(position: messageModel.position,
                                                       size: messageModel.size,
                                                       user: user)
                return .start(renderInfo)
            } else {
                return .switchUser(user)
            }
        } else {
            let frame = AgoraSpreadFrameInfo(position: messageModel.position,
                                             size: messageModel.size)
            return .changeFrame(frame)
        }
    }
    
    func vcMessageToSignal() -> AgoraSpreadInteractionSignal? {
        guard let dic = self.json(),
              let signalRaw = dic["signal"] as? Int else {
            return nil
        }
        switch signalRaw {
        case AgoraSpreadInteractionSignal.stop.rawValue:        return .stop
        case AgoraSpreadInteractionSignal.editRect.rawValue:    return .editRect
        case AgoraSpreadInteractionSignal.editMirror.rawValue:  return .editMirror
        case AgoraSpreadInteractionSignal.editBright.rawValue:  return .editBright
        case AgoraSpreadInteractionSignal.editReset.rawValue:   return .editReset
        default:                                                break
        }
        
        guard let bodyDic = dic["body"] as? [String:Any],
              let type = AgoraSpreadInteractionSignal.getType(rawValue: signalRaw),
              let obj = try type.decode(bodyDic) else {
            return nil
        }
        return AgoraSpreadInteractionSignal.makeSignal(rawValue: signalRaw,
                                                      body: obj)
    }
}
