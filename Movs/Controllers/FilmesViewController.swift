//
//  FirstViewController.swift
//  Movs
//
//  Created by Renato Ferraz on 13/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit
import Alamofire
//import TMDBSwift
import SDWebImage

class FilmesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var pag = 1
    var carregando = false
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var result : Array<Filmes> = []
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        activityIndicator.color = UIColor.AzulEscuro()
        activityIndicator.hidesWhenStopped = true
        
        super.viewDidLoad()
        
        self.collection.collectionViewLayout = self.collectionViewFlowLayout
        
        self.result = []
        carregandoDados(pag: self.pag)
    }
    
    func carregandoDados(pag: Int){
        do{
            self.result.append(contentsOf: try FilmeServices.getFilmes(pag: pag))
        }catch{
            print("erro")
        }
    }
    
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
           let layout = CustomCollectionViewFlowLayout(display: .grid(columns: 2), containerWidth: self.view.bounds.width)
           return layout
       }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.reloadCollectionViewLayout(self.view.bounds.size.width)
    }
    
    private func reloadCollectionViewLayout(_ width: CGFloat) {
     
        self.collectionViewFlowLayout.containerWidth = width
        self.collectionViewFlowLayout.display = CollectionDisplay.grid(columns: 2)
     
    }
    
    //MARK: Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFilmes", for: indexPath) as! FilmesCollectionViewCell
        
        let urlImagem = URL(string: "\(Constantes.URL_IMAGEM)\(result[indexPath.item].poster)")
        
        //borda na celula
        cell.contentView.layer.borderColor = UIColor.AzulEscuro().cgColor
        cell.contentView.layer.borderWidth = 0.25
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        //sombra na celular
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        //arrendondando canto esquerdo inferior
        //layerMaxXMaxYCorner – lower right corner
        //layerMaxXMinYCorner – top right corner
        //layerMinXMaxYCorner – lower left corner
        //layerMinXMinYCorner – top left corner
        cell.viewFavorito.layer.cornerRadius = 10
        cell.viewFavorito.layer.maskedCorners = [.layerMinXMaxYCorner]
        cell.viewFavorito.layer.masksToBounds = true
        
//        favorite_gray
//        favorite_full
        
        result[indexPath.item].favorito == true ? cell.btnFavorito.setImage(UIImage(named: "favorite_full"), for: .normal) : cell.btnFavorito.setImage(UIImage(named: "favorite_gray"), for: .normal)
        
        cell.filme = result[indexPath.item]

        cell.lblNome.text = result[indexPath.item].title
        cell.imagem.sd_setImage(with: urlImagem, placeholderImage: UIImage(named: "placeholder.png"), options: [.refreshCached, .progressiveLoad]) 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let filmeSelecionado : Filmes = self.result[indexPath.item]
        let vc = UIStoryboard.init(name: "Detail", bundle: Bundle.main).instantiateViewController(withIdentifier: "detalhes") as? DetailViewController
        vc?.filmes = filmeSelecionado
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !carregando {
                beginBatchFetch()
            }
            
        }
    }
    
    func beginBatchFetch() {
        self.pag += 1
        self.carregando = true
        activityIndicator.startAnimating()
        
        Utils().delayWithSeconds(1) {
            self.carregandoDados(pag: self.pag)
            
            self.collection.reloadData()
            self.carregando = false
            self.activityIndicator.stopAnimating()
        }
        
        
    }
}





