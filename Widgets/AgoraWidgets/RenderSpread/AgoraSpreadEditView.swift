//
//  AgoraSpreadEditView.swift
//  AgoraWidgets
//
//  Created by DoubleCircle on 2022/1/8.
//

import Masonry
import AgoraUIBaseViews

@objc public protocol AgoraSpreadEditViewDelegate {
    func onClickRect()
    func onClickMirror()
    func onClickBright()
    func onClickReset()
}

class AgoraSpreadEditView: AgoraBaseUIView {
    weak var delegate: AgoraSpreadEditViewDelegate?
    
    private var contentView: UIStackView!
    
    private var rectBtn: UIButton!
    
    private var mirrorBtn: UIButton!
    
    private var brightBtn: UIButton!
    
    private var resetBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
        createConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClickRect() {
        self.delegate?.onClickRect()
    }
    
    @objc func onClickMirror() {
        self.delegate?.onClickMirror()
    }
    
    @objc func onClickBright() {
        self.delegate?.onClickBright()
    }
    
    @objc func onClickReset() {
        self.delegate?.onClickRect()
    }
}

// MARK: - Creations
private extension AgoraSpreadEditView {
    func createViews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(hex: 0x2F4192,
                                    transparency: 0.15)?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        // contentView
        contentView = UIStackView()
        contentView.backgroundColor = .clear
        contentView.axis = .horizontal
        contentView.spacing = 2
        contentView.distribution = .equalSpacing
        contentView.alignment = .center
        contentView.backgroundColor = .white
        addSubview(contentView)
        
        let buttonFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
        // micButton
        rectBtn = UIButton(frame: buttonFrame)
        rectBtn.setImage(UIImage.ag_imageNamed("ic_rtm_keyboard_emoji",
                                               in: "AgoraWidgets"),
                           for: .normal)
        rectBtn.addTarget(self,
                            action: #selector(onClickRect),
                            for: .touchUpInside)
        
        contentView.addArrangedSubview(rectBtn)
        // cameraButton
        mirrorBtn = UIButton(frame: buttonFrame)
        mirrorBtn.setImage(UIImage.ag_imageNamed("ic_rtm_keyboard_emoji",
                                                 in: "AgoraWidgets"),
                              for: .normal)
        mirrorBtn.addTarget(self,
                               action: #selector(onClickMirror),
                               for: .touchUpInside)
        contentView.addArrangedSubview(mirrorBtn)
        // stageButton
        brightBtn = UIButton(frame: buttonFrame)
        brightBtn.setImage(UIImage.ag_imageNamed("ic_rtm_keyboard_emoji",
                                                 in: "AgoraWidgets"),
                             for: .normal)
        brightBtn.addTarget(self,
                              action: #selector(onClickBright),
                              for: .touchUpInside)
        contentView.addArrangedSubview(brightBtn)
        // authButton
        resetBtn = UIButton(type: .custom)
        resetBtn.frame = buttonFrame
        resetBtn.setImage(UIImage.ag_imageNamed("ic_rtm_keyboard_emoji",
                                                in: "AgoraWidgets"),
                            for: .normal)
        resetBtn.addTarget(self,
                             action: #selector(onClickReset),
                             for: .touchUpInside)
        contentView.addArrangedSubview(resetBtn)
    }
    
    func createConstrains() {
        contentView.mas_makeConstraints { make in
            make?.left.equalTo()(12)
            make?.right.equalTo()(-12)
            make?.top.bottom().equalTo()(contentView.superview)
        }
    }
}
