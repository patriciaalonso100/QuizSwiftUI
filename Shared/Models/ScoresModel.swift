//
//  ScoresModel.swift
//  Quiz SwiftUI (iOS)
//
//  Created by Javier García Céspedes on 23/9/21.
//

import Foundation

class ScoresModel: ObservableObject{
    
    @Published private(set) var acertadas: Set<Int> = []
    @Published private(set) var record: Set<Int> = []

    private let defaults = UserDefaults.standard
    
    //Constructor
    init(){
        // ud -> forKey "record"
        //record_array = defaults.array(forKey: "record")
        if let record = UserDefaults.standard.object(forKey: "record") as? [Int]{
            self.record = Set(record)
        }
    }
    
    //Tenemos que hacer el casting entre set y array, los set no se pueden guardar por tanto tenemos que transformarlo en array.
    
    func check(respuesta: String, quiz: QuizItem){
        let r1 = respuesta.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let r2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if r1 == r2, !acertadas.contains(quiz.id){
            acertadas.insert(quiz.id)
            record.insert(quiz.id)
            defaults.set(Array(record), forKey: "record")
            defaults.synchronize()

            
        }
    }
    
    func acertada(_ quiz: QuizItem) -> Bool{
        return record.contains(quiz.id)
    }
    
    func limpiar(){
        acertadas=[]
    }
    
    
    
}
