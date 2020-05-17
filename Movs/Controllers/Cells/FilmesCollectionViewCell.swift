//
//  FilmesCollectionViewCell.swift
//  Movs
//
//  Created by Renato Ferraz on 14/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit

class FilmesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var btnFavorito: UIButton!
    @IBOutlet weak var imagem: UIImageView!
    
    @IBOutlet weak var viewFavorito: UIView!
}
