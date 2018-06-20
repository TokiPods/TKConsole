//
//  TKConsoleView+TextField.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension TKConsoleView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(filterTextField) {
            Console.shared.filter = textField.text
        }
        if textField.isEqual(searchTextField) {
            Console.shared.search = textField.text
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
