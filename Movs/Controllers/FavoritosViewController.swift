//
//  FavoritosViewController.swift
//  Movs
//
//  Created by Renato Ferraz on 17/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit

class FavoritosViewController: UIViewController {

    var favoritos : Array<Filmes> = []
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperarDados()
    }
    
    func recuperarDados(){
        favoritos = Favoritos.getTodosFavoritos()
        favoritos.sort {$0.title < $1.title}
        tableView.reloadData()
    }
   
    @objc func refresh(sender: AnyObject) {
       recuperarDados()
       refreshControl.endRefreshing()
    }
}

extension FavoritosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let urlImagem = URL(string: "\(Constantes.URL_IMAGEM)\(favoritos[indexPath.row].poster)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritosTableViewCell

        cell.txtTitle.text = favoritos[indexPath.row].title
        cell.txtAno.text = favoritos[indexPath.row].ano
        cell.txtDescricao.text = favoritos[indexPath.row].descricao
        cell.imagem.sd_setImage(with: urlImagem, placeholderImage: UIImage(named: "placeholder.png"), options: [.refreshCached, .progressiveLoad])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        
        let filmeSelecionado : Filmes = favoritos[indexPath.row]
        let vc = UIStoryboard.init(name: "Detail", bundle: Bundle.main).instantiateViewController(withIdentifier: "detalhes") as? DetailViewController
        vc?.filmes = filmeSelecionado
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
         return true
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Desfavoritar") {  (contextualAction, view, boolValue) in

            self.tableView.beginUpdates()
            let filmeSelecionado : Filmes = self.favoritos[indexPath.row]
           
           //remover do banco
           Favoritos.apagarFavoritos(filme: filmeSelecionado)
           //remove o registro do array
           self.favoritos.remove(at: indexPath.row)
           //remove da tabela
           self.tableView.deleteRows(at: [indexPath], with: .automatic)
           self.tableView.endUpdates()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
}
