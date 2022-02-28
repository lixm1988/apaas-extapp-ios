//
//  AgoraCloudCell.swift
//  AgoraWidgets
//
//  Created by ZYP on 2021/10/21.
//

import AgoraUIBaseViews
import Masonry

struct AgoraCloudCellInfo {
    let imageName: String
    let name: String
    
    static var empty: AgoraCloudCellInfo {
        AgoraCloudCellInfo(imageName: "",
                           name: "")
    }
    
    init(imageName: String,
         name: String) {
        self.imageName = imageName
        self.name = name
    }
    
    init(fileItem: CloudServerApi.FileItem) {
        self.imageName = AgoraCloudCellInfo.imageName(ext: fileItem.ext)
        self.name = fileItem.resourceName
    }

    init(courseware: AgoraCloudCourseware) {
        self.imageName = AgoraCloudCellInfo.imageName(ext: "ext")
        self.name = courseware.resourceName
    }

    static func imageName(ext: String) -> String {
        switch ext {
        case "pptx", "ppt", "pptm":
            return "format-PPT"
        case "docx", "doc":
            return "format-word"
        case "xlsx", "xls", "csv":
            return "format-excel"
        case "pdf":
            return "format-pdf"
        case "jpeg", "jpg", "png", "bmp":
            return "format-pic"
        case "mp3", "wav", "wma", "aac", "flac", "m4a", "oga", "opu":
            return "format-audio"
        case "mp4", "3gp", "mgp", "mpeg", "3g2", "avi", "flv", "wmv", "h264",
            "m4v", "mj2", "mov", "ogg", "ogv", "rm", "qt", "vob", "webm":
            return "format-video"
        default:
            return "format-unknown"
        }
    }
}

class AgoraCloudCell: AgoraBaseUITableViewCell {
    
    private let iconImageView = AgoraBaseUIImageView(frame: .zero)
    private let nameLabel = AgoraBaseUILabel()
    private var info: AgoraCloudCellInfo = .empty
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        setup()
        initLayout()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        nameLabel.textColor = UIColor(hex: 0x191919)
        
        
        nameLabel.font = .systemFont(ofSize: 13)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImageView)
    }
    
    private func initLayout() {
        iconImageView.mas_makeConstraints { make in
            make?.height.equalTo()(22)
            make?.width.equalTo()(22)
            make?.left.equalTo()(16)
            make?.centerY.equalTo()(self.contentView)
        }
        
        nameLabel.mas_makeConstraints { make in
            make?.left.equalTo()(self.iconImageView.mas_right)?.offset()(9)
            make?.centerY.equalTo()(self.contentView)
        }
    }
    
    private func commonInit() {}
    
    func set(info: AgoraCloudCellInfo) {
        self.info = info
        iconImageView.image = GetWidgetImage(object: self,
                                             info.imageName)
        nameLabel.text = info.name
    }
}
