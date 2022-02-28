//
//  AgoraCloudVM.swift
//  AgoraWidgets
//
//  Created by ZYP on 2021/10/23.
//

import AgoraWidget

protocol AgoraCloudVMDelegate: NSObjectProtocol {
    func agoraCloudVMDidUpdateList(vm: AgoraCloudVM,
                                   list: [AgoraCloudCourseware])
}

class AgoraCloudVM: NSObject {
    private(set) var publicFiles = [AgoraCloudCourseware]()
    private(set) var privateFiles = [AgoraCloudCourseware]()
    private var serverApi: CloudServerApi!
    private var selectedType: AgoraCloudCoursewareType = .publicResource
    weak var delegate: AgoraCloudVMDelegate?
    private var currentPageNo = 0
    private var currentRequestingPageNo: Int?
    
    lazy var logFolder: String = {
        let cachesFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                               .userDomainMask,
                                                               true)[0]
        let folder = cachesFolder.appending("/AgoraLog")
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: folder,
                               isDirectory: nil) {
            try? manager.createDirectory(atPath: folder,
                                         withIntermediateDirectories: true,
                                         attributes: nil)
        }
        return folder
    }()
    
    init(baseInfo: AgoraAppBaseInfo,
         uid: String,
         extra: Any?) {
        self.serverApi = CloudServerApi(baseInfo: baseInfo,
                                        uid: uid)
        super.init()
        
        // 公共白板课件
        transformPublicResources(extra: extra)
    }
    
    func start() {
        fetchPrivate()
    }
    
    func fetchData() {
        switch selectedType {
        case .publicResource:
            break
        case .privateResource:
            fetchPrivate()
            break
        }
    }
    
    /// 获取个人数据
    private func fetchPrivate() {
        guard currentRequestingPageNo == nil else {
            return
        }
        let pageNo = currentPageNo
        currentPageNo = pageNo
        serverApi.requestResourceInUser(pageNo: pageNo,
                                        pageSize: 300) { [weak self](resp) in
            self?.currentRequestingPageNo = nil
            guard let `self` = self else { return }
            self.currentPageNo += 1
            var temp = self.privateFiles
            let list = resp.data.list.map({ AgoraCloudCourseware(fileItem: $0) })
            for item in list {
                if !temp.contains(where: {$0.resourceUuid == item.resourceUuid}) {
                    temp.append(item)
                }
            }
            self.privateFiles = temp
            self.changeSelectedType(type: self.selectedType)
        } fail: { [weak self](error) in
            print(error)
            self?.currentRequestingPageNo = nil
        }
    }
    
    func checkShouldFetchData(currentRow: Int) {
        guard selectedType == .privateResource else {
            return
        }
        
        let currentMaxRow = (currentPageNo + 1) * 300 - 1
        fetchData()
    }
    
    func getSelectedInfo(index: Int) -> AgoraCloudWhiteScenesInfo? {
        let dataList: [AgoraCloudCourseware] = (selectedType == .publicResource) ? publicFiles : privateFiles
        
        guard dataList.count > index else {
            return nil
        }
        let config = dataList[index]
        return AgoraCloudWhiteScenesInfo(resourceName: config.resourceName,
                                         resourceUuid: config.resourceUuid,
                                         scenes: config.scenes,
                                         convert: config.convert)
    }
    
    func changeSelectedType(type: AgoraCloudCoursewareType) {
        self.selectedType = type
        let list = type == .publicResource ? publicFiles : privateFiles
        delegate?.agoraCloudVMDidUpdateList(vm: self,
                                            list: list)
    }
    
    /// 公共课件转换
    private func transformPublicResources(extra: Any?) {
        guard let extraInfo = extra as? Dictionary<String,Any>,
              let publicJsonArr = extraInfo["publicCoursewares"] as? Array<String>,
              publicJsonArr.count > 0 else {
                  return
              }
        var publicCoursewares = [AgoraCloudPublicCourseware]()
        for json in publicJsonArr {
            if let data = json.data(using: .utf8),
            let courseware = try? JSONDecoder().decode(AgoraCloudPublicCourseware.self,
                                                        from: data) {
                publicCoursewares.append(courseware)
            }
        }

        self.publicFiles = publicCoursewares.toConfig()
    }
}




