//
//  ImageView.swift
//  ImagePreviewDemo
//
//  Created by Chakery on 16/3/1.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

typealias imageBlock = (imageView: CGYImageView, image: UIImage, index: Int) -> Void
typealias buttonBlock = (imageView: CGYImageView, index: Int) -> Void

protocol CGYImageViewDelegate: class {
	func imageViewDidSelected(imageView: CGYImageView, image: UIImage, index: Int)
	func closeButtonDidSelected(imageView: CGYImageView, index: Int)
}

class CGYImageView: UIView {
	private var imageView: UIImageView! // 图片
	private var closeButton: UIButton! // 关闭按钮
	private var index: Int!// 第几张
	private var image: UIImage // 图片
	private var tap: UITapGestureRecognizer!// 单点手势
	private var imageDidSelectedBlock: imageBlock? // 回调
	private var buttonDidSelectedBlock: buttonBlock? // 回调
	var rectToScreen: CGRect! // 相对于屏幕的Frame
	weak var delegate: CGYImageViewDelegate? // 代理

	init(frame: CGRect, image: UIImage, index: Int) {
		self.image = image
		self.index = index
		super.init(frame: frame)
		didInitImageView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func didInitImageView() {
		imageView = UIImageView(frame: self.bounds)
		imageView.image = image
		imageView.userInteractionEnabled = true
		closeButton = UIButton(frame: CGRect(x: imageView.bounds.width - 20, y: 0, width: 20, height: 20))
		closeButton.backgroundColor = UIColor.redColor()
		closeButton.addTarget(self, action: "closeButtonDidSelected:", forControlEvents: .TouchUpInside)
		tap = UITapGestureRecognizer(target: self, action: "imageViewDidSelected:")

		addSubview(imageView)
		imageView.addSubview(closeButton)
		imageView.addGestureRecognizer(tap)
	}

	@objc private func imageViewDidSelected(tap: UITapGestureRecognizer) {
		delegate?.imageViewDidSelected(self, image: image, index: index)
		imageDidSelectedBlock?(imageView: self, image: image, index: index)
	}

	@objc private func closeButtonDidSelected(button: UIButton) {
		delegate?.closeButtonDidSelected(self, index: index)
		buttonDidSelectedBlock?(imageView: self, index: index)
	}
}

// MARK: - public method
extension CGYImageView {
	/// 图片被点击时的回调
	func didSelected(callBack: imageBlock) {
		imageDidSelectedBlock = callBack
	}
	/// 关闭按钮
	func closeButtonDidselected(callBack: buttonBlock) {
		buttonDidSelectedBlock = callBack
	}
}
