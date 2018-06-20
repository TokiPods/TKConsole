//
//  TKConsoleView+UIResponse.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension TKConsoleView {
    
    @IBAction func titleButtonTap(_ sender: Any) {
        fileListView.isHidden = !fileListView.isHidden
        
        if fileListView.isHidden {
            fileListViewHeightConstraint.constant = 0
            fileListDatePickViewHeightConstraint.constant = 0
            
            titleArrowLabel.text = "▽"
        }else{
            fileListViewHeightConstraint.constant = 160
            fileListDatePickViewHeightConstraint.constant = 25
            
            titleArrowLabel.text = "△"
            refreshLogFileList()
        }
    }
    
    @IBAction func closeButtonTap(_ sender: Any) {
        self.delegate?.dismiss(self)
    }
    
    @IBAction func optionButtonTap(_ sender: Any) {
        switch status {
        case .current:
            Console.shared.saveLog()
            
            refreshLogFileList()
            
            if Console.shared.endDate.weeDate == Console.shared.maxDate.weeDate && fileListTableView.contentSize.height > fileListTableView.frame.height{
                fileListTableView.setContentOffset(CGPoint(x: 0, y: fileListTableView.contentSize.height-fileListTableView.frame.height), animated: true)
            }
        case .history:
            status = .current
            
            titleLabel.text = "Current Log"
            optionButton.setTitle("Save", for: UIControlState.normal)
            
            if let indexPath = selectedIndexPath {
                fileListTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        refreshLog()
    }
    
    @IBAction func refreshButtonTap(_ sender: Any) {
        Console.shared.updateLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        if selectedIndexPath != nil {
            if let indexPath = selectedIndexPath {
                let file = fileMapList[indexPath.section].fileList[indexPath.row]
                file.removeLog()
                
                Console.shared.updateLogFileList()
                refreshLogFileList()
            }
        }
    }
    
    @IBAction func startDateButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        endDatePicker.isHidden = true
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDateButton.setTitle(endDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.endDate = endDatePickerValue
        
        //开启开始时间的选择器
        startDatePicker.isHidden = false
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDatePicker.setDate(Console.shared.startDate, animated: false)
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func endDateButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        startDatePicker.isHidden = true
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDateButton.setTitle(startDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.startDate = startDatePickerValue
        
        //开启开始时间的选择器
        endDatePicker.isHidden = false
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDatePicker.setDate(Console.shared.endDate, animated: false)
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func startDateConfirmButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        startDatePicker.isHidden = true
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDateButton.setTitle(startDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.startDate = startDatePickerValue
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func endDateConfirmButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        endDatePicker.isHidden = true
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDateButton.setTitle(endDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.endDate = endDatePickerValue
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func bottomArrowButtonTap(_ sender: Any) {
        let bottomArrowButton = sender as! UIButton
        bottomArrowButton.isSelected = !bottomArrowButton.isSelected
        
        Console.shared.lockBottom = bottomArrowButton.isSelected
        refreshLog()
    }
    
    @IBAction func topArrowButtonTap(_ sender: Any) {
        logTextView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func dateButtonTap(_ sender: Any) {
        let dateButton = sender as! UIButton
        dateButton.isSelected = !dateButton.isSelected
        
        Console.shared.hasDate = dateButton.isSelected
        refreshLog()
    }
    
    @IBAction func fromButtonTap(_ sender: Any) {
        let fromButton = sender as! UIButton
        fromButton.isSelected = !fromButton.isSelected
        
        Console.shared.hasFrom = fromButton.isSelected
        refreshLog()
    }
    
    @IBAction func startDatePickerValueChange(_ sender: Any) {
        startDatePickerValue = startDatePicker.date
    }
    
    @IBAction func endDatePickerValueChange(_ sender: Any) {
        endDatePickerValue = endDatePicker.date
    }
    
}
