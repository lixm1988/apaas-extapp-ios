//
//  AgoraWhiteboardExtensions.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2021/12/3.
//

import Foundation
import Whiteboard

// MARK: - from Whiteboard
extension WhiteApplianceNameKey {
    func toWidget() -> AgoraBoardToolType {
        switch self {
        case .ApplianceSelector:        return .Selector
        case .ApplianceText:            return .Text
        case .ApplianceRectangle:       return .Rectangle
        case .ApplianceEllipse:         return .Ellipse
        case .ApplianceEraser:          return .Eraser
        case .AppliancePencil:          return .Pencil
        case .ApplianceArrow:           return .Arrow
        case .ApplianceStraight:        return .Straight
        case .ApplianceLaserPointer:    return .Pointer
        case .ApplianceClicker:         return .Clicker
        case .ApplianceShape:           return .Shape
        default:                        return .Selector
        }
    }
}

extension WhiteApplianceShapeTypeKey {
    func toWidget() -> AgoraBoardToolShapeType {
        switch self {
        case .ApplianceShapeTypeTriangle:       return .Triangle
        case .ApplianceShapeTypeRhombus:        return .Rhombus
        case .ApplianceShapeTypePentagram:      return .Pentagram
        case .ApplianceShapeTypeSpeechBalloon:  return .Ballon
        default:                                return .Triangle
        }
    }
}

extension WhiteRoomPhase {
    func toWidget() -> AgoraBoardRoomPhase {
        switch self {
        case .connecting:      return .Connecting
        case .connected:       return .Connected
        case .reconnecting:    return .Reconnecting
        case .disconnecting:   return .Disconnecting
        case .disconnected:    return .Disconnected
        default:
            return .Disconnected
        }
    }
    
    var strValue: String {
        switch self {
        case .connecting:      return "Connecting"
        case .connected:       return "Connected"
        case .reconnecting:    return "Reconnecting"
        case .disconnecting:   return "Disconnecting"
        case .disconnected:    return "Disconnected"
        default:
            return "Disconnected"
        }
    }
}

extension WhiteCameraState {
    func toWidget() -> AgoraWhiteBoardCameraConfig {
        var config = AgoraWhiteBoardCameraConfig()
        config.centerX = CGFloat(self.centerX)
        config.centerY = CGFloat(self.centerY)
        config.scale = CGFloat(self.scale)
        return config
    }
}

extension WhiteReadonlyMemberState {
    func toMemberState() -> WhiteMemberState {
        var state = WhiteMemberState()
        state.currentApplianceName = self.currentApplianceName
        state.strokeColor = self.strokeColor
        state.strokeWidth = self.strokeWidth
        state.textSize = self.textSize
        state.shapeType = self.shapeType
        return state
    }
}

extension WhiteWindowBoxState {
    func toWidget() -> AgoraBoardWindowState? {
        switch self {
        case .mini:     return .min
        case .max:      return .max
        case .normal:   return .normal
        default:        return nil
        }
    }
}

// MARK: - from Widget
extension AgoraWhiteBoardCameraConfig {
    func toNetless() -> WhiteCameraConfig {
        var cameraState  = WhiteCameraConfig()
        cameraState.centerX = NSNumber(nonretainedObject: self.centerX)
        cameraState.centerY = NSNumber(nonretainedObject:self.centerY)
        cameraState.scale = NSNumber(nonretainedObject:self.scale)
        return cameraState
    }
}

extension AgoraBoardToolType {
    func toNetless() -> WhiteApplianceNameKey {
        switch self {
        case .Selector:     return .ApplianceSelector
        case .Text:         return .ApplianceText
        case .Rectangle:    return .ApplianceRectangle
        case .Ellipse:      return .ApplianceEllipse
        case .Eraser:       return .ApplianceEraser
        case .Pencil:       return .AppliancePencil
        case .Arrow:        return .ApplianceArrow
        case .Straight:     return .ApplianceStraight
        case .Pointer:      return .ApplianceLaserPointer
        case .Clicker:      return .ApplianceClicker
        case .Shape:        return .ApplianceShape
        default:
            return .ApplianceSelector
        }
    }
}

extension AgoraBoardToolShapeType {
    func toNetless() -> WhiteApplianceShapeTypeKey {
        switch self {
        case .Triangle:     return .ApplianceShapeTypeTriangle
        case .Rhombus:      return .ApplianceShapeTypeRhombus
        case .Pentagram:    return .ApplianceShapeTypePentagram
        case .Ballon:       return .ApplianceShapeTypeSpeechBalloon
        }
    }
}

extension AgoraBoardMemberState {
    init(_ state: WhiteReadonlyMemberState) {
        var toolType = state.currentApplianceName.toWidget()
        var colorArr = Array<Int>()
        var strokeWidth: Int?
        var textSize: Int?
        var shape: AgoraBoardToolShapeType?

        state.strokeColor.forEach { number in
            colorArr.append(number.intValue)
        }
        
        if let width = state.strokeWidth {
            strokeWidth = width.intValue
        }
        
        if let stateTextSize = state.textSize {
            textSize = stateTextSize.intValue
        }
        
        if let shapeType = state.shapeType {
            shape = shapeType.toWidget()
        }

        self.init(activeApplianceType: toolType,
                  strokeColor: colorArr,
                  strokeWidth: strokeWidth,
                  textSize: textSize,
                  shapeType: shape)
    }
    
    func toNetless(oriState: WhiteMemberState) -> WhiteMemberState {
        var memberState = WhiteMemberState()
        
        memberState.currentApplianceName = self.activeApplianceType?.toNetless()
        memberState.strokeColor = self.strokeColor as [NSNumber]?
        memberState.strokeWidth = self.strokeWidth as NSNumber?
        memberState.textSize = self.textSize as NSNumber?
        memberState.shapeType = self.shapeType?.toNetless()
        
        return memberState
    }
}

extension AgoraBoardInteractionSignal {
    func toMessageString() -> String? {
        var dic = [String: Any]()
        dic["signal"] = self.rawValue
        switch self {
        case .JoinBoard: break
        case .BoardPhaseChanged(let boardRoomPhase) :
            dic["body"] = boardRoomPhase.rawValue
        case .MemberStateChanged(let boardMemberState) :
            dic["body"] = boardMemberState.toDictionary()
        case .AudioMixingStateChanged(let boardAudioMixingChangeData) :
            dic["body"] = boardAudioMixingChangeData.toDictionary()
        case .BoardGrantDataChanged(let boardGrantData) :
            dic["body"] = boardGrantData
        case .BoardAudioMixingRequest(let agoraBoardAudioMixingRequestData):
            dic["body"] = agoraBoardAudioMixingRequestData.toDictionary()
        case .BoardPageChanged(let page):
            dic["body"] = page.toDictionary()
        case .BoardStepChanged(let changeType):
            dic["body"] = changeType.toDictionary()
        case .OpenCourseware(let coursewareInfo):
            dic["body"] = coursewareInfo.toDictionary()
        case .WindowStateChanged(let state):
            dic["body"] = state.rawValue
        default:
            break
        }
        return dic.jsonString()
    }
}

// MARK: - Base
extension String {
    func translatePath() -> String {
        if self.count < 32 {
            return "/init"
        } else {
            return self
        }
    }
    
    func toBoardSignal() -> AgoraBoardInteractionSignal? {
        guard let dic = self.toDic(),
              let signalRaw = dic["signal"] as? Int else {
            return nil
        }
        if signalRaw == AgoraBoardInteractionSignal.JoinBoard.rawValue {
            return .JoinBoard
        }
        
        if signalRaw == AgoraBoardInteractionSignal.ClearBoard.rawValue {
            return .ClearBoard
        }
        
        if let bodyArr = dic["body"] as? [String] {
            return .BoardGrantDataChanged(bodyArr)
        }
        
        if let bodyInt = dic["body"] as? Int,
           let type = AgoraBoardInteractionSignal.getType(rawValue: signalRaw) {
            if type == AgoraBoardWindowState.self,
            let changeType = AgoraBoardWindowState(rawValue: bodyInt) {
                return .WindowStateChanged(changeType)
            }
        }
        
        guard let bodyDic = dic["body"] as? [String:Any],
              let type = AgoraBoardInteractionSignal.getType(rawValue: signalRaw),
              let obj = try type.decode(bodyDic) else {
            return nil
        }
        return AgoraBoardInteractionSignal.makeSignal(rawValue: signalRaw,
                                                      body: obj)
    }
}

extension Array : Convertable where Element == String {
    
}

extension UIColor {
    func getRGBAArr() -> Array<NSNumber> {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red,
                    green: &green,
                    blue: &blue,
                    alpha: &alpha)
        return [NSNumber(value: Int(red * 255)),
                NSNumber(value: Int(green * 255)),
                NSNumber(value: Int(blue * 255))]
    }
}

// MARK: - Cloud to Netless
extension Array where Element == AgoraBoardWhiteScene {
    func toNetless() -> [WhiteScene] {
        var sceneArr = [WhiteScene]()
        for item in self {
            var pptPage: WhitePptPage?
            if let url = item.ppt.previewURL {
                pptPage = WhitePptPage(src: item.ppt.src,
                                       preview: url,
                                       size: CGSize(width: CGFloat(item.ppt.width),
                                                    height: CGFloat(item.ppt.height)))
            } else {
                pptPage = WhitePptPage(src: item.ppt.src,
                                       size: CGSize(width: CGFloat(item.ppt.width),
                                                    height: CGFloat(item.ppt.height)))
            }
            
            let scene = WhiteScene(name: item.name,
                                   ppt: pptPage!)
            sceneArr.append(scene)
        }
        
        return sceneArr
    }
}
