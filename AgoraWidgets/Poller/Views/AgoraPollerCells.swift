//
//  AgoraPollerCell.swift
//  AgoraWidgets
//
//  Created by LYY on 2022/3/1.
//

import Foundation

struct AgoraPollerCellPollingInfo {
    var isSingle: Bool
    var isSelected: Bool
    var itemText: String
}

struct AgoraPollerCellResultInfo {
    var index: Int
    var itemText: String
    var count: Int
    var percent: Float
}

protocol AgoraPollerInputCellDelegate: NSObjectProtocol {
    func onItemInput(index: Int,
                     text: String)
}

class AgoraPollerInputCell: UITableViewCell {
    private weak var delegate: AgoraPollerInputCellDelegate?
    private var index: Int?
    
    private let serialLabel = UILabel()
    private let optionField = UITextField()
    private let sepLine = UIView()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        serialLabel.textColor = UIColor(hex: 0x677386)
        serialLabel.font = .systemFont(ofSize: 14)
        optionField.font = .systemFont(ofSize: 13)
        optionField.placeholder = GetWidgetLocalizableString(object: self,
                                                             key: "PollerInputPlaceHolder")
        optionField.delegate = self
        sepLine.backgroundColor = UIColor(hex: 0xEEEEF7)
        
        addSubviews([serialLabel, optionField, sepLine])
        
    }
    
    func updateInfo(index: Int,
                    delegate: AgoraPollerInputCellDelegate) {
        self.delegate = delegate
        self.index = index
        serialLabel.text = "\(index)."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        serialLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.left.equalTo()(AgoraWidgetsFit.scale(10))
        }
        optionField.mas_makeConstraints { make in
            make?.left.equalTo()(serialLabel.mas_right)?.offset()(AgoraWidgetsFit.scale(10))
            make?.centerY.top().bottom().right().equalTo()(0)
        }
        sepLine.mas_makeConstraints { make in
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(1)
        }
    }
}

extension AgoraPollerInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
        let `index` = index else {
            return
        }
        delegate?.onItemInput(index: index,
                              text: text)
    }
}

class AgoraPollerSelectCell: UITableViewCell {
    private let optionImage = UIImageView()
    private let optionLabel = UILabel()
    private let sepLine = UIView()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        optionLabel.font = .systemFont(ofSize: 12)
        sepLine.backgroundColor = UIColor(hex: 0xEEEEF7)
        addSubviews([optionImage, optionLabel, sepLine])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateInfo(_ pollingInfo: AgoraPollerCellPollingInfo) {
        optionImage.image = itemImage(isSingle: pollingInfo.isSingle,
                                      isSelected: pollingInfo.isSelected)
        optionLabel.text = pollingInfo.itemText
        
        makeConstraints()
        
    }
    
    private func itemImage(isSingle: Bool,
                           isSelected: Bool) -> UIImage? {
        var imageName = ""
        if isSingle {
            imageName = isSelected ? "poller_sin_checked" : "poller_sin_unchecked"
        } else {
            imageName = isSelected ? "poller_mul_checked" : "poller_mul_unchecked"
        }
        
        return GetWidgetImage(object: self,
                              imageName)
    }
    
    private func makeConstraints() {
        optionImage.mas_remakeConstraints { make in
            make?.left.equalTo()(AgoraWidgetsFit.scale(10))
            make?.centerY.equalTo()(0)
            make?.width.height().equalTo()(AgoraWidgetsFit.scale(12))
        }
        
        optionLabel.mas_remakeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.height.equalTo()(AgoraWidgetsFit.scale(10))
            make?.left.equalTo()(optionImage.mas_right)?.offset()(AgoraWidgetsFit.scale(10))
            make?.right.equalTo()(AgoraWidgetsFit.scale(-50))
        }
        
        sepLine.mas_makeConstraints { make in
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(0)
        }
    }
}

class AgoraPollerResultCell: UITableViewCell {
    /**Views**/
    let optionLabel = UILabel()
    let resultSerial = UILabel()
    let resultProgress = UIProgressView()
    let resultPercentage = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        resultSerial.textColor = UIColor(hex: 0x677386)
        resultSerial.font = .systemFont(ofSize: 13)
        optionLabel.font = .systemFont(ofSize: 13)
        resultPercentage.font = .systemFont(ofSize: 13)
        resultProgress.layer.cornerRadius = 1.5
        resultProgress.trackTintColor = .clear
        resultProgress.progressTintColor = UIColor(hex: 0x0073FF)
        
        addSubviews([optionLabel, resultSerial, resultProgress, resultPercentage])
    }
    
    func updateInfo(_ resultInfo: AgoraPollerCellResultInfo) {
        resultSerial.text = "\(resultInfo.index)."
        optionLabel.text = resultInfo.itemText
        resultPercentage.text = "(\(resultInfo.count)) \(resultInfo.percent * 100)%"
        resultProgress.progress = resultInfo.percent
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        resultSerial.mas_remakeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.width.equalTo()(AgoraWidgetsFit.scale(15))
            make?.height.equalTo()(AgoraWidgetsFit.scale(18))
            make?.left.equalTo()(AgoraWidgetsFit.scale(10))
        }
        resultPercentage.sizeToFit()
        let percentWidth = resultPercentage.bounds.width
        resultPercentage.mas_remakeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.height.equalTo()(AgoraWidgetsFit.scale(18))
            make?.width.equalTo()(percentWidth)
            make?.right.equalTo()(AgoraWidgetsFit.scale(-20))
        }
        
        optionLabel.mas_remakeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.height.equalTo()(AgoraWidgetsFit.scale(18))
            make?.left.equalTo()(resultSerial.mas_right)?.offset()(AgoraWidgetsFit.scale(10))
            make?.right.equalTo()(resultPercentage.mas_left)?.offset()(0)
        }
        
        resultProgress.mas_remakeConstraints { make in
            make?.left.equalTo()(optionLabel.mas_left)
            make?.height.equalTo()(3)
            make?.right.equalTo()(resultPercentage.mas_right)
            make?.bottom.equalTo()(0)
        }
    }
}
