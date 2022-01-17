//
//  AgoraRenderSpreadModels.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/7.
//

import Foundation

struct AgoraSpreadPositionModel: Convertable {
    var xaxis: Double
    var yaxis: Double
}

struct AgoraSpreadSizeModel: Convertable {
    var width: Double
    var height: Double
}

struct AgoraSpreadExtraModel: Convertable {
    var initial: Bool // 开启渲染/切换流:true，移动:false
    var userId: String
    var streamId: String
    var operatorId: String
}

struct AgoraSpreadRoomMessageModel: Convertable {
    var position: AgoraSpreadPositionModel
    var size: AgoraSpreadSizeModel
    var extra: AgoraSpreadExtraModel
}

// MARK: View
struct InAgoraSpreadRenderUserInfo {
    // userInfo
    var userId: String
    var userName: String
    var streamId: String
    
    // streamInfo
    var cameraState: AgoraSpreadDeviceState = .available
    var microState: AgoraSpreadDeviceState = .available
    var enableVideo: Bool = true
    var enableAudio: Bool = true
}

struct AgoraSpreadViewInfo {
    var userName = ""
    var isOnline = true
    var cameraState: AgoraSpreadDeviceState = .available
    var microState: AgoraSpreadDeviceState = .available
    var enableVideo: Bool = true
    var enableAudio: Bool = true
}

// MARK: To VC
struct AgoraSpreadUserInfo: Convertable {
    var userId: String
    var streamId: String
}

struct AgoraSpreadFrameInfo: Convertable {
    var position: AgoraSpreadPositionModel
    var size: AgoraSpreadSizeModel
}

struct AgoraSpreadRenderInfo: Convertable {
    var position: AgoraSpreadPositionModel
    var size: AgoraSpreadSizeModel
    var user: AgoraSpreadUserInfo
}

struct AgoraSpreadStateInfo: Convertable {
    var cameraState: AgoraSpreadDeviceState = .available
    var microState: AgoraSpreadDeviceState = .available
    var enableVideo: Bool = true
    var enableAudio: Bool = true
    var volum: Int = 0
}

enum AgoraSpreadInteractionSignal {
    case start(AgoraSpreadRenderInfo)
    case switchUser(AgoraSpreadUserInfo)
    case changeFrame(AgoraSpreadFrameInfo)
    case changeState(AgoraSpreadStateInfo)
    case stop
    case editRect
    case editMirror
    case editBright
    case editReset
    
    var rawValue: Int {
        switch self {
        case .start(_):         return 0
        case .switchUser(_):    return 1
        case .changeFrame(_):   return 2
        case .changeState(_):   return 3
        case .stop:             return 4
        case .editRect:         return 5
        case .editMirror:       return 6
        case .editBright:       return 7
        case .editReset:        return 8
        default:                return -1
        }
    }
    
    static func getType(rawValue: Int) -> Convertable.Type? {
        switch rawValue {
        case 0: return AgoraSpreadRenderInfo.self
        case 1: return AgoraSpreadUserInfo.self
        case 2: return AgoraSpreadFrameInfo.self
        case 3: return AgoraSpreadStateInfo.self
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
            if let x = body as? AgoraSpreadUserInfo {
                return .switchUser(x)
            }
        case 2:
            if let x = body as? AgoraSpreadFrameInfo {
                return .changeFrame(x)
            }
        case 3:
            if let x = body as? AgoraSpreadStateInfo {
                return .changeState(x)
            }
        default:
            break
        }
        return nil
    }
}

// MARK: enum
enum AgoraSpreadDeviceState: Int, Convertable {
    case available, invalid, close
}

enum AgoraSpreadLogType {
    case info, warning, error
}
