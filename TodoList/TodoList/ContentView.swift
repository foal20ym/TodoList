//
//  ContentView.swift
//  TodoList
//
//  Created by Alexander Forsanker on 11/14/22.
//

import SwiftUI

struct TaskObject: Codable & Hashable {
    let title: String;
    let priority: String;
    var isDone = false
}


struct ContentView: View {
    @AppStorage("tasks")
    private var settingsData: Data = Data()
    
    @State private var taskInputText = ""
    @State private var priorityInputText = ""
    @State var priorityLevelArray:[TaskObject] = [];
    @State private var todoList: [TaskObject] =
    [TaskObject(title: "Clean bedroom", priority: "High"),
     TaskObject(title: "Cook food", priority: "Normal"),
     TaskObject(title: "Write project report", priority: "Low"),
     TaskObject(title: "Visit grandma", priority: "High")]
    @State private var isDone = false
    
    var body: some View {
        NavigationStack {
            
            Menu("Select Priority:") {
                Button("High") {
                    priorityLevelArray = showHighPriority(todoList: todoList)
                }
                Button("Normal") {
                    priorityLevelArray = showNormalPriority(todoList: todoList)
                }
                Button("Low") {
                    priorityLevelArray = showLowPriority(todoList: todoList)
                }
                Button("Show all") {
                    priorityLevelArray = showAll(todoList: todoList)
                }
            }
            
            Menu("Order by:"){
            Button("Priority (Ascending)"){
                priorityLevelArray = orderByAscending(todoList: todoList)
            }
            Button("Priority (Descending)"){
                priorityLevelArray = orderByDescending(todoList: todoList)
            }

        }
            
            List {
                ForEach(priorityLevelArray.isEmpty ? showAll(todoList: todoList) : priorityLevelArray, id: \.self) { object in
                    HStack {
                        Image(systemName: object.isDone ? "checkmark.square" : "square")
                            .onTapGesture {
                                if let index =
                                    priorityLevelArray.firstIndex(of: object) {
                                    priorityLevelArray[index].isDone.toggle()
                                }
                                if let index =
                                    todoList.firstIndex(of: object) {
                                    todoList[index].isDone.toggle()
                                }
                            }
                            .foregroundColor(object.isDone ? .green : .black)
                        Text(object.title)
                            .foregroundColor(object.isDone ? .green : .black)
                        Spacer()
                        Text("Priority:")
                        Text(object.priority)
                            .foregroundColor(object.priority == "High" ? .red : object.priority == "Normal" ? .yellow : .green)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        todoList.remove(at: index)
                        priorityLevelArray = todoList
                    }
                }
                HStack {
                    TextField("Enter your task:", text: $taskInputText)
                    Menu {
                        Button("High") {
                            priorityInputText = "High"
                        }
                        Button("Normal") {
                            priorityInputText = "Normal"
                        }
                        Button("Low") {
                            priorityInputText = "Low"
                        }
                    } label: {
                    Label: do {
                        Text("Priority")
                        Image(systemName: "arrow.up.arrow.down")
                        TextField("", text: $priorityInputText)
                            .foregroundColor(priorityInputText == "High" ? .red : priorityInputText == "Normal" ? .yellow : .green)
                    }
                    }
                }
                .onSubmit {
                    if priorityInputText == "" {
                        priorityInputText = "Low"
                    }
                    todoList.append(TaskObject(title: taskInputText, priority: priorityInputText))
                    priorityLevelArray = todoList
                    taskInputText = ""
                    priorityInputText = ""
                }
                
                Spacer()
                
                Button("Save task list") {
                    
                    let settings = todoList
                    
                    guard let settingsData = try?
                            JSONEncoder().encode(settings) else {
                        return
                    }
                    self.settingsData = settingsData
                }
                
                Button("Load from App Storage") {
                    
                    guard let settings = try?
                            JSONDecoder().decode([TaskObject].self, from: settingsData) else {
                        return
                    }
                    todoList = settings
                }
            }
            .navigationTitle("Task list")
        }
    }
    
    func showHighPriority(todoList: [TaskObject]) -> [TaskObject]{
        var highPriorityArray:[TaskObject] = []
        
        for object in todoList {
            if(object.priority == "High") {
                highPriorityArray.append(object)
            }
        }
        return highPriorityArray;
    }
    func showNormalPriority(todoList: [TaskObject]) -> [TaskObject]{
        var normalPriorityArray:[TaskObject] = []
        
        for object in todoList {
            if(object.priority == "Normal") {
                normalPriorityArray.append(object)
            }
        }
        return normalPriorityArray;
        
    }
    func showLowPriority(todoList: [TaskObject]) -> [TaskObject]{
        var lowPriorityArray:[TaskObject] = []
        
        for object in todoList {
            if(object.priority == "Low") {
                lowPriorityArray.append(object)
            }
        }
        return lowPriorityArray;
    }
    func showAll(todoList: [TaskObject]) -> [TaskObject]{
        var showAllArray:[TaskObject] = []
        
        for object in todoList {
            showAllArray.append(object)
        }
        return showAllArray;
    }
    func orderByAscending(todoList: [TaskObject]) -> [TaskObject]{
        var result:[TaskObject] = []
        var orderedArray:[TaskObject] = []
        var orderedArray2:[TaskObject] = []
        var orderedArray3:[TaskObject] = []
        
        for object in todoList {
            if(object.priority == "High"){
                orderedArray.append(object)
            }
            else if(object.priority == "Normal"){
                orderedArray2.append(object)
            }
            else if(object.priority == "Low"){
                orderedArray3.append(object)
            }
        }
        result = orderedArray3 + orderedArray2 + orderedArray
        
        return result;
    }
    func orderByDescending(todoList: [TaskObject]) -> [TaskObject]{
        var result:[TaskObject] = []
        var orderedArray:[TaskObject] = []
        var orderedArray2:[TaskObject] = []
        var orderedArray3:[TaskObject] = []
        
        for object in todoList {
            if(object.priority == "High"){
                orderedArray.append(object)
            }
            else if(object.priority == "Normal"){
                orderedArray2.append(object)
            }
            else if(object.priority == "Low"){
                orderedArray3.append(object)
            }
        }
        result = orderedArray + orderedArray2 + orderedArray3
        
        return result;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
