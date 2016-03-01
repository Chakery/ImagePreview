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

		let rect1 = CGRect(x: 0, y: 0, width: rect.width, height: 300)
		let view1 = UIView(frame: rect1)
        view1.backgroundColor = UIColor.orangeColor()
		view.addSubview(view1)

		let rect2 = CGRect(x: 10, y: 30, width: rect.width, height: 200)
		let view2 = UIView(frame: rect2)
        view2.backgroundColor = UIColor.greenColor()
		view1.addSubview(view2)

		let cRect = CGRect(x: 10, y: 40, width: view2.bounds.width - 30, height: 100)
		let cv = ChooseImageView(frame: cRect, fixed: true, scroll: true)
		view2.addSubview(cv)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
