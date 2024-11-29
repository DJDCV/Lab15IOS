//
//  Funciones.swift
//  PokemonGo
//
//  Created by Deivid Del Carpio on 15/11/24.
//

import UIKit
import CoreData

func crearPokemon(xnombre: String, ximagenNombre: String) -> Pokemon? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "nombre == %@", xnombre)

    do {
        let pokemons = try context.fetch(fetchRequest)
        if let existingPokemon = pokemons.first {
            existingPokemon.contador += 1
            return existingPokemon
        } else {
            let newPokemon = Pokemon(context: context)
            newPokemon.nombre = xnombre
            newPokemon.imagenNombre = ximagenNombre
            newPokemon.contador = 1
            return newPokemon
        }
    } catch {
        print("Error al verificar el Pokémon en Core Data")
        return nil // Devuelve nil en caso de error
    }
}

func agregarPokemons() {
    crearPokemon(xnombre: "Mew", ximagenNombre: "mew")
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth")
    crearPokemon(xnombre: "Abra", ximagenNombre: "abra")
    crearPokemon(xnombre: "Bulbasaur", ximagenNombre: "bulbasaur")
    crearPokemon(xnombre: "Dratini", ximagenNombre: "dratini")
    crearPokemon(xnombre: "Eevee", ximagenNombre: "eevee")
    crearPokemon(xnombre: "Mankey", ximagenNombre: "mankey")
    crearPokemon(xnombre: "Pikachu", ximagenNombre: "pikachu-2")
    crearPokemon(xnombre: "Psyduck", ximagenNombre: "psyduck")
    crearPokemon(xnombre: "Rattata", ximagenNombre: "rattata")
    crearPokemon(xnombre: "Snorlax", ximagenNombre: "snorlax")
    crearPokemon(xnombre: "Squirtle", ximagenNombre: "squirtle")
    crearPokemon(xnombre: "Venonat", ximagenNombre: "venonat")
    crearPokemon(xnombre: "Weedle", ximagenNombre: "weedle")
    crearPokemon(xnombre: "Zubat", ximagenNombre: "zubat")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func obtenerPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            agregarPokemons()
            return obtenerPokemon()
        }
        return pokemons
    } catch {
        return []
    }
}

func obtenerPokemonsAtrapados() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: true))
    do {
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    } catch {
        return []
    }
}

func obtenerPokemonsNoAtrapados() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: false))
    do {
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    } catch {
        return []
    }
}

