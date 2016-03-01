//
//  ChooseImageView.swift
//  ImagePreviewDemo
//
//  Created by Chakery on 16/3/1.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

private let countOfRow: CGFloat = 5
private let margin: CGFloat = 10

class ChooseImageView: UIView {
	private var pickerViewControl: UIImagePickerController!
	private var scrollView: UIScrollView!
	private dynamic var datasource: [UIImage] = []
	private var cgyImages: [CGYImageView] = []
	private var myContext = 0
	private var addButton: UIButton!
	private var buttonWidth: CGFloat!
	private var buttonHeight: CGFloat!
	private var myWindow: UIWindow!
	private var fixed: Bool
	private var scroll: Bool

	init(frame: CGRect, datasource: [UIImage] = [], fixed: Bool, scroll: Bool) {
		self.scroll = scroll
		self.fixed = fixed
		self.datasource = datasource
		super.init(frame: frame)
		didInit()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func didInit() {
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor(white: 0, alpha: 0.5).CGColor

		self.addObserver(self, forKeyPath: "datasource", options: [.New, .Old], context: &myContext)

		myWindow = UIApplication.sharedApplication().delegate?.window!

		buttonWidth = (bounds.width - ((countOfRow + 1) * margin)) / countOfRow
		buttonHeight = bounds.height - (margin * 2)

		pickerViewControl = UIImagePickerController()
		pickerViewControl.sourceType = .PhotoLibrary
		pickerViewControl.delegate = self
		pickerViewControl.allowsEditing = true

		scrollView = UIScrollView(frame: self.bounds)
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		addSubview(scrollView)

		addButton = UIButton(frame: CGRect(x: margin, y: margin, width: buttonWidth, height: buttonHeight))
		addButton.addTarget(self, action: "addButtonDidSelected:", forControlEvents: .TouchUpInside)
		addButton.backgroundColor = UIColor.orangeColor()
		scrollView.addSubview(addButton)
	}

	/// KVO 监听数据源, 数据源发生改变时, 调用cgyImageViewDrawToScrollView:把选择的图片绘制出来
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let _ = change where context == &myContext {
			let width = CGFloat(datasource.count + 1) * (buttonWidth + margin) + margin
			scrollView.contentSize = CGSize(width: width, height: 0)
			changeAddButtonFrame(fixed)
			cgyImageViewDrawToScrollView(datasource)
			scrollToRight()
		}
	}

	/// 选择图片的按钮点击事件
	@objc private func addButtonDidSelected(button: UIButton) {
		let rootvc = UIApplication.sharedApplication().keyWindow?.rootViewController
		rootvc?.presentViewController(pickerViewControl, animated: true, completion: nil)
	}

	/// 根据提供的数据源, 把选择的图片绘制到scrollview上
	private func cgyImageViewDrawToScrollView(datasource: [UIImage]) {
		let scrollViewSubviews = scrollView.subviews
		let _ = scrollViewSubviews.map {
			if $0.isMemberOfClass(CGYImageView.self) {
				$0.removeFromSuperview()
			}
		}

		cgyImages.removeAll()

		for i in 0 ..< datasource.count {
			var x: CGFloat = margin + (CGFloat(i) * (buttonWidth + margin))
			if fixed {
				x += (buttonWidth + margin)
			}
			let rect = CGRect(x: x, y: margin, width: buttonWidth, height: buttonHeight)
			let cgyImageView = CGYImageView(frame: rect, image: datasource[i], index: i)
			cgyImageView.delegate = self
			scrollView.addSubview(cgyImageView)

			let rectToScreen = cgyImageView.convertRect(cgyImageView.bounds, toView: myWindow!)
			cgyImageView.rectToScreen = rectToScreen
			cgyImages.append(cgyImageView)
		}
	}

	/// 移动addButton的位置
	private func changeAddButtonFrame(fixed: Bool) {
		if fixed {
			return
		}
		var rect = addButton.frame
		rect.origin.x = margin + CGFloat(buttonWidth + margin) * CGFloat(datasource.count)
		addButton.frame = rect
	}

	/// 滚动到scrollview的最右边
	///
	/// - parameter scrollview: 需要滚动的scrollview
	private func scrollToRight() {
		if !scroll {
			return
		}
		let x = CGFloat(datasource.count + 1) * (buttonWidth + margin)
		let size = scrollView.contentSize
		if size.width >= self.bounds.width {
			let scrollToRect = CGRect(x: x, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
			scrollView.scrollRectToVisible(scrollToRect, animated: false)
		}
	}

	deinit {
		// 移除监听
		self.removeObserver(self, forKeyPath: "datasource")
	}
}

// MARK: - CGYImageViewDelegate
extension ChooseImageView: CGYImageViewDelegate {
	func imageViewDidSelected(imageView: CGYImageView, image: UIImage, index: Int) {
		print(imageView.frame)
	}
	func closeButtonDidSelected(imageView: CGYImageView, index: Int) {
		datasource.removeAtIndex(index)
	}
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ChooseImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		pickerViewControl.dismissViewControllerAnimated(true, completion: nil)
	}

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let type = info[UIImagePickerControllerMediaType] as! String

		if type == "public.image" {
			let image = info[UIImagePickerControllerEditedImage] as! UIImage
			datasource.append(image)
		}

		pickerViewControl.dismissViewControllerAnimated(true, completion: nil)
	}
}
