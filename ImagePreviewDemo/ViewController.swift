//
//  ViewController.swift
//  ImagePreviewDemo
//
//  Created by Chakery on 16/3/1.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let rect = UIScreen.mainScreen().bounds
		let cRect = CGRect(x: 10, y: 100, width: rect.width - 20, height: 100)
		let cv = ChooseImageView(frame: cRect, fixedAddButton: false, autoScroll: true)
		self.modalPresentationStyle = .CurrentContext
		view.addSubview(cv)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
} 
