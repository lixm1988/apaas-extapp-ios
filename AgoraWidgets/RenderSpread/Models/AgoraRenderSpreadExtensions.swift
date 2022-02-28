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
    func vcMessageToSignal() -> AgoraSpreadInteractionSignal? {
        guard let dic = self.toDic(),
              let signalRaw = dic["signal"] as? Int else {
            return nil
        }
        
        switch signalRaw {
        case AgoraSpreadInteractionSignal.stop.rawValue:            return .stop
        default:                                                    break
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
