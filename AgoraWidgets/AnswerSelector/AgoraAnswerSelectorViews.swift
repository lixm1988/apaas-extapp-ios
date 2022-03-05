//
//  AgoraAnswerSelectorViews.swift
//  AgoraClassroomSDK_iOS
//
//  Created by Cavan on 2022/3/5.
//

import SwifterSwift
import AgoraUIBaseViews
import Masonry
import UIKit

struct AgoraAnswerSelectorOption {
    var title: String
    var isSelected: Bool
}

class AgoraAnswerSelectorOptionCell: UICollectionViewCell {
    private let grayColor = UIColor(hexString: "#EEEEF7")
    private let darkGrayColor = UIColor(hexString: "#BDBDCA")
    private let blueColor = UIColor(hexString: "#357BF6")
    private let whiteColor = UIColor.white
    
    var optionIsSelected: Bool = false {
        didSet {
            optionLabel.backgroundColor = optionIsSelected ? blueColor : whiteColor
            optionLabel.textColor = optionIsSelected ? whiteColor : darkGrayColor
            layer.borderColor = optionIsSelected ? blueColor?.cgColor : grayColor?.cgColor
        }
    }
    
    let optionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        optionLabel.textColor = darkGrayColor
        optionLabel.textAlignment = .center
        optionLabel.font = UIFont.systemFont(ofSize: 20)
        
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        optionLabel.frame = bounds
    }
}

class AgoraAnswerSelectorOptionCollectionView: UICollectionView {
    private var space: CGFloat = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero,
                   collectionViewLayout: layout)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        
        backgroundColor = .white
        bounces = false
        isHidden = true
        
        register(cellWithClass: AgoraAnswerSelectorOptionCell.self)
    }
    
    func setSpace(_ space: CGFloat) {
        isHidden = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = space
        
        setCollectionViewLayout(layout,
                                animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AgoraAnswerSelectorTopView: UIView {
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let lineLayer = CALayer()
    
    private let backColor = UIColor(hexString: "#191919")
    private let grayColor = UIColor(hexString: "#677386")
    
    let defaultHeight: CGFloat = 30
    
    var isSubmited: Bool = false {
        didSet {
            timeLabel.textColor = isSubmited ? grayColor : backColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        let selector = GetWidgetLocalizableString(object: self,
                                                  key: "fcr_AnswerSelector")
        
        let font = UIFont.systemFont(ofSize: 13)
        
        let titleSize = selector.agora_size(font: font,
                                            height: defaultHeight)
        
        titleLabel.text = selector
        titleLabel.textColor = backColor
        titleLabel.font = font
        addSubview(titleLabel)
        
        timeLabel.textColor = backColor
        timeLabel.font = font
        timeLabel.textAlignment = .left
        addSubview(timeLabel)
        
        update(timeString: "00:00:00")
        
        lineLayer.backgroundColor = UIColor(hexString: "#EEEEF7")?.cgColor
        backgroundColor = UIColor(hexString: "#F9F9FC")
        
        // Constrains
                titleLabel.mas_makeConstraints { (make) in
                    make?.left.equalTo()(0)
                    make?.top.bottom()?.equalTo()(0)
                    make?.width.equalTo()(0)
                }
        
//        titleLabel.mas_makeConstraints { (make) in
//            make?.left.equalTo()(10)
//            make?.top.bottom()?.equalTo()(0)
//            make?.width.equalTo()(titleSize.width)
//        }
     
//        timeLabel.mas_makeConstraints { (make) in
//            make?.left.equalTo()(titleLabel.mas_right)?.offset()(5)
//            make?.top.right().bottom()?.equalTo()(0)
//        }
    }
    
    func update(timeString: String) {
        timeLabel.text = timeString
    }
}

class AgoraAnswerSelectorView: UIView {
    enum SelectorState {
        case submit, change
    }
    
    
    private var state = SelectorState.submit
    
    let topView = AgoraAnswerSelectorTopView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
   
}
