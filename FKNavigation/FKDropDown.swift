//
//  FKDropDown.swift
//  FKDropDown
//
//  Created by Isaac Gongora on 13/11/15.
//  Copyright © 2015 Isaac Gongora. All rights reserved.
//

import UIKit

@objc protocol FKDropDownDelegate {
	func dropDown(dropDown: FKDropDown, didSelectOption option: String, atIndex index: Int)
	optional func dropDownTableWillAppear(dropDown: FKDropDown)
	optional func dropDownTableDidAppear(dropDown: FKDropDown)
	optional func dropDownTableWillDisappear(dropDown: FKDropDown)
	optional func dropDownTableDidDisappear(dropDown: FKDropDown)
}

extension UIFont {
}
class FKDropDown: UIControl, UITableViewDataSource, UITableViewDelegate {
	
	var title: UILabel!
	var rowHeight: CGFloat = 30
	var tableHeight: CGFloat = 0
	var arrow: UILabel!
	var table: UITableView!
	var selectedIndex: Int?
	var font: UIFont! {
		didSet {
			title.font = font
		}
	}
	var options = NSMutableArray()
	var subTitles = NSMutableArray()
	var delegate: FKDropDownDelegate!
	var hideOptionsWhenSelect = true
	var placeholder: String! {
		didSet {
			title.text = placeholder
			title.adjustsFontSizeToFitWidth = true
		}
	}
	override var tintColor: UIColor! {
		didSet {
			title.textColor = tintColor
			arrow.textColor = tintColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setup()
	}
	
	func setup() {
		
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.lightGrayColor().CGColor
		self.backgroundColor = .whiteColor()
		
		title = UILabel(frame: CGRect(x: 10, y: 0, width: CGRectGetWidth(self.frame) - 30, height: CGRectGetHeight(self.frame)))
		title.textAlignment = .Center
		title.backgroundColor = UIColor.clearColor()
		title.font = font
		self.addSubview(title)
		
		arrow = UILabel(frame: CGRect(x: self.frame.size.width - 20, y: 0, width: 20, height: CGRectGetHeight(self.frame)))
		arrow.textAlignment = .Center
		//arrow.font = UIFont.fontAwesomeOfSize(13)
		//arrow.text = String.fontAwesomeIconWithName(.ChevronDown)
		arrow.textColor = UIColor.whiteColor()
		arrow.backgroundColor = .clearColor()
		self.addSubview(arrow)
		self.addTarget(self, action: #selector(FKDropDown.touch), forControlEvents: .TouchUpInside)
	}
	
	func touch() {
		
		selected = !selected
		self.userInteractionEnabled = false
		selected ? showTable() : hideTable()
	}
	
	override func resignFirstResponder() -> Bool {
		
		if selected {
			hideTable()
		}
		return true
	}
	
	func showTable() {
		
		delegate.dropDownTableWillAppear?(self)
		
		table = UITableView(frame: CGRect(x: CGRectGetMinX(self.frame), y: CGRectGetMinY(self.frame), width: CGRectGetWidth(self.frame), height: CGFloat(options.count * Int(rowHeight))))
		if tableHeight != 0 {
			if table.frame.size.height > tableHeight {
				table.frame.size.height = tableHeight
			}
		}
		table.dataSource = self
		table.delegate = self
		table.layer.cornerRadius = 0
		table.layer.borderWidth = 0.5
		table.layer.borderColor = UIColor.lightGrayColor().CGColor
		table.alpha = 0
		self.superview?.insertSubview(table, belowSubview: self)
		if #available(iOS 8.0, *) {
			table.layoutMargins = UIEdgeInsetsZero
		} else {
			// Fallback on earlier versions
		}
		table.separatorInset = UIEdgeInsetsZero
		
		UIView.animateWithDuration(0.2) { () -> Void in
			self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
		}
		
		UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .TransitionFlipFromTop, animations: { () -> Void in
			
			self.table.frame = CGRect(x: CGRectGetMinX(self.frame), y: CGRectGetMaxY(self.frame) + 5, width: CGRectGetWidth(self.frame), height: self.table.frame.size.height)
			self.table.alpha = 1
			
			}, completion: { (didFinish) -> Void in
				self.userInteractionEnabled = true
				self.delegate.dropDownTableDidAppear?(self)
		})
	}
	
	func hideTable() {
		
		delegate.dropDownTableWillDisappear?(self)
		
		UIView.animateWithDuration(0.2) { () -> Void in
			self.arrow.transform = CGAffineTransformMakeRotation(0)
		}
		UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .TransitionFlipFromBottom, animations: { () -> Void in
			
			self.table.frame = CGRect(x: CGRectGetMinX(self.frame), y: CGRectGetMinY(self.frame), width: CGRectGetWidth(self.frame), height: 0)
			self.table.alpha = 0
			
			}, completion: { (didFinish) -> Void in
				
				self.table.removeFromSuperview()
				self.userInteractionEnabled = true
				self.selected = false
				self.delegate.dropDownTableDidDisappear?(self)
		})
	}
	
	// UITableView DataSource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return rowHeight
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cellIdentifier = "UIDropDownCell"
		
		var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
		
		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
		}
		
		if #available(iOS 8.0, *) {
			cell?.layoutMargins = UIEdgeInsetsZero
		} else {
			// Fallback on earlier versions
		}
		cell?.textLabel?.font = font
		cell?.textLabel?.text = "\(options[indexPath.row])"
		if subTitles.count != 0 {
			cell?.detailTextLabel?.text = "\(subTitles[indexPath.row])"
			cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
			//cell?.detailTextLabel?.font = UIFont.WorkSans.Regular(withSize: 12)
		}
		cell?.accessoryType = .None
		cell?.selectionStyle = .None
		
		return cell!
	}
	
	// UITableView Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		selectedIndex = indexPath.row
		delegate.dropDown(self, didSelectOption: "\(options[indexPath.row])", atIndex: indexPath.row)
		
		title.alpha = 0.0
		title.text = "\(self.options[indexPath.row])"
		if subTitles.count != 0 {
			let myAttribute = [ NSForegroundColorAttributeName: UIColor.blueColor(),NSFontAttributeName: title.font ]
			let titleString = NSMutableAttributedString(string: "\(self.options[indexPath.row])\n", attributes: myAttribute )
			
			let font : UIFont = UIFont.systemFontOfSize(13)
			let attributeSubtitle = [ NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName: font  ]
			let subtitleString = NSMutableAttributedString(string: "\(self.subTitles[indexPath.row])", attributes: attributeSubtitle )

			titleString.appendAttributedString(subtitleString)
			title.attributedText = titleString
		}
		
		UIView.animateWithDuration(0.6) { () -> Void in
			self.title.alpha = 1.0
		}
		tableView.reloadData()
		if hideOptionsWhenSelect {
			hideTable()
		}
	}
}
