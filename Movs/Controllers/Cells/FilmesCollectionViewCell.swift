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
    
    var favorito : Bool = false
    var filme = Filmes()
        
    
    @IBAction func btnFavoritar(_ sender: Any) {
        print(filme.title)
        
        if !filme.favorito {
            print("favoritar")
            filme.favorito = true
            btnFavorito.setImage(UIImage(named: "favorite_full"), for: .normal)
            Favoritos.inserirFavoritos(filme: filme)
        } else {
            print("desfavoritar")
            filme.favorito = false
            btnFavorito.setImage(UIImage(named: "favorite_gray"), for: .normal)
            Favoritos.apagarFavoritos(filme: filme)
        }
    }
    
    
}
