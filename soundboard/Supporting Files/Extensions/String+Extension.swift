//
//  String+Extension.swift
//  ReviewsTap
//
//  Created by Horizam on 15/09/2023.
//

import Foundation

extension String {
    
    func isNumeric() -> Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func isValidPlatform() -> Bool {
        let RegEx = "^\\S{4,100}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isValidUsername() -> Bool {
        let RegEx = "\\A\\w{5,12}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    func validateURL() -> Bool {
        let regex = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: self)
        return result
    }
    func isValidName() -> Bool{
        let regex = "^[a-zA-Z]+(([ ][a-zA-Z ])?[a-zA-Z]*)*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = nameTest.evaluate(with: self)
        return result
    }
    
    func validatePhone() -> Bool {
        //        let regex = "\\+?\\d{1,4}?[-.\\s]?\\(?\\d{1,3}?\\)?[-.\\s]?\\d{1,4}[-.\\s]?\\d{1,4}[-.\\s]?\\d{1,9}"
        //        let regex = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let regex = "^\\+(?:[0-9]+[()]?){6,14}[0-9]$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: self)
        return result
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidIBAN() -> Bool {
        let ibanRegEx = "[a-zA-Z]{2}+[0-9]{2}+[a-zA-Z0-9]{4}+[0-9]{7}([a-zA-Z0-9]?){0,16}"
        let ibanTest = NSPredicate(format:"SELF MATCHES %@", ibanRegEx)
        return ibanTest.evaluate(with: self)
    }
    
    func utcToLocal(format: String = "MM/dd/yyyy" ,utcFormat: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
}
