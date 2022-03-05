//
//  AgoraBoardModels.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2021/12/3.
//

import Foundation

/// 对应AgoraBoardWidgetModel
// MARK: - Config
enum AgoraBoardInteractionSignal {
    case JoinBoard
    case BoardPhaseChanged(AgoraBoardRoomPhase)
    case MemberStateChanged(AgoraBoardMemberState)
    case BoardGrantDataChanged(Array<String>?)
    case AudioMixingStateChanged(AgoraBoardAudioMixingData)
    case BoardAudioMixingRequest(AgoraBoardAudioMixingRequestData)
    case BoardPageChanged(AgoraBoardPageChangeType)
    case BoardStepChanged(AgoraBoardStepChangeType)
    case ClearBoard
    case OpenCourseware(AgoraBoardCoursewareInfo)
    case WindowStateChanged(AgoraBoardWindowState)
    
    var rawValue: Int {
        switch self {
        case .JoinBoard:                             return 0
        case .BoardPhaseChanged(_):                  return 1
        case .MemberStateChanged(_):                 return 2
        case .BoardGrantDataChanged(_):              return 3
        case .AudioMixingStateChanged(_):            return 4
        case .BoardAudioMixingRequest(_):            return 5
        case .BoardPageChanged:                      return 6
        case .BoardStepChanged:                      return 7
        case .ClearBoard:                            return 8
        case .OpenCourseware:                        return 9
        case .WindowStateChanged(_):                 return 10
        default:
            return -1
        }
    }
    
    static func getType(rawValue: Int) -> Convertable.Type? {
        switch rawValue {
        case 1: return AgoraBoardRoomPhase.self
        case 2: return AgoraBoardMemberState.self
        case 3: return Array<String>.self
        case 4: return AgoraBoardAudioMixingData.self
        case 5: return AgoraBoardAudioMixingRequestData.self
        case 6: return AgoraBoardPageChangeType.self
        case 7: return AgoraBoardStepChangeType.self
        case 9: return AgoraBoardCoursewareInfo.self
        case 10: return AgoraBoardWindowState.self
        default:
            return nil
        }
    }
    
    static func makeSignal(rawValue: Int,
                           body: Convertable?) -> AgoraBoardInteractionSignal? {
        switch rawValue {
        case 0:
            return .JoinBoard
        case 1:
            if let x = body as? AgoraBoardRoomPhase {
                return .BoardPhaseChanged(x)
            }
        case 2:
            if let x = body as? AgoraBoardMemberState {
                return .MemberStateChanged(x)
            }
        case 3:
            if let x = body as? Array<String> {
                return .BoardGrantDataChanged(x)
            }
        case 4:
            if let x = body as? AgoraBoardAudioMixingData {
                return .AudioMixingStateChanged(x)
            }
        case 5:
            if let x = body as? AgoraBoardAudioMixingRequestData {
                return .BoardAudioMixingRequest(x)
            }
        case 6:
            if let x = body as? AgoraBoardPageChangeType {
                return .BoardPageChanged(x)
            }
        case 7:
            if let x = body as? AgoraBoardStepChangeType {
                return .BoardStepChanged(x)
            }
        case 8:
            return .ClearBoard
        case 9:
            if let x = body as? AgoraBoardCoursewareInfo {
                return .OpenCourseware(x)
            }
        case 10:
            if let x = body as? AgoraBoardWindowState {
                return .WindowStateChanged(x)
            }
        default:
            break
        }
        return nil
    }
}

enum AgoraBoardRoomPhase: Int, Convertable {
    case Connecting
    case Connected
    case Reconnecting
    case Disconnecting
    case Disconnected
};

enum AgoraBoardToolType: Int, Convertable {
    case Selector, Text, Rectangle, Ellipse, Eraser, Pencil, Arrow, Straight, Pointer, Clicker, Shape
}

enum AgoraBoardToolShapeType: Int, Convertable {
    case Triangle, Rhombus, Pentagram, Ballon
}

enum AgoraBoardWindowState: Int, Convertable {
    case min, max, normal
}

// MARK: - Message
// 当外部手动更新某一项数据的时候MemberState就只包含对应的某一项，然后通过sendMessageToWidget发送即可
// 若初始化时期，白板需要向外传
struct AgoraBoardMemberState: Convertable {
    // 被激活教具
    var activeApplianceType: AgoraBoardToolType?
    // 颜色
    var strokeColor: Array<Int>?
    // 线条宽度
    var strokeWidth: Int?
    // 文字大小
    var textSize: Int?
    // 图形
    var shapeType: AgoraBoardToolShapeType?
    
    init(activeApplianceType: AgoraBoardToolType?,
         strokeColor: Array<Int>?,
         strokeWidth: Int?,
         textSize: Int?,
         shapeType: AgoraBoardToolShapeType?) {
        self.activeApplianceType = activeApplianceType
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.textSize = textSize
        self.shapeType = shapeType
    }
}

struct AgoraBoardAudioMixingData: Convertable {
    var stateCode: Int
    var errorCode: Int
}

enum AgoraBoardAudioMixingRequestType: Int,Convertable {
    case start,stop,setPosition
}

struct AgoraBoardAudioMixingRequestData: Convertable {
    var requestType: AgoraBoardAudioMixingRequestType
    var filePath: String
    var loopback: Bool
    var replace: Bool
    var cycle: Int
    var position: Int
    
    init(requestType: AgoraBoardAudioMixingRequestType,
         filePath: String = "",
         loopback: Bool = true,
         replace: Bool = true,
         cycle: Int = 0,
         position: Int = 0) {
        self.requestType = requestType
        self.filePath = filePath
        self.loopback = loopback
        self.replace = replace
        self.cycle = cycle
        self.position = position
    }
}

// page handle
struct AgoraBoardPageInfo: Convertable {
    var index: Int
    var count: Int
}

enum AgoraBoardPageChangeType: Convertable {
    case index(Int)
    case count(Int)
    
    private enum CodingKeys: CodingKey {
        case index
        case count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let type1Value = try? container.decode(Int.self, forKey: .index) {
            self = .index(type1Value)
        } else {
            let type2Value = try container.decode(Int.self, forKey: .count)
            self = .count(type2Value)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .index(let value):
            try container.encode(value, forKey: .index)
        case .count(let value):
            try container.encode(value, forKey: .count)
        }
    }
}

// step
enum AgoraBoardStepChangeType: Convertable {
    case pre(Int)
    case next(Int)
    case undoCount(Int)
    case redoCount(Int)
    
    var rawValue: Int {
        get {
            switch self {
            case .pre(let _):         return 0
            case .next(let _):        return 1
            case .undoCount(let _):   return 2
            case .redoCount(let _):   return 3
            }
        }
    }
    
    private enum CodingKeys: CodingKey {
        case pre
        case next
        case undoCount
        case redoCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let x = try? container.decodeIfPresent(Int.self,
                                                  forKey: .pre) {
            self = .pre(x)
        }
        if let x = try? container.decodeIfPresent(Int.self,
                                                  forKey: .next) {
            self = .next(x)
        }
        if let x = try? container.decodeIfPresent(Int.self,
                                                  forKey: .undoCount) {
            self = .undoCount(x)
        }
        if let x = try? container.decodeIfPresent(Int.self,
                                                  forKey: .redoCount) {
            self = .redoCount(x)
        }
        throw DecodingError.typeMismatch(AgoraBoardStepChangeType.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for AgoraBoardStepChangeType"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .pre(let x):
            try container.encode(x,
                                 forKey: .pre)
        case .next(let x):
            try container.encode(x,
                                 forKey: .next)
        case .undoCount(let x):
            try container.encode(x,
                                 forKey: .undoCount)
        case .redoCount(let x):
            try container.encode(x,
                                 forKey: .redoCount)
        }
    }
}

// courseware
// 待定
struct AgoraBoardCoursewareInfo: Convertable {
    var resourceUuid: String
    var resourceName: String
    var scenes: [AgoraBoardWhiteScene]
    var convert: Bool
}

struct AgoraBoardWhiteScene: Convertable {
    var name: String
    var ppt: AgoraBoardWhitePptPage
}

struct AgoraBoardWhitePptPage: Convertable {
    /// 图片的 URL 地址。
    var src: String
    /// 图片的 URL 宽度。单位为像素。
    var width: Float
    /// 图片的 URL 高度。单位为像素。
    var height: Float
    /// 预览图片的 URL 地址
    var previewURL: String?
}
