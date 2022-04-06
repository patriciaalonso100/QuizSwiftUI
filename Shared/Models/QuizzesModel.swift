//
//  QuizzesModel.swift
//  P1 Quiz SwiftUI
//
//  Created by Santiago Pavón Gómez on 17/09/2021.
//

import Foundation

class QuizzesModel: ObservableObject { //Carga el fichero JSON y mete todos los quizzes en el array de quizzes
    
    // Los datos
    @Published private(set) var quizzes = [QuizItem]() //@Published: si algo cambia, cambian todos los datos. Esta variable se puede consultar, pero no se puede cambiar. No se puede acceder desde fuera.
    
    let token = "8daa7224945b42b59ec7"
    let URL_BASE = "https://core.dit.upm.es/api/"
    
    init(){
        download()
    }
    
    
    func load() { //Método que lee el archivo JSON y rellena el Array
        
        guard let jsonURL = Bundle.main.url(forResource: "p1_quizzes", withExtension: "json") else { //Bundle = saco de ficheros
            print("Internal error: No encuentro p1_quizzes.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: jsonURL) //Data = buffer de bytes (String de bytes)
            let decoder = JSONDecoder() //Máquina de decodificar JSON
            
            //            if let str = String(data: data, encoding: String.Encoding.utf8) {
            //                print("Quizzes ==>", str)
            //            }
            
            let quizzes = try decoder.decode([QuizItem].self, from: data)
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print("Algo chungo ha pasado: \(error)")
        }
    }
    
    func download(){
        let urlStr = "\(URL_BASE)/quizzes/random10wa?token=\(token)"
        
        guard let url = URL(string: urlStr) else{
            print("Error 1: Error al cargar la URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error == nil,
               (response as! HTTPURLResponse).statusCode == 200,
               let data = data {
                do{
                    let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)
                    DispatchQueue.main.async {
                        self.quizzes = quizzes!
                    }
                }                 
            }else{
                print("Error 2: Fallo en la petición")
            }
        }
        .resume()
    }
    
    func toggleFavourite(quizItem: QuizItem){
        
        guard let index = quizzes.firstIndex(where: {qi in
            qi.id == quizItem.id
        })else{
            print("Error interno 1")
            return
        }
        
        let urlStr = "\(URL_BASE)/users/tokenOwner/favourites/\(quizItem.id)?token=\(token)"
        guard let url = URL(string: urlStr) else{
            print("Error 1: Error al cargar la URL")
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
        req.addValue("XMLHTTPRequest", forHTTPHeaderField: "X-Requested-With")
        
        URLSession.shared.uploadTask(with: req, from: Data()) { _, res, error in
            
            if error == nil,(res as! HTTPURLResponse).statusCode == 200{
                DispatchQueue.main.async {
                    
                    self.quizzes[index].favourite.toggle()
                }
                
            }else{
                print("Favoritos Error 2")
                print((res as! HTTPURLResponse).statusCode)
            }
            
        }
        .resume()
    }
}
