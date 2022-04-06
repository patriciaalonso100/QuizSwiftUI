//
//  ContentView.swift
//  Shared
//
//  Created by Javier García Céspedes on 21/9/21.
//

import SwiftUI

struct QuizzesListView: View {
    
    @EnvironmentObject var quizzesModel: QuizzesModel //asigna el enviroment a este valor. Usamos esta clase en varios sitios
    @EnvironmentObject var scoresModel: ScoresModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass


    @State var verTodo: Bool = true
    
    var body: some View { //body = donde se contruye la interfaz usuario. Con este código mostramos la lista de quizzes
        NavigationView { //vista de navegación de la app. Es clave. Es donde se representarán todos los quizzes
            List{
                Toggle("Ver Todo", isOn: $verTodo .animation())
                ForEach(quizzesModel.quizzes.indices, id: \.self){ index in //recorremos todos los quizzes y los mostramos por pantalla
                    if verTodo || !scoresModel.acertada(quizzesModel.quizzes[index]){
                        NavigationLink { //enlace para acceder a otra pantalla. Me muestra un link para acceder a la vista play.
                            QuizPlayView(quizItemIndex: index) //Con el $ pasamos no pasamos una copia, si no el original
                        } label: {
                            QuizRowView(quizItem: quizzesModel.quizzes[index])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Quizz con SwiftUI. Práctica 2"))
            .navigationBarItems(leading: Text("Record:\(scoresModel.record.count)").font(.callout),
                                trailing: Button(action: {
                quizzesModel.download()
                scoresModel.limpiar()}, label: {Text("Reload")}))
            /*
            .onAppear(perform: {
                quizzesModel.download()
            })
             */
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizzesListView()
//    }
//}
