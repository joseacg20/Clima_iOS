//
//  ViewController.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let climaManager = ClimaManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Implementar el delagado para el teclado
        searchTextField.delegate = self
    }
    
    // Programar el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        cityLabel.text = searchTextField.text
        return true
    }
    
    // Validacion del textField (para saber si esta vacio)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Escribe la ciduad"
            return false
        }
    }

    @IBAction func ButtonSearch(_ sender: UIButton) {
        cityLabel.text = searchTextField.text
        climaManager.fechtClima(nameCity: searchTextField.text!)
    }
}
