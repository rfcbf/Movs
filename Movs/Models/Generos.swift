//
//  Generos.swift
//  Movs
//
//  Created by Renato Ferraz on 18/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//
import UIKit

class Generos {
    
    var id: Int
    var title: String
    
    init(){
        self.id = 0
        self.title = ""
    }
    
    init(id: Int,
         title: String){
        
        self.id = id
        self.title = title
    }
}
