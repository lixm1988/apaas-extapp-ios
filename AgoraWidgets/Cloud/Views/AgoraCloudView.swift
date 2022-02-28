//
//  AgoraCloudView.swift
//  AgoraWidgets
//
//  Created by ZYP on 2021/10/20.
//

import AgoraUIBaseViews

class AgoraCloudView: AgoraBaseUIView {
    let topView = AgoraCloudTopView(frame: .zero)
    let listView = AgoraCloudListView(frame: .zero)
    
    private var headerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initLayout()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        backgroundColor = .white
        layer.shadowColor = UIColor(hex: 0x2F4192,
                                    transparency: 0.15)?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.cornerRadius = 6
        
        // header view
        headerView = UIView()
        let nameLabel = AgoraBaseUILabel()
        let lineView = AgoraBaseUIView()
        
        headerView.backgroundColor = UIColor(hex: 0xF9F9FC)
        nameLabel.text = GetWidgetLocalizableString(object: self,
                                                    key: "CloudFileName")
        
        nameLabel.textColor = UIColor(hex: 0x191919)
        nameLabel.font = .systemFont(ofSize: 13)
        lineView.backgroundColor = UIColor(hex: 0xEEEEF7)
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(lineView)
        
        nameLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.headerView)
            make?.left.equalTo()(self.headerView)?.offset()(14)
        }
        
        lineView.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(self.headerView)
            make?.height.equalTo()(1)
        }
        
        addSubview(topView)
        addSubview(headerView)
        addSubview(listView)
    }
    
    private func initLayout() {
        topView.mas_makeConstraints { make in
            make?.left.and().right().and().top().equalTo()(self)
            make?.height.equalTo()(60)
        }
        
        headerView.mas_makeConstraints { make in
            make?.left.and().right().equalTo()(self)
            make?.top.equalTo()(self.topView.mas_bottom)
            make?.height.equalTo()(30)
        }
        
        listView.mas_makeConstraints { make in
            make?.left.and().right().and().bottom().equalTo()(self)
            make?.top.equalTo()(self.headerView.mas_bottom)
        }
    }
    
    private func commonInit() {
        listView.update(infos: [AgoraCloudCellInfo(imageName: "",
                                                   name: "我的课件.ppt")])
    }
    
}


