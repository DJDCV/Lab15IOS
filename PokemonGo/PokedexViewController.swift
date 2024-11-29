//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by Deivid Del Carpio on 15/11/24.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var pokemonsAtrapados: [Pokemon] = []
    var pokemonsNoAtrapados: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
        
        tableView.delegate = self
        tableView.dataSource = self
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        } else {
            return "No Atrapados"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsAtrapados.count
        } else {
            return pokemonsNoAtrapados.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "pokemonCell")
        
        let pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
        } else {
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }

        cell.textLabel?.text = pokemon.nombre
        
        // Mostrar el contador en el detailTextLabel
        cell.detailTextLabel?.text = "Capturado: \(pokemon.contador) veces"
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Verificar si el array tiene suficientes elementos
            if indexPath.section == 0 && indexPath.row < pokemonsAtrapados.count {
                let pokemon = pokemonsAtrapados[indexPath.row]
                pokemonsAtrapados.remove(at: indexPath.row)
                
                // Remover el Pokémon de Core Data
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(pokemon)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if indexPath.section == 1 && indexPath.row < pokemonsNoAtrapados.count {
                let pokemon = pokemonsNoAtrapados[indexPath.row]
                pokemonsNoAtrapados.remove(at: indexPath.row)
                
                // Remover el Pokémon de Core Data
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(pokemon)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Índice fuera de los límites del array")
            }
        }
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

