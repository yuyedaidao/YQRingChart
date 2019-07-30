//
//  YQRingChart.swift
//  Pods-XTRingChart_Example
//
//  Created by 王叶庆 on 2019/5/7.
//

import UIKit

class YQRingChartCircle: UIView {
    let color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        color.setFill()
        let width = min(bounds.width, bounds.height)
        let frame = CGRect(x: (bounds.width - width) / 2 , y: (bounds.height - width) / 2, width: width, height: width)
        context.fillEllipse(in: frame)
    }
}

open class YQRingChartItem {
    public let number: Int
    public let title: String
    public let color: UIColor
    
    public init(number: Int, title: String, color: UIColor) {
        self.number = number
        self.title = title
        self.color = color
    }
}

extension YQRingChartItem: Equatable {
    public static func == (lhs: YQRingChartItem, rhs: YQRingChartItem) -> Bool {
        return (lhs.number == rhs.number) && (lhs.title == rhs.title) && (lhs.color == rhs.color)
    }
}

open class YQRingChart: UIView {

    open var items: [YQRingChartItem]? = nil {
        didSet {
            guard self.items != oldValue else {return}
            layoutItems(self.items)
        }
    }
    private var legend = UIStackView()
    open var ringMinHeight: CGFloat = 140
    open var ringMaxHeight: CGFloat = 220
    open var font = UIFont.systemFont(ofSize: 15)
    open var titleLineHeight: CGFloat = 24
    open var ringWidth: CGFloat = 22
    open var shadowColor: UIColor? = nil
    open var legendOffset: CGFloat = 30
    open var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    open var shadowBlur: CGFloat = 2
    open var emptyColor = UIColor.gray.withAlphaComponent(0.6)
    private var total: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        legend.axis = .horizontal
        legend.alignment = .fill
        legend.distribution = .fill
        addSubview(legend)
        legend.translatesAutoresizingMaskIntoConstraints = false
        legend.leadingAnchor.constraint(equalTo: centerXAnchor, constant: legendOffset).isActive = true
        legend.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func layoutItems(_ items: [YQRingChartItem]?){
        let subviews = legend.arrangedSubviews
        for view in subviews {
            view.removeFromSuperview()
        }
        guard let items = self.items else {
            return
        }
        total = items.reduce(0, { (result, item) -> Int in
            return result + item.number
        })
        setNeedsDisplay()
        let circleStack = UIStackView(arrangedSubviews: items.map { (item) -> YQRingChartCircle in
            let view = YQRingChartCircle(item.color)
            view.backgroundColor = backgroundColor
            return view
        })
        for item in circleStack.arrangedSubviews {
            item.widthAnchor.constraint(equalToConstant: titleLineHeight * 0.5).isActive = true
            item.heightAnchor.constraint(equalToConstant: titleLineHeight).isActive = true
        }
        circleStack.axis = .vertical
        circleStack.alignment = .leading
        circleStack.distribution = .fillEqually
        legend.addArrangedSubview(circleStack)
        circleStack.heightAnchor.constraint(equalToConstant: titleLineHeight * CGFloat(items.count)).isActive = true
        circleStack.widthAnchor.constraint(equalToConstant: titleLineHeight).isActive = true
        let percentStack = UIStackView(arrangedSubviews: items.map({ (item) -> UILabel in
            let label = UILabel()
            label.text = total > 0 ? "\(Int(Float(item.number) / Float(total) * 100))%" : "0%"
            label.font = font
            label.textAlignment = .left
            return label
        }))
        for item in percentStack.arrangedSubviews {
            item.heightAnchor.constraint(equalToConstant: titleLineHeight).isActive = true
        }
        percentStack.axis = .vertical
        legend.addArrangedSubview(percentStack)
        let spaceView = UIView()
        legend.addArrangedSubview(spaceView)
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.widthAnchor.constraint(equalToConstant: titleLineHeight).isActive = true
        spaceView.backgroundColor = backgroundColor
        let titleStack = UIStackView(arrangedSubviews: items.map({ (item) -> UILabel in
            let label = UILabel()
            label.text = item.title
            label.font = font
            label.textAlignment = .center
            return label
        }))
        for item in titleStack.arrangedSubviews {
            item.heightAnchor.constraint(equalToConstant: titleLineHeight).isActive = true
        }
        titleStack.axis = .vertical
        legend.addArrangedSubview(titleStack)
    }
  
    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let items = self.items else {return}
        let halfWidth = bounds.width / 2
        let halfHeight = bounds.height / 2
        let ringCenter = CGPoint(x: halfWidth / 2, y: halfHeight)
        let titleHeight = titleLineHeight * CGFloat(items.count)
        let radius = min(max(titleHeight, ringMinHeight), ringMaxHeight) / 2 - ringWidth / 2 - (shadowColor != nil ? shadowOffset.height + shadowBlur : 0)
        context.setLineWidth(ringWidth)
        context.setLineCap(.round)
        if let shadowColor = self.shadowColor {
            context.setShadow(offset: shadowOffset, blur: shadowBlur, color: shadowColor.cgColor)
        }
        guard total > 0 else {
            //直接画个灰色的圆
            emptyColor.setStroke()
            context.addPath(UIBezierPath(arcCenter: ringCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath)
            context.strokePath()
            return
        }
        var startAngle: CGFloat = 0
        for item in items {
            let angle = CGFloat(item.number) / CGFloat(total) * CGFloat.pi * 2
            let endAngle = startAngle + angle
            //context.addArc(center: ringCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)//这个clockwise参数诡异啊，竟然是反着来的
            context.addPath(UIBezierPath(arcCenter: ringCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath)
            item.color.setStroke()
            context.strokePath()
            #if DEBUG
            print("draw: \(startAngle) - \(endAngle)")
            #endif
            startAngle = endAngle
        }
        ///盖住最后一个弧
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: 0, color: nil)
        guard let item = items.first else {return}
        let angle = CGFloat(item.number) / CGFloat(total) * CGFloat.pi
        context.addPath(UIBezierPath(arcCenter: ringCenter, radius: radius, startAngle: 0, endAngle: angle, clockwise: true).cgPath)
        item.color.setStroke()
        context.strokePath()
        
        ///画图例
        ///不画了，因为害怕产品让做动画，画的话不好展示动画
    }
    
    
    open override var intrinsicContentSize: CGSize {
        guard let items = self.items else {
            return .zero
        }
        var height = titleLineHeight * CGFloat(items.count)
        height = max(ringMinHeight, height)
        return CGSize(width: height * 2, height: height)
    }
}
