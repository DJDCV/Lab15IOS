//
//  ViewController.swift
//  PokemonGo
//
//  Created by Deivid Del Carpio on 14/11/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    
    var contActualizaciones = 0
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemons = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.delegate = self
            mapView.showsUserLocation = true
            ubicacion.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                if let coord = self.ubicacion.location?.coordinate {
                    //let pin = MKPointAnnotation()
                    //pin.coordinate = coord
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    let pin = PokePin(coord: coord, pokemon: pokemon)
                    
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 5000.0
                    let randomLon = (Double(arc4random_uniform(200)) - 100.0) / 5000.0
                    pin.coordinate.latitude += randomLat
                    pin.coordinate.longitude += randomLon
                    
                    self.mapView.addAnnotation(pin)
                }
            }
        } else {
            ubicacion.requestWhenInUseAuthorization()
        }
    }

    
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate {
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones < 1 {
            let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        } else {
            ubicacion.stopUpdatingLocation()
        }
        //print("Ubicacion actualizada")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            
            return pinView
        }
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        //pinView.image = UIImage(named: "mew")
        let pokemon = (annotation as! PokePin).pokemon
        pinView.image = UIImage(named: pokemon.imagenNombre!)
        
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegion.init(center: (view.annotation?.coordinate)!, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
            let pokemon = (view.annotation as! PokePin).pokemon
            if let coord = self.ubicacion.location?.coordinate {
                if mapView.visibleMapRect.contains(MKMapPoint(coord)) {
                    if pokemon.atrapado {
                        // Mostrar alerta si el Pokémon ya ha sido capturado
                        let alertaVC = UIAlertController(
                            title: "Ya tienes a este Pokémon",
                            message: "¿Aún así deseas capturarlo nuevamente?",
                            preferredStyle: .alert
                        )
                        
                        let siAccion = UIAlertAction(title: "Sí", style: .default) { _ in
                            self.capturarPokemon(pokemon, mapView: mapView, view: view)
                        }
                        
                        let noAccion = UIAlertAction(title: "No", style: .cancel, handler: nil)
                        
                        alertaVC.addAction(siAccion)
                        alertaVC.addAction(noAccion)
                        
                        self.present(alertaVC, animated: true, completion: nil)
                    } else {
                        // Si el Pokémon no ha sido capturado, procede a capturarlo directamente
                        self.capturarPokemon(pokemon, mapView: mapView, view: view)
                    }
                } else {
                    // Alerta cuando el Pokémon está fuera del alcance
                    let alertaVC = UIAlertController(
                        title: "Upss. Está muy lejos",
                        message: "No puedes atrapar el Pokémon \(pokemon.nombre!). Acércate más.",
                        preferredStyle: .alert
                    )
                    
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    
                    self.present(alertaVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func capturarPokemon(_ pokemon: Pokemon, mapView: MKMapView, view: MKAnnotationView) {
        pokemon.atrapado = true
        pokemon.contador += 1 // Incrementa el contador de capturas
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        mapView.removeAnnotation(view.annotation!)
        
        let alertaVC = UIAlertController(
            title: "Felicidades!!!",
            message: "Atrapaste el Pokémon \(pokemon.nombre!)",
            preferredStyle: .alert
        )
        
        let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertaVC.addAction(okAccion)
        
        self.present(alertaVC, animated: true, completion: nil)
    }


}
