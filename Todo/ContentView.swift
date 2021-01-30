//
//  ContentView.swift
//  Todo
//
//  Created by Daniel Manrique Figueroa on 8/25/20.
//  Copyright © 2020 MNRQ. All rights reserved.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import Combine

struct ContentView: View {
    
    @State var todoSubscription: AnyCancellable?
    
    @State var authSessionSubscription: AnyCancellable?
    
    @State var signInSessionSubscription: AnyCancellable?
    
     var body: some View {
        Text("Hello, World!")
            .onAppear {
                self.performOnAppear()
        }
    }
    
    func subscribeAuth(){
        self.authSessionSubscription = fetchCurrentAuthSession()
    }
    
    func subscribeSignIn() {
        self.signInSessionSubscription = signIn(username: "danielmnrq", password: "1234567890")
    }
    func subscribeTodos() {
       self.todoSubscription
           = Amplify.DataStore.publisher(for: Todo.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")
               })
    }
    
   func fetchCurrentAuthSession() -> AnyCancellable {
       Amplify.Auth.fetchAuthSession().resultPublisher
        .sink(receiveCompletion: {
               if case let .failure(authError) = $0 {
                   print("Fetch session failed with error \(authError)")
               }
           },
           receiveValue: { session in
               print("Is user signed in - \(session.isSignedIn)")
           })
   }
    
    func signIn(username: String, password: String) -> AnyCancellable {
        Amplify.Auth.signIn(username: username, password: password)
            .resultPublisher
             .sink(receiveCompletion: {
                if case let .failure(authError) = $0 {
                    print("Sign in failed \(authError)")
                }
             },
            receiveValue: { _ in
                print("Sign in succeeded")
             })
    }
    
    
    func performOnAppear() {
        subscribeTodos()
        subscribeAuth()
        subscribeSignIn()
       /*let item = Todo(name: "Build iOS Application",
                       description: "Build an iOS application using Amplify")*/
        /*let item = Todo(name: "Finish quarterly taxes",
        priority: .high,
        description: "Taxes are due for the quarter next week")
        
    
        Amplify.DataStore.save(item) { (result) in
           switch(result) {
           case .success(let savedItem):
               print("Saved item: \(savedItem.name)")
           case .failure(let error):
               print("Could not save item to datastore: \(error)")
           }
        }*/
        
        /*Amplify.DataStore.query(Todo.self, completion: { result in
            switch(result) {
            case .success(let todos):
                for todo in todos {
                    print("==== Todo ====")
                    print("Name: \(todo.name)")
                    if let priority = todo.priority {
                        print("Priority: \(priority)")
                    }
                    if let description = todo.description {
                        print("Description: \(description)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        })*/
        
        /*Amplify.DataStore.query(Todo.self,
                               where: Todo.keys.priority.eq(Priority.high.rawValue),
                               completion: { result in
           switch(result) {
           case .success(let todos):
               for todo in todos {
                   print("==== Todo ====")
                   print("Name: \(todo.name)")
                   if let description = todo.description {
                       print("Description: \(description)")
                   }
                   if let priority = todo.priority {
                       print("Priority: \(priority)")
                   }
               }
           case .failure(let error):
               print("Could not query DataStore: \(error)")
           }
        })*/
        
        //Update
        /*Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq("Finish quarterly taxes"),
                                completion: { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, var updatedTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                updatedTodo.name = "File quarterly taxes"
                Amplify.DataStore.save(updatedTodo,
                                       completion: { result in
                                        switch(result) {
                                        case .success(let savedTodo):
                                            print("Updated item: \(savedTodo.name )")
                                        case .failure(let error):
                                            print("Could not update data in Datastore: \(error)")
                                        }
                })
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        })*/
        
        //Delete
        /*Amplify.DataStore.query(Todo.self,
                                 where: Todo.keys.name.eq("File quarterly taxes"),
                                 completion: { result in
             switch(result) {
             case .success(let todos):
                 guard todos.count == 1, let toDeleteTodo = todos.first else {
                     print("Did not find exactly one todo, bailing")
                     return
                 }
                 Amplify.DataStore.delete(toDeleteTodo,
                                          completion: { result in
                                             switch(result) {
                                             case .success:
                                                 print("Deleted item: \(toDeleteTodo.name)")
                                             case .failure(let error):
                                                 print("Could not update data in Datastore: \(error)")
                                             }
                 })
             case .failure(let error):
                 print("Could not query DataStore: \(error)")
             }
        })*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

