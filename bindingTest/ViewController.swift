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
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear( animated )
		
		let viewModel = GetMainViewModelInstance()
		
		integerObservation = viewModel?.observe(\.intValue, options: [.new, .old]) { object, change in
			
			print( "old value was: " + String(change.oldValue!) )
			print( "new value is: " + String(change.newValue!) )
		}
		
		arrayObservation = viewModel?.observe(\.arrayValue, options: [.new, .old]) { object, change in
			
			print( "array is: " + String(describing: object) )
			if ( change.kind == .removal )
			{
				print( "removed old value was: " + String(describing: change.oldValue) )
				let removedRow = change.indexes!.min()
				let indexPath = IndexPath(row: removedRow!, section: 0);
				self.pairList.deleteRows(at: [indexPath], with: .fade)
			}
			else if ( change.kind == .insertion )
			{
				print( "inserted new value is: " + String(describing: change.newValue) )
				let addedRow = change.indexes!.min()
				let indexPath = IndexPath(row: addedRow!, section: 0);
				self.pairList.insertRows(at: [indexPath], with: .fade)
			}
			else
			{
				self.pairList.reloadData()
			}
		}
	}

	@IBAction func sliderChanged(_ sender: Any) {
		let slider = sender as! UISlider
		GetMainViewModelInstance().applySliderValue(Int(slider.value))
	}
	
	
	@IBAction func insertPairTapped(_ sender: Any) {
		GetMainViewModelInstance().applyButtonTap()
	}
	
}

extension ViewController : UITableViewDelegate
{
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if ( editingStyle == .delete )
		{
			GetMainViewModelInstance().arrayValue.removeObject(at: indexPath.row)
		}
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return GetMainViewModelInstance().arrayValue.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tempCellId")
		
		let data : WrappedClass = GetMainViewModelInstance().arrayValue.object(at: indexPath.row) as! WrappedClass
		let formattedText = "<" + String(data.column) + ", " + String(data.row) + ">"
		cell!.textLabel?.text = formattedText
		
		return cell!
	}
}

