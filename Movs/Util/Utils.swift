//
//  Utils.swift
//  Movs
//
//  Created by Renato Ferraz on 14/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit
import DeviceKit

class Utils: NSObject {
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }

    
    func ConvertData(data: String) -> String? {
        
        let start = data.index(data.startIndex, offsetBy: 0)
        let end = data.index(data.endIndex, offsetBy: -14)
        let range = start..<end
        let data = data[range]
                
        TimeZone.ReferenceType.default = TimeZone(abbreviation: "UTC")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        let date = dateFormatter.date(from: String(data))!
        
        return ConvertDataToString(data: date, formato: "dd/MM/yyyy")
        
    }
    
    func ConvertDataToString(data: Date, formato: String) -> String? {
        var dateString: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone.ReferenceType.system
        dateFormatter.dateFormat = formato
        dateString = dateFormatter.string(from: data)
        
        return dateString
    }
    
    func convertNumberStringFormatado(valor : Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "pt_BR")
        
        return formatter.string(from: NSNumber(value: valor))!
        
    }
    
    func dispositivo() -> String{
        
        let device = Device.current
        
        if device.isPhone || device.isPod{
            return "IPHONE"
            // iPhone (real or simulator)
        } else if device.isPad {
            return "IPAD"
            // iPad (real or simulator)
        }
        
        return ""
    }
    
}
