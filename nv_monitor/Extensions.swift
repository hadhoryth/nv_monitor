//
//  Extensions.swift
//  nv_monitor
//
//  Created by Ivan Sahumbaiev on 27/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
