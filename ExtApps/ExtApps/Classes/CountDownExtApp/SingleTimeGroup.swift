//
//  SingleTimeGroup.swift
//  AgoraEducation
//
//  Created by LYY on 2021/5/11.
//  Copyright © 2021 Agora. All rights reserved.
//

import Foundation
import AgoraUIBaseViews

@objcMembers class SingleTimeGroup: AgoraBaseUIView {
    
    private let animaKey = "com.page.count"
    
    private lazy var topView: SingleTimeView = SingleTimeView(frame: .zero)
    private lazy var bottomView: SingleTimeView = SingleTimeView(frame: .zero)
    private lazy var upPageView: SingleTimeView = SingleTimeView(frame: .zero)
    private lazy var downPageView: SingleTimeView = SingleTimeView(frame: .zero)
    private lazy var lineImgView: UIImageView = {
        let v = UIImageView(image: UIImage.ag_imageNamed("ic_countdown_line",
                                                         in: "AgoraExtApps"))
        return v
    }()
    
    private var timeStr: String = "" {
        didSet {
            guard oldValue != timeStr else {
                return
            }
            topView.label.text = timeStr
            self.startAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.frame = self.bounds
        bottomView.frame = self.bounds
        upPageView.frame = self.bounds
        downPageView.frame = self.bounds
        maskTopView()
        maskBottomView()
    }
}
// MARK: - Private
private extension SingleTimeGroup {
    func maskTopView() {
        let height = self.bounds.height
        let path = UIBezierPath(rect: CGRect(x: 0,
                                             y: 0, width: self.bounds.width,
                                             height: height * 0.5))
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillRule = .evenOdd
        shapeLayer.path = path.cgPath
        topView.layer.mask = shapeLayer
    }
    func maskBottomView() {
        let height = self.bounds.height
        let path = UIBezierPath(rect: CGRect(x: 0,
                                             y: height * 0.5,
                                             width: self.bounds.width,
                                             height: height * 0.5))
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillRule = .evenOdd
        shapeLayer.path = path.cgPath
        bottomView.layer.mask = shapeLayer
    }
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        animation.fromValue = Double.pi * 0
        animation.toValue = Double.pi * -0.5
        animation.duration = 0.25
        animation.repeatCount = 0
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        upPageView.layer.add(animation, forKey: animaKey)
    }
    
    func continueAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        animation.fromValue  = Double.pi * -1.5
        animation.toValue = Double.pi * -2
        animation.duration = 0.25
        animation.repeatCount = 0
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        downPageView.layer.add(animation, forKey: animaKey)
    }
}
extension SingleTimeGroup: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        if anim == upPageView.layer.animation(forKey: animaKey) {
            upPageView.isHidden = false
        }
        if anim == downPageView.layer.animation(forKey: animaKey) {
            downPageView.label.text = timeStr
            downPageView.isHidden = false
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == upPageView.layer.animation(forKey: animaKey) {
            upPageView.isHidden = true
            continueAnimation()
            upPageView.label.text = timeStr
        }
        if anim == downPageView.layer.animation(forKey: animaKey) {
            bottomView.label.text = timeStr
        }
    }
}

// MARK: public
extension SingleTimeGroup {
    public func updateStr(str: String) {
        DispatchQueue.main.async {
            self.timeStr = str
        }
    }
    
    public func turnColor(color: UIColor) {
        DispatchQueue.main.async {
            for timeView in [self.topView,self.bottomView,self.upPageView,self.downPageView] {
                timeView.turnColor(color: color)
            }
        }
    }
}

// MARK: private
fileprivate extension SingleTimeGroup {
    private func createViews() {
        addSubview(upPageView)
        addSubview(topView)
        addSubview(bottomView)
        addSubview(downPageView)
        addSubview(lineImgView)
        lineImgView.mas_makeConstraints { make in
            make?.left.right().centerY().equalTo()(0)
            make?.height.equalTo()(1)
        }
        self.isUserInteractionEnabled = false
    }
}
