//
//  AgoraAnswerSelectorWidget.swift
//  AgoraClassroomSDK_iOS
//
//  Created by Cavan on 2022/3/5.
//

import AgoraWidget
import Armin
import UIKit

@objcMembers public class AgoraAnswerSelectorWidget: AgoraBaseWidget {
    // View
    private let contentView = AgoraAnswerSelectorView() // for mask shadow
    private var lastViewSize = CGSize.zero
    
    // Data
    private var optionList: [AgoraAnswerSelectorOption] = [AgoraAnswerSelectorOption(title: "A",
                                                                                     isSelected: false),
                                                           AgoraAnswerSelectorOption(title: "B",
                                                                                     isSelected: false),
                                                           AgoraAnswerSelectorOption(title: "C",
                                                                                     isSelected: false),
                                                           AgoraAnswerSelectorOption(title: "D",
                                                                                     isSelected: false)]
    
//    private var resultList: [AgoraAnswerSelectorResult] = [AgoraAnswerSelectorResult(title: "已答题人数:  ",
//                                                                                     result: "8/22"),
//                                                           AgoraAnswerSelectorResult(title: "已答题人数:  ",
//                                                                                     result: "8/22"),
//                                                           AgoraAnswerSelectorResult(title: "已答题人数:  ",
//                                                                                     result: "8/22"),
//                                                           AgoraAnswerSelectorResult(title: "已答题人数:  ",
//                                                                                     result: "8/22")]
    
    private var resultList: [AgoraAnswerSelectorResult] = []
    
    private var selectedOptionList = [Int]() { // store selected option index
        didSet {
            if selectedOptionList.count > 0 {
                selectorState = .post
            } else {
                selectorState = .unselected
            }
        }
    }
    
    private var selectorState: AgoraAnswerSelectorState = .unselected {
        didSet {
            contentView.selectorState = selectorState
        }
    }
    
    private var baseInfo: AgoraAppBaseInfo?
    
    private var extraData: AgoraAnswerSelectorExtraData?
    
    public override func onWidgetDidLoad() {
        super.onWidgetDidLoad()
        view.delegate = self
        
        createViews()
        createConstrains()
        initExtraData()
    }
    
    public override func onMessageReceived(_ message: String) {
        super.onMessageReceived(message)
        
        if let info = message.toAppBaseInfo() {
            baseInfo = info
        }
    }
}

// MARK: - View
private extension AgoraAnswerSelectorWidget {
    func createViews() {
        selectorState = .unselected
        
        view.addSubview(contentView)
       
        contentView.optionCollectionView.dataSource = self
        contentView.optionCollectionView.delegate = self
        
        contentView.resultTableView.dataSource = self
        
        view.layer.shadowColor = UIColor(hexString: "#2F4192")?.cgColor
        view.layer.shadowOffset = CGSize(width: 0,
                                         height: 2)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 6
        
        contentView.resultTableView.reloadData()
    }
    
    func createConstrains() {
        contentView.mas_makeConstraints { (make) in
            make?.top.left()?.right()?.bottom()?.equalTo()(0)
        }
    }
}

// MAKR: - Data
private extension AgoraAnswerSelectorWidget {
    func initExtraData() {
        guard let roomProperties = info.roomProperties,
              let extra = roomProperties.toObj(AgoraAnswerSelectorExtraData.self) else {
            return
        }
        
        extraData = extra
    }
    
    func insertSelectedOptionIndex(_ index: Int) {
        selectedOptionList.append(index)
    }
    
    func removeSelectedOptionIndex(_ index: Int) {
        selectedOptionList.removeFirst { (storeIndex) -> Bool in
            return (storeIndex == index)
        }
    }
}

extension AgoraAnswerSelectorWidget: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return optionList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let option = optionList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: AgoraAnswerSelectorOptionCell.self,
                                                      for: indexPath)
        cell.optionLabel.text = option.title
        cell.optionIsSelected = option.isSelected
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        var option = optionList[indexPath.item]
        option.isSelected.toggle()
        optionList[indexPath.item] = option
        collectionView.reloadItems(at: [indexPath])
        
        option.isSelected ? insertSelectedOptionIndex(indexPath.item) : removeSelectedOptionIndex(indexPath.item)
    }
}

extension AgoraAnswerSelectorWidget: UITableViewDataSource {
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = resultList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AgoraAnswerSelectorResultCell.cellId,
                                                 for: indexPath) as! AgoraAnswerSelectorResultCell
        
        cell.titleLabel.text = result.title
        cell.resultLabel.text = result.result
        cell.titleLabel.frame = CGRect(x: 55,
                                       y: 0,
                                       width: 100,
                                       height: 18)
        
        cell.resultLabel.frame = CGRect(x: cell.titleLabel.frame.maxX,
                                        y: 0,
                                        width: 100,
                                        height: 18)
        
        if let color = result.resultColor {
            cell.resultLabel.textColor = color
        }
        
        return cell
    }
}

extension AgoraAnswerSelectorWidget: AgoraUIContainerDelegate {
    public func containerLayoutSubviews() {
        guard lastViewSize != view.bounds.size else {
            return
        }
        lastViewSize = view.bounds.size
        contentView.collectionViewLayout(superViewSize: lastViewSize)
    }
}
