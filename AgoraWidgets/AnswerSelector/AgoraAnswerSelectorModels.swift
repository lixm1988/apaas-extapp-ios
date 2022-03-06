//
//  AgoraAnswerSelectorModels.swift
//  AgoraWidgets
//
//  Created by Cavan on 2022/3/6.
//

import UIKit

// View Model
struct AgoraAnswerSelectorOption {
    var title: String
    var isSelected: Bool
}

struct AgoraAnswerSelectorResult {
    var title: String
    var result: String
    var titleSize: CGSize
    var resultColor: UIColor? = nil
}

enum AgoraAnswerSelectorState {
    case unselected, post, change, end
}

// Origin Data
struct AgoraAnswerSelectorExtraData: Decodable {
    var selectorId: String          // 本题id
    var correctItems: [String]      // 本题正确答案
    var items: [String]             // 所有选项
    var correctCount: Int           // 本题答对人数
    var averageAccuracy: Float      // 答题正确率
    var answerState: Int            // 答题状态 1:答题中 0：答题结束
    var receiveQuestionTime: Int64  // 收到题目时间
    var selectedCount: Int          // 已经答题人数
    var totalCount: Int             // 应该答题的人数
    
    func toViewSelectorState() -> AgoraAnswerSelectorState? {
        if answerState == 0 {
            return .end
        } else {
            return nil
        }
    }
    
    func toViewSelectorOptionList() -> [AgoraAnswerSelectorOption] {
        var list = [AgoraAnswerSelectorOption]()
        
        for item in items {
            let option = AgoraAnswerSelectorOption(title: item,
                                                   isSelected: false)
        }
        
        return list
    }
    
    func toViewSelectorResultList(font: UIFont,
                                  myAnswer: [String]) -> [AgoraAnswerSelectorResult] {
        var list = [AgoraAnswerSelectorResult]()
        
        let postfix = ":   "
        
        // Submission
        let submissionTitle = "fcr_AnswerSelector_Submission".ag_widget_localized() + postfix
        let submissionSize = submissionTitle.agora_size(font: font)
        let submissionResult = "\(selectedCount)/\(totalCount)"
        let submissionItem = AgoraAnswerSelectorResult(title: submissionTitle,
                                                       result: submissionResult,
                                                       titleSize: submissionSize)
        list.append(submissionItem)
        
        // Accuracy
        let accuracyTitle = "fcr_AnswerSelector_Accuracy".ag_widget_localized() + postfix
        let accuracySize = accuracyTitle.agora_size(font: font)
        let accuracyResult = "\(averageAccuracy)%"
        let accuracyItem = AgoraAnswerSelectorResult(title: accuracyTitle,
                                                     result: accuracyResult,
                                                     titleSize: accuracySize)
        list.append(accuracyItem)
        
        // Correct
        let correctTitle = "fcr_AnswerSelector_Correct".ag_widget_localized() + postfix
        let correctSize = correctTitle.agora_size(font: font)
        
        var correctResult = ""
        
        for item in correctItems {
            correctResult += item
        }
        
        let correctItem = AgoraAnswerSelectorResult(title: correctTitle,
                                                    result: correctResult,
                                                    titleSize: correctSize)
        list.append(correctItem)
        
        // My Answer
        let myAnswerTitle = "fcr_AnswerSelector_MyAnswer".ag_widget_localized() + postfix
        let myAnswerSize = myAnswerTitle.agora_size(font: font)
        
        var myAnswerResult = ""
        
        for item in myAnswer {
            myAnswerResult += item
        }
        
        let myAnswerItem = AgoraAnswerSelectorResult(title: myAnswerTitle,
                                                    result: myAnswerResult,
                                                    titleSize: myAnswerSize,
                                                    resultColor: UIColor(hexString: "#0BAD69"))
        list.append(myAnswerItem)
        
        return list
    }
}

