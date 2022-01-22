//
//  AgoraRenderSpreadModels.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/7.
//

import Foundation

struct AgoraSpreadExtraModel: Convertable, Equatable {
    var initial: Bool = true
    var userUuid: String = ""
    var streamUuid: String = ""
    var operatorId: String = ""
    
    static func == (lhs: Self,
                    rhs: Self) -> Bool {
        if lhs.initial == rhs.initial,
           lhs.userUuid == rhs.userUuid,
           lhs.streamUuid == rhs.streamUuid {
            return true
        }
        return false
    }
}

struct AgoraSpreadCondition {
    var frameFlag: Bool = false
    var extraFlag: Bool = false
    
    mutating func reset() {
        self.frameFlag = false
        self.extraFlag = false
    }
}

// MARK: To VC
struct AgoraSpreadUserInfo: Convertable {
    var userId: String
    var streamId: String
}

struct AgoraSpreadRenderInfo: Convertable {
    var frame: CGRect
    var user: AgoraSpreadUserInfo
}

enum AgoraSpreadInteractionSignal {
    case start(AgoraSpreadRenderInfo)
    case changeFrame(AgoraSpreadRenderInfo)
    case stop
    
    var rawValue: Int {
        switch self {
        case .start(_):         return 0
        case .changeFrame(_):   return 1
        case .stop:             return 2
        default:                return -1
        }
    }
    
    static func getType(rawValue: Int) -> Convertable.Type? {
        switch rawValue {
        case 0,1: return AgoraSpreadRenderInfo.self
        default:
            return nil
        }
    }
    
    static func makeSignal(rawValue: Int,
                           body: Convertable?) -> AgoraSpreadInteractionSignal? {
        switch rawValue {
        case 0:
            if let x = body as? AgoraSpreadRenderInfo {
                return .start(x)
            }
        case 1:
            if let x = body as? AgoraSpreadRenderInfo {
                return .changeFrame(x)
            }
        default:
            break
        }
        return nil
    }
}

// MARK: enum
enum AgoraSpreadLogType {
    case info, warning, error
}
