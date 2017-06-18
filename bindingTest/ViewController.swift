//
//  ViewController.swift
//  bindingTest
//
//  Created by David Ventura on 2017/05/29.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var macroSlider: UISlider!
	
	var buttonObserver: NSKeyValueObservation?
	var sliderObserver: NSKeyValueObservation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let viewModel = GetMainViewModelInstance()
		
		buttonObserver = playButton.observe(\.tracking) { (object, change) in
			if ( object.isTouchInside )
			{
				print("Button was pressed" )
			}
		}
		sliderObserver = macroSlider.observe(\.value) { (object, change) in
			print("Slider became: \(object.value)" )
			viewModel!.applySliderValue(object.value)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

