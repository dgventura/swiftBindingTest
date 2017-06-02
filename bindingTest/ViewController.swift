//
//  ViewController.swift
//  bindingTest
//
//  Created by David Ventura on 2017/05/29.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var macroSlider: UISlider!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let viewModel = GetMainViewModelInstance()
		viewModel!.applySliderValue( 42 )
		
		playButton.rx.ob
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
