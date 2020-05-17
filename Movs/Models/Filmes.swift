//
//  Filmes.swift
//  Movs
//
//  Created by Renato Ferraz on 14/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit

class Filmes {
    
    var id: Int
    var title: String
    var descricao: String //overview
    var ano: String //release_date
    var adulto : Bool //adult
    var imagemFundo : String //backdrop_path
    var generosID : Array<Int> //genreIds
    var generosNomes : Array<String> //genreIds
    var producao : Array<String> //genreIds
    var linguagemOriginal : String //original_language
    var popularidade : Double //popularity
    var poster : String //poster_path
    var mediaVoto : Double //vote_average
    var totalVotos : Double //vote_count
    
    
    init(){
        self.id = 0
        self.title = ""
        self.descricao = ""
        self.adulto = false
        self.imagemFundo = ""
        self.generosID = []
        self.generosNomes = []
        self.producao = []
        self.linguagemOriginal = ""
        self.popularidade = 0
        self.poster = ""
        self.mediaVoto = 0
        self.totalVotos = 0
        self.ano = ""
    }
    
    init(id: Int,
         title: String,
         descricao: String ,
         ano: String,
         adulto : Bool,
         imagemFundo : String,
         generosID : Array<Int>,
         generosNomes : Array<String>,
         producao : Array<String>,
         linguagemOriginal : String,
         popularidade : Double,
         poster : String,
         mediaVoto : Double,
         totalVotos : Double ){
        
        self.id = id
        self.title = title
        self.descricao = descricao
        self.adulto = adulto
        self.imagemFundo = imagemFundo
        self.generosID = generosID
        self.generosNomes = generosNomes
        self.producao = producao
        self.linguagemOriginal = linguagemOriginal
        self.popularidade = popularidade
        self.poster = poster
        self.mediaVoto = mediaVoto
        self.totalVotos = totalVotos
        self.ano = ano
    }
    
    
}
