//
//  AgoraCloudTopBarView.swift
//  AgoraWidgets
//
//  Created by ZYP on 2021/10/20.
//

import AgoraUIBaseViews
import Masonry

protocol AgoraCloudTopViewDelegate: NSObjectProtocol {
    func agoraCloudTopViewDidTapAreaButton(type: AgoraCloudCoursewareType)
    func agoraCloudTopViewDidTapCloseButton()
    func agoraCloudTopViewDidTapRefreshButton()
    func agoraCloudTopViewDidSearch(type: AgoraCloudCoursewareType,
                                    keyStr: String)
}

class AgoraCloudTopView: AgoraBaseUIView {
    /// views
    private let contentView1 = AgoraBaseUIView()
    private let publicAreaButton = AgoraBaseUIButton()
    private let privateAreaButton = AgoraBaseUIButton()
    private let closeButton = AgoraBaseUIButton()
    private let publicAreaIndicatedView = AgoraBaseUIView()
    private let privateAreaIndicatedView = AgoraBaseUIView()
    private let lineView1 = AgoraBaseUIView()
    
    private let contentView2 = AgoraBaseUIView()
    private let refreshButton = AgoraBaseUIButton()
    private let pathNameLabel = AgoraBaseUILabel()
    private let fileCountLabel = AgoraBaseUILabel()
    private let searchBar = UISearchBar()
    private let lineView2 = AgoraBaseUIView()
    
    /// data
    private var selectedType: AgoraCloudCoursewareType = .publicResource
    private var fileNum = 0
    
    /// delegate
    weak var delegate: AgoraCloudTopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        /// 上半部分
        contentView1.backgroundColor = UIColor(hex: 0xF9F9FC)
        let buttonNormalColor = UIColor(hex: 0x586376)
        let buttonSelectedColor = UIColor(hex: 0x191919)
        let indicateViewColor = UIColor(hex: 0x0073FF)
        let lineColor = UIColor(hex: 0xEEEEF7)
        
        publicAreaButton.setTitleForAllStates(GetWidgetLocalizableString(object: self,
                                                             key: "CloudPublicResource"))
        publicAreaButton.titleLabel?.font = .systemFont(ofSize: 12)
        publicAreaButton.setTitleColor(buttonNormalColor,
                                       for: .normal)
        publicAreaButton.setTitleColor(buttonSelectedColor,
                                       for: .selected)
        
        privateAreaButton.setTitleForAllStates(GetWidgetLocalizableString(object: self,
                                                                          key: "CloudPrivateResource"))
        privateAreaButton.titleLabel?.font = .systemFont(ofSize: 12)
        privateAreaButton.setTitleColor(buttonNormalColor,
                                        for: .normal)
        privateAreaButton.setTitleColor(buttonSelectedColor,
                                        for: .selected)
        
        publicAreaIndicatedView.backgroundColor = indicateViewColor
        publicAreaIndicatedView.isHidden = true
        privateAreaIndicatedView.backgroundColor = indicateViewColor
        privateAreaIndicatedView.isHidden = true
        
        closeButton.setImage(GetWidgetImage(object: self,
                                            "icon_close"),
                             for: .normal)
        
        lineView1.backgroundColor = lineColor
        
        addSubview(contentView1)
        contentView1.addSubview(publicAreaButton)
        contentView1.addSubview(privateAreaButton)
        contentView1.addSubview(closeButton)
        contentView1.addSubview(lineView1)
        contentView1.addSubview(publicAreaIndicatedView)
        contentView1.addSubview(privateAreaIndicatedView)
        
        /// 下半部分
        contentView2.backgroundColor = .white
        let refreshImage = GetWidgetImage(object: self,
                                          "icon_refresh")
        let textColor = UIColor(hex: 0x191919)
        
        refreshButton.setImage(refreshImage,
                               for: .normal)
        
        pathNameLabel.textColor = textColor
        pathNameLabel.font = .systemFont(ofSize: 12)
        pathNameLabel.textAlignment = .left
        
        fileCountLabel.textColor = textColor
        fileCountLabel.font = .systemFont(ofSize: 12)
        fileCountLabel.textAlignment = .right
        
        searchBar.placeholder = GetWidgetLocalizableString(object: self,
                                                           key: "CloudSearch")
        if let seachTextFild = searchBar.value(forKey: "searchField") as? UITextField {
            seachTextFild.font = .systemFont(ofSize: 12)
        }
        searchBar.delegate = self
        
        lineView2.backgroundColor = lineColor
        
        addSubview(contentView2)
        contentView2.addSubview(refreshButton)
        contentView2.addSubview(pathNameLabel)
        contentView2.addSubview(fileCountLabel)
        contentView2.addSubview(searchBar)
        contentView2.addSubview(lineView2)
        
        for btn in [publicAreaButton,privateAreaButton,closeButton,refreshButton] {
            btn.addTarget(self,
                          action: #selector(buttonTap(sender:)),
                          for: .touchUpInside)
        }
        
        config(selectedType: .publicResource)
    }
    
    private func initLayout() {
        /// 上半部分
        contentView1.mas_makeConstraints { make in
            make?.left.right().top().equalTo()(self)
            make?.height.equalTo()(30)
        }
        
        publicAreaButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.contentView1)
            make?.left.equalTo()(24)
            make?.width.equalTo()(80)
        }
        
        privateAreaButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.contentView1)
            make?.left.equalTo()(publicAreaButton.mas_right)
            make?.width.equalTo()(80)
        }
        
        publicAreaIndicatedView.mas_makeConstraints { make in
            make?.width.equalTo()(66)
            make?.height.equalTo()(2)
            make?.bottom.equalTo()(self.contentView1)
            make?.centerX.equalTo()(publicAreaButton.mas_centerX)
        }
        privateAreaIndicatedView.mas_makeConstraints { make in
            make?.width.equalTo()(66)
            make?.height.equalTo()(2)
            make?.bottom.equalTo()(self.contentView1)
            make?.centerX.equalTo()(privateAreaButton.mas_centerX)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.contentView1)
            make?.width.height().equalTo()(24)
            make?.right.equalTo()(self.contentView1.mas_right)?.offset()(-10)
        }

        lineView1.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(self.contentView1)
            make?.height.equalTo()(1)
        }
        
        /// 下半部分
        contentView2.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(self)
            make?.height.equalTo()(30)
        }
        
        refreshButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.contentView2)
            make?.left.equalTo()(self.contentView2)?.offset()(21)
            make?.height.equalTo()(26)
            make?.width.equalTo()(26)
        }
        
        pathNameLabel.mas_makeConstraints { make in
            make?.left.equalTo()(refreshButton.mas_right)?.offset()(10)
            make?.centerY.equalTo()(self.contentView2)
        }
        
        fileCountLabel.mas_makeConstraints { make in
            make?.right.equalTo()(self.contentView2)?.offset()(-10)
            make?.centerY.equalTo()(self.contentView2)
        }
        
        searchBar.mas_makeConstraints { make in
            make?.width.equalTo()(160)
            make?.height.equalTo()(22)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.centerY.equalTo()(self.contentView2.mas_centerY)
        }
        
        lineView2.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(self.contentView2)
            make?.height.equalTo()(1)
        }
    }
    
    @objc func buttonTap(sender: UIButton) {
        if sender == closeButton {
            delegate?.agoraCloudTopViewDidTapCloseButton()
            return
        }
        
        if sender == publicAreaButton {
            config(selectedType: .publicResource)
            delegate?.agoraCloudTopViewDidTapAreaButton(type: .publicResource)
            return
        }
        
        if sender == privateAreaButton {
            config(selectedType: .privateResource)
            delegate?.agoraCloudTopViewDidTapAreaButton(type: .privateResource)
            return
        }
        
        if sender == refreshButton {
            delegate?.agoraCloudTopViewDidTapRefreshButton()
            return
        }
    }
    
    private func config(selectedType: AgoraCloudCoursewareType) {
        self.selectedType = selectedType
        switch selectedType {
        case .publicResource:
            privateAreaButton.isSelected = false
            publicAreaButton.isSelected = true
            privateAreaIndicatedView.isHidden = true
            publicAreaIndicatedView.isHidden = false
            pathNameLabel.text = GetWidgetLocalizableString(object: self,
                                                            key: "CloudPublicResource")
        case .privateResource:
            publicAreaButton.isSelected = false
            privateAreaButton.isSelected = true
            publicAreaIndicatedView.isHidden = true
            privateAreaIndicatedView.isHidden = false
            pathNameLabel.text = GetWidgetLocalizableString(object: self,
                                                            key: "CloudPrivateResource")
            break
        }
    }
    
    func set(fileNum: Int) {
        let sumText = GetWidgetLocalizableString(object: self,
                                                 key: "CloudSum")
        let itemText = GetWidgetLocalizableString(object: self,
                                                  key: "CloudItem")
        fileCountLabel.text = "\(sumText)\(fileNum)\(itemText)"
    }
}

// MARK: - UISearchBarDelegate
extension AgoraCloudTopView: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        delegate?.agoraCloudTopViewDidSearch(type: self.selectedType,
                                             keyStr: text)
    }
}
