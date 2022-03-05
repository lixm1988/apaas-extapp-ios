//
//  AgoraAnswerSelectorWidget.swift
//  AgoraClassroomSDK_iOS
//
//  Created by Cavan on 2022/3/5.
//

import AgoraWidget
import UIKit

@objcMembers public class AgoraAnswerSelectorWidget: AgoraBaseWidget {
    private let optionCollectionView = AgoraAnswerSelectorOptionCollectionView()
    private let topView = AgoraAnswerSelectorTopView()
    private let button = UIButton()
    
    public override func onWidgetDidLoad() {
        super.onWidgetDidLoad()
        
        createViews()
//        createConstrains()
    }
}

private extension AgoraAnswerSelectorWidget {
    func createViews() {
        view.addSubview(topView)
//        view.addSubview(optionCollectionView)
//        view.addSubview(button)
        
//        view.layer.cornerRadius = 6
//        view.layer.shadowColor = UIColor(hexString: "#2F4192")?.cgColor
//        view.layer.shadowOffset = CGSize(width: 0,
//                                         height: 2)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowRadius = 6
    }
    
    func createConstrains() {
//        topView.mas_makeConstraints { (make) in
//            make?.top.right()?.left()?.equalTo()(0)
//            make?.height.equalTo()(topView.defaultHeight)
//        }
        
//        optionCollectionView.mas_makeConstraints { (make) in
//            make?.top.right()?.left()?.equalTo()(0)
//            make?.height.equalTo()(topView.defaultHeight)
//        }
//
//        button.mas_makeConstraints { (make) in
//            make?.bottom.equalTo()(20)
//        }
    }
}
