//
//  PreviewController.swift
//  ImagePreviewDemo
//
//  Created by ZZLClick on 16/3/1.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
	private var scrollView: UIScrollView!
	private var pageLabel: UILabel!
	private struct flag { static var i: Int = 0 }
	private let mainRect = UIScreen.mainScreen().bounds
	private var block: (() -> Void)?
	var datasource: [CGYImageView] = []
	var index: Int = 0

	override func viewWillAppear(animated: Bool) {
		let imageView = scrollView.subviews[index] as! UIImageView
		UIView.animateWithDuration(0.3) { [unowned self] _ in
			var rect = imageView.frame
			rect = self.defaultBigImageFrame(self.datasource[self.index])
			imageView.frame = rect
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setView()
		didInit()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	private func setView() {
		view.backgroundColor = UIColor(white: 0, alpha: 0.5)
	}

	private func didInit() {
		scrollView = UIScrollView(frame: mainRect)
		scrollView.delegate = self
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.pagingEnabled = true
        scrollView.bounces = false
		scrollView.backgroundColor = UIColor.clearColor()
		scrollView.contentSize = CGSize(width: CGFloat(datasource.count) * mainRect.width, height: 0)
		view.addSubview(scrollView)

		let _ = datasource.map {
			let imageView = UIImageView()
			let tap = UITapGestureRecognizer(target: self, action: "imageDidSelected:")
			imageView.userInteractionEnabled = true
			imageView.image = $0.image
			imageView.backgroundColor = UIColor.clearColor()
			if flag.i == index {
				imageView.frame = defaultSmallImageFrame($0)
			} else {
				imageView.frame = defaultBigImageFrame($0)
			}
			imageView.addGestureRecognizer(tap)
			scrollView.addSubview(imageView)
			flag.i += 1
		}

		scrollView.setContentOffset(CGPoint(x: CGFloat(index) * mainRect.width, y: 0), animated: true)

		pageLabel = UILabel(frame: CGRect(x: 0, y: 40, width: mainRect.width, height: 20))
		pageLabel.textColor = UIColor.whiteColor()
		pageLabel.font = UIFont.systemFontOfSize(17)
		pageLabel.textAlignment = .Center
		pageLabel.text = "\(index + 1) / \(datasource.count)"
		view.addSubview(pageLabel)
	}

	@objc private func imageDidSelected(tap: UITapGestureRecognizer) {
		dismiss()
	}

	private func defaultBigImageFrame(cgyImage: CGYImageView) -> CGRect {
		let width: CGFloat = cgyImage.image.size.width >= mainRect.width ? mainRect.width : cgyImage.image.size.width
		let height: CGFloat = cgyImage.image.size.height >= mainRect.height ? mainRect.height : cgyImage.image.size.height
		let x: CGFloat = (mainRect.width - width) * 0.5 + (CGFloat(cgyImage.index) * mainRect.width)
		let y: CGFloat = (mainRect.height - height) * 0.5
		return CGRect(x: x, y: y, width: width, height: height)
	}

	private func defaultSmallImageFrame(cgyImage: CGYImageView) -> CGRect {
		let x: CGFloat = cgyImage.rectToScreen.origin.x + CGFloat(cgyImage.index) * mainRect.width
		let y: CGFloat = cgyImage.rectToScreen.origin.y
		let width: CGFloat = cgyImage.rectToScreen.width
		let height: CGFloat = cgyImage.rectToScreen.height
		return CGRect(x: x, y: y, width: width, height: height)
	}

	private func dismiss() {
		let currentIndex: Int = Int(scrollView.contentOffset.x / mainRect.width)
		print(currentIndex)
		let imageView = scrollView.subviews[currentIndex] as! UIImageView
		UIView.animateWithDuration(0.3, animations: { [unowned self] _ in
			var rect = imageView.frame
			rect = self.defaultSmallImageFrame(self.datasource[currentIndex])
			imageView.frame = rect
			self.view.backgroundColor = UIColor(white: 0, alpha: 0)
			self.pageLabel.hidden = true
		}) { [unowned self] _ in
			flag.i = 0
			self.block?()
		}
	}

	func previewControllerDismiss(callBack: () -> Void) {
		block = callBack
	}
}

extension PreviewController: UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let index = Int(scrollView.contentOffset.x / mainRect.width)
		pageLabel.text = "\(index + 1) / \(datasource.count)"
	}
}
