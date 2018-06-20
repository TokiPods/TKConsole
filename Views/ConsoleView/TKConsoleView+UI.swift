//
//  TKConsoleView+UI.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension TKConsoleView {
    
    func setupUI() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        fileListDatePickView.layer.borderWidth = 0.5
        fileListDatePickView.layer.borderColor = UIColor.lightGray.cgColor
        startDateConfirmButton.layer.borderWidth = 1
        startDateConfirmButton.layer.borderColor = UIColor.white.cgColor
        endDateConfirmButton.layer.borderWidth = 1
        endDateConfirmButton.layer.borderColor = UIColor.white.cgColor
        startDateButton.setTitle(Console.shared.minDate.dateDescription, for: UIControlState.normal)
        endDateButton.setTitle(Console.shared.maxDate.dateDescription, for: UIControlState.normal)
        
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchView.layer.shadowColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOpacity = 0.2
        searchView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: searchView.bounds.height/2, width: searchView.bounds.width, height: searchView.bounds.height/2)).cgPath
        
        searchTextField.text = Console.shared.search
        
        bottomArrowButton.isSelected = Console.shared.lockBottom
        
        filterView.layer.borderWidth = 0.5
        filterView.layer.borderColor = UIColor.lightGray.cgColor
        filterView.layer.shadowOffset = CGSize(width: 0, height: -2)
        filterView.layer.shadowColor = UIColor.lightGray.cgColor
        filterView.layer.shadowOpacity = 0.2
        filterView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: filterView.bounds.width, height: filterView.bounds.height/2)).cgPath
        
        filterTextField.text = Console.shared.filter
        
        dateButton.isSelected = Console.shared.hasDate
        fromButton.isSelected = Console.shared.hasFrom
        
        startDatePicker.backgroundColor = UIColor.lightGray
        endDatePicker.backgroundColor = UIColor.lightGray
        startDatePickerValue = Console.shared.startDate
        endDatePickerValue = Console.shared.endDate
    }
    
}
