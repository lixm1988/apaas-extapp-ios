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
    private let armin = Armin(delegate: nil,
                              logTube: nil)
    
    private var timer: Timer?
    
    // View
    private let contentView = AgoraAnswerSelectorView() // for mask shadow
    private var lastViewSize = CGSize.zero
    
    // Data
    private var optionList = [AgoraAnswerSelectorOption]()
    
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
            contentView.optionCollectionView.reloadData()
        }
    }
    
    private var baseInfo: AgoraAppBaseInfo?
    
    private var extraData: AgoraAnswerSelectorExtraData?
    
    private var objectCreateTimestamp: Int64?
    private var currentTimestamp: Int64 = 0
    
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
        
        if let timestamp = message.toSyncTimestamp() {
            objectCreateTimestamp = timestamp
            startTimer()
        }
    }
    
    public override func onWidgetRoomPropertiesUpdated(_ properties: [String : Any],
                                                       cause: [String : Any]?,
                                                       keyPaths: [String]) {
        super.onWidgetRoomPropertiesUpdated(properties,
                                            cause: cause,
                                            keyPaths: keyPaths)
        updateExtraData()
    }
    
    @objc func doButtonPressed(_ sender: UIButton) {
        switch selectorState {
        case .post:
            submitAnswer()
        case .change:
            selectorState = .post
        default:
            break
        }
    }
    
    deinit {
        stopTimer()
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
        
        contentView.button.addTarget(self,
                                     action: #selector(doButtonPressed(_:)),
                                     for: .touchUpInside)
        
        view.layer.shadowColor = UIColor(hexString: "#2F4192")?.cgColor
        view.layer.shadowOffset = CGSize(width: 0,
                                         height: 2)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 6
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
        
        if let state = extra.toViewSelectorState() {
            selectorState = state // .end
            initResultList()
        } else {
            initOptionList()
        }
        
        startTimer()
    }
    
    func updateExtraData() {
        guard let roomProperties = info.roomProperties,
              let extra = roomProperties.toObj(AgoraAnswerSelectorExtraData.self) else {
            return
        }
        
        extraData = extra
        
        guard let state = extra.toViewSelectorState() else {
            return
        }
        
        selectorState = state // .end
        initResultList()
    }
    
    func initOptionList() {
        guard let extra = extraData else {
            return
        }
        
        optionList = extra.toViewSelectorOptionList()
        contentView.optionCollectionView.reloadData()
    }
    
    func initResultList() {
        guard let extra = extraData else {
            return
        }
        
        let font = AgoraAnswerSelectorResultCell.font
        resultList = extra.toViewSelectorResultList(font: font,
                                                    fontHeight: contentView.resultTableView.rowHeight,
                                                    myAnswer: findMyAnswer())
        contentView.resultTableView.reloadData()
    }
    
    func insertSelectedOptionIndex(_ index: Int) {
        selectedOptionList.append(index)
    }
    
    func removeSelectedOptionIndex(_ index: Int) {
        selectedOptionList.removeFirst { (storeIndex) -> Bool in
            return (storeIndex == index)
        }
    }
    
    func findMyAnswer() -> [String] {
        var selectedItems = [String]()
        
        for item in selectedOptionList {
            let option = optionList[item]
            selectedItems.append(option.title)
        }
        
        return selectedItems
    }
    
    func startTimer() {
        guard let extra = extraData,
              let objectCreate = objectCreateTimestamp else {
            return
        }
        
        let start = extra.receiveQuestionTime
        let diff = objectCreate - start
        currentTimestamp = (diff < 0) ? 0 : diff
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                         repeats: true,
                                         block: { [weak self] _ in
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            
                                            strongSelf.currentTimestamp += 1000
                                            
                                            let time = Int64(TimeInterval(strongSelf.currentTimestamp) / 1000)
                                            let timeString = time.formatStringHMS
                                            strongSelf.contentView.topView.update(timeString: timeString)
        })
        
        RunLoop.main.add(timer,
                         forMode: .common)
        timer.fire()
        self.timer = timer
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private extension AgoraAnswerSelectorWidget {
    func submitAnswer() {
        guard let keys = baseInfo else {
            return
        }
        
        guard let extra = extraData else {
            return
        }
        
        let host = keys.host
        let appId = keys.agoraAppId
        let token = keys.token
        let roomId = info.roomInfo.roomUuid
        let selectorId = extra.selectorId
        let userId = info.localUserInfo.userUuid
        
        let event = ArRequestEvent(name: "answer-selector-submit")
        let url = host + "/edu/apps/\(appId)/v2/rooms/\(roomId)/widgets/selector/\(selectorId)/users/\(userId)"
        let parameters = ["selectedItems": findMyAnswer()]
        
        let task = ArRequestTask(event: event,
                                 type: .http(.put, url: url),
                                 timeout: .medium,
                                 parameters: parameters)
        
        armin.request(task: task,
                      success: ArResponse.blank({ [weak self] in
                        print("submitAnswer success")
                        guard let strongSelf = self else {
                            return
                        }
                        
                        strongSelf.selectorState = .change
        })) { (error) -> ArRetryOptions in
            print("submitAnswer failure: \(error.localizedDescription)")
            return .resign
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
        cell.isEnable = !(selectorState == .change)
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
        let labelHeight = AgoraAnswerSelectorResultCell.labelHeight
        
        cell.titleLabel.text = result.title
        cell.resultLabel.text = result.result
        cell.titleLabel.frame = CGRect(x: 55,
                                       y: 0,
                                       width: result.titleSize.width,
                                       height: labelHeight)
        
        cell.resultLabel.frame = CGRect(x: cell.titleLabel.frame.maxX,
                                        y: 0,
                                        width: 100,
                                        height: labelHeight)
        
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
