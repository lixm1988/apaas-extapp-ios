//
//  AgoraCloudWidget.swift
//  AFNetworking
//
//  Created by ZYP on 2021/10/20.
//

import AgoraWidget
import AgoraLog
import Masonry
import Darwin

@objcMembers public class AgoraCloudWidget: AgoraBaseWidget {
    private let cloudView = AgoraCloudView(frame: .zero)
    private var vm: AgoraCloudVM?
    private let logger: AgoraLogger
    
    public override init(widgetInfo: AgoraWidgetInfo) {
        self.logger = AgoraLogger(folderPath: GetWidgetLogFolder(),
                                  filePrefix: widgetInfo.widgetId,
                                  maximumNumberOfFiles: 5)
        // MARK: 在此修改日志是否打印在控制台,默认为不打印
        self.logger.setPrintOnConsoleType(.all)
        
        super.init(widgetInfo: widgetInfo)
        initViews()
        
    }
    
    public override func onMessageReceived(_ message: String) {
        log(.info,
            log: "onMessageReceived:\(message)")
        
        if let info = message.toAppBaseInfo() {
            initVM(baseInfo: info)
        }
    }
    
    private func sendMessage(signal: AgoraCloudInteractionSignal) {
        guard let text = signal.toMessageString() else {
            return
        }
        sendMessage(text)
    }
    
    func log(_ type: AgoraLogType,
             log: String) {
        switch type {
        case .info:
            logger.log("[Cloud widget] \(log)",
                       type: .info)
        case .warning:
            logger.log("[Cloud widget] \(log)",
                       type: .warning)
        case .error:
            logger.log("[Cloud widget] \(log)",
                       type: .error)
        default:
            logger.log("[Cloud widget] \(log)",
                       type: .info)
        }
    }
}

extension AgoraCloudWidget: AgoraCloudTopViewDelegate, AgoraCloudListViewDelegate {
    // MARK: - AgoraCloudTopViewDelegate
    func agoraCloudTopViewDidTapAreaButton(type: AgoraCloudCoursewareType) {
        guard let `vm` = vm else {
            return
        }
        vm.changeSelectedType(type: type)
        vm.fetchData()
    }
    
    func agoraCloudTopViewDidTapCloseButton() {
        sendMessage(signal: .CloseCloud)
    }
    
    func agoraCloudTopViewDidTapRefreshButton() {
        guard let `vm` = vm else {
            return
        }
        vm.fetchData()
    }
    
    func agoraCloudTopViewDidSearch(type: AgoraCloudCoursewareType,
                                    keyStr: String) {
        switch type {
        case .publicResource:
            let newList = vm?.publicFiles.filter({ courseware in
                courseware.resourceName.contains(keyStr)
            })
            cloudView.listView.update(infos: newList?.toCellInfos())
        case .privateResource:
            let newList = vm?.privateFiles.filter({ courseware in
                courseware.resourceName.contains(keyStr)
            })
            cloudView.listView.update(infos: newList?.toCellInfos())
        }
    }
    
    // MARK: - AgoraCloudListViewDelegate
    func agoraCloudListViewDidSelectedIndex(index: Int) {
        guard let `vm` = vm,
              let coursewareInfo = vm.getSelectedInfo(index: index) else {
            return
        }
        sendMessage(signal: .OpenCoursewares(coursewareInfo))
    }
}

extension AgoraCloudWidget: AgoraCloudVMDelegate {
    func agoraCloudVMDidUpdateList(vm: AgoraCloudVM,
                                   list: [AgoraCloudCourseware]) {
        cloudView.listView
            .update(infos: list.toCellInfos())
    }
}

// MARK: private
private extension AgoraCloudWidget {
    func initViews() {
        view.backgroundColor = .clear
        view.addSubview(cloudView)
        
        cloudView.topView.delegate = self
        cloudView.listView.listDelegate = self
        
        cloudView.mas_makeConstraints { make in
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.top.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)
        }
    }
    
    func initVM(baseInfo: AgoraAppBaseInfo) {
        let cloudVM = AgoraCloudVM(baseInfo: baseInfo,
                                   uid: info.localUserInfo.userUuid,
                                   extra: info.extraInfo)
        cloudVM.delegate = self
        cloudVM.start()
        vm = cloudVM
    }
}
