//
//  FavoritosViewController.swift
//  Movs
//
//  Created by Renato Ferraz on 17/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit

protocol pesquisaDelegate {
    func dadosRecebidoFiltro(ano: String, genero: String)
    func removerFiltro()
}

class FavoritosViewController: UIViewController, pesquisaDelegate {
    
    var favoritos : Array<Filmes> = []
    var filtro: Array<Filmes> = []
    
    @IBOutlet weak var btnFiltro: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filtrandoDados : Bool = false
    var filtroPesquisa: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favoritos = []
        self.filtro = []
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        self.navigationController?.setStatusBar(backgroundColor: UIColor.AmareloClaro())
        self.navigationController?.navigationBar.backgroundColor = UIColor.AmareloClaro()
        self.navigationController?.navigationBar.tintColor = UIColor.AzulEscuro()

        //pesquisa
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.searchBar.backgroundColor = UIColor.AmareloClaro()
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !filtroPesquisa {
            recuperarDados()
        }
    }
    
    func recuperarDados(){
                
        if !filtrandoDados {
            favoritos = Favoritos.getTodosFavoritos()
            favoritos.sort {$0.title < $1.title}
            filtro = favoritos
            tableView.reloadData()
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        recuperarDados()
        refreshControl.endRefreshing()
    }
    
    func filtrando(termo: String){
        if termo.count > 0 {
            filtro = []
            filtrandoDados = true
            for item in self.favoritos {
                if (item.title.lowercased().contains(searchController.searchBar.text!.lowercased())) {
                    self.filtro.append(item)
                }
            }
            tableView.reloadData()
        }else{
            filtro = favoritos
            tableView.reloadData()
        }
    }
    
    func restorarDados(){
        filtrandoDados = false
        filtro = favoritos
        tableView.reloadData()
    }
    
    //MARK: Filtro(delegate)
    func dadosRecebidoFiltro(ano: String, genero: String) {
        favoritos = []
        filtro = []
        
        if ano != "", genero == ""{ //filtro somente por ano
            let filtroAno: [Filmes] = Favoritos.getFilmesFiltro(ano: ano)
            favoritos = filtroAno
        }else if genero != "", ano == "" { //filtro somente por genero
            let array: Array<String> = Genero.getGenerosFiltro(idGeneros: genero)
            
            let filtroGenero: [Filmes] = Favoritos.getFilmesFiltroPorGenero(idFilmes: array)
            favoritos = filtroGenero
            
        }else if ano != "", genero != "" { //Pesquisa por ano e genero
            
            let filtroAno: [Filmes] = Favoritos.getFilmesFiltro(ano: ano)

            let array: Array<String> = Genero.getGenerosFiltro(idGeneros: genero)
            let filtroGenero: [Filmes] = Favoritos.getFilmesFiltroPorGenero(idFilmes: array)

            for genero in filtroGenero {
                var encontrou = false
                
                for ano in filtroAno {
                    
                    if ano.id == genero.id {
                        encontrou = true
                    }
                    
                }
                
                if encontrou {
                    favoritos.append(genero)
                }
                
            }
            
        }else{ //filtro retorno nada
            favoritos = Favoritos.getTodosFavoritos()
        }
        
        favoritos.sort {$0.title < $1.title}
        filtro = favoritos
        filtroPesquisa = true
        tableView.reloadData()
    }
    
    func removerFiltro() {
        recuperarDados()
        filtroPesquisa = false
        tableView.reloadData()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "filtroSegue") {
            let vc: FiltroPrincipalViewController = segue.destination as! FiltroPrincipalViewController
            vc.delegate = self
        }
        
    }
        
}

extension FavoritosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtro.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hearder = Bundle.main.loadNibNamed("HeaderFavTableViewCell", owner: self, options: nil)?.first as! HeaderFavTableViewCell as HeaderFavTableViewCell
        
        hearder.delegate = self

        return hearder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filtroPesquisa {
            return 70
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView  = UIView.init()
        tableView.separatorStyle = .singleLine

        if filtro.count == 0 {
            if filtrandoDados {
                
                let vcSemRegistro = SemRegistro.instanceFromNib()
                vcSemRegistro.texto.sizeToFit()
                vcSemRegistro.texto.text = "Sua busca por '\(String(describing: searchController.searchBar.text!))' não resultou em nunhum resultado."
                tableView.separatorStyle = .none
                tableView.backgroundView = vcSemRegistro
                return 0

            }else{
                if filtroPesquisa {
                    self.btnFiltro.isEnabled = true
                } else {
                    self.btnFiltro.isEnabled = false
                }
                let vcError = Error.instanceFromNib()
                tableView.separatorStyle = .none
                tableView.backgroundView = vcError
                return 0
            }
        }
        
        self.btnFiltro.isEnabled = true
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resultado: Filmes
              
        resultado = filtro[indexPath.row]
        
        let urlImagem = URL(string: "\(Constantes.URL_IMAGEM)\(resultado.poster)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritosTableViewCell
        
        cell.txtTitle.text = resultado.title
        cell.txtAno.text = resultado.ano
        cell.txtDescricao.text = resultado.descricao
        cell.imagem.sd_setImage(with: urlImagem, placeholderImage: UIImage(named: "placeholder.png"), options: [.refreshCached, .progressiveLoad])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.removeStatusBar()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.AzulEscuro()
        
        let filmeSelecionado: Filmes
        filmeSelecionado = filtro[indexPath.row]
        
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
            
            let filmeSelecionado : Filmes = self.favoritos[indexPath.row]
            
            //remover do banco
            Favoritos.apagarFavoritos(filme: filmeSelecionado)
            //remove o registro do array
            self.favoritos.remove(at: indexPath.row)
            self.filtro.remove(at: indexPath.row)

            self.tableView.reloadData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        swipeActions.performsFirstActionWithFullSwipe = true
        return swipeActions
    }
    
}

extension FavoritosViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filtrando(termo: searchText)
        }
    }
        
}

extension FavoritosViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            filtrando(termo: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        tableView.backgroundView = UIView.init()
        restorarDados()
    }
    
}
