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
	@IBOutlet weak var pairList: UITableView!
	@IBOutlet weak var macroSlider: UISlider!
	
	private var integerObservation: NSKeyValueObservation?
	private var arrayObservation: NSKeyValueObservation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let viewModel = GetMainViewModelInstance()
		
		integerObservation = viewModel?.observe(\.intValue, options: [.new, .old]) { object, change in
			
			print( "old value was: " + String(change.oldValue!) )
			print( "new value is: " + String(change.newValue!) )
		}
		
		arrayObservation = viewModel?.observe(\.arrayValue, options: [.new, .old]) { object, change in
			
		//	print( "old value was: " + String(change.oldValue!) )
		//	print( "new value is: " + String(change.newValue!) )
		}
	}

	@IBAction func sliderChanged(_ sender: Any) {
		let slider = sender as! UISlider
		GetMainViewModelInstance().applySliderValue(Int(slider.value))
	}
	
}

extension ViewController : UITableViewDelegate
{
	
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return GetMainViewModelInstance().arrayValue.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tempCellId")
		
		let data = GetMainViewModelInstance().arrayValue[indexPath.row]
		let formattedText = "<" + String(data.column) + ", " + String(data.row) + ">"
		cell!.textLabel?.text = formattedText
		
		return cell!
	}
}

