import SwiftUI
import Foundation


struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var recipes: [Recipe]
    
    var editingRecipe: Recipe?
    
    @State private var title: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var description: String = ""
    @State private var isFavorite: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, description
    }
    
    var isEditing: Bool {
        editingRecipe != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Название рецепта") {
                    TextField("Введите название", text: $title)
                        .focused($focusedField, equals: .title)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .description
                        }
                }
                
                Section("Время приготовления") {
                    HStack {
                        Picker("Часы", selection: $hours) {
                            ForEach(0...23, id: \.self) { hour in
                                Text("\(hour) ч").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .clipped()
                        
                        Picker("Минуты", selection: $minutes) {
                            ForEach(0...59, id: \.self) { minute in
                                Text("\(minute) мин").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .clipped()
                    }
                    .frame(height: 150)
                }
                
                Section("Рецепт") {
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Опишите рецепт: ингредиенты, шаги приготовления, советы...")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $description)
                            .focused($focusedField, equals: .description)
                            .frame(minHeight: 200)
                            .padding(4)
                    }
                }
                
                Section {
                    Toggle(isOn: $isFavorite) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Добавить в избранное")
                        }
                    }
                }
                
                Section {
                    Button(action: saveRecipe) {
                        HStack {
                            Spacer()
                            Text(isEditing ? "Сохранить изменения" : "Сохранить рецепт")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                    .listRowBackground(
                        title.isEmpty || description.isEmpty ?
                        Color.gray.opacity(0.3) :
                        Color(red: 183/255, green: 55/255, blue: 55/255)
                    )
                    .foregroundColor(.white)
                }
            }
            .navigationTitle(isEditing ? "Редактирование" : "Новый рецепт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Готово") {
                            focusedField = nil
                        }
                    }
                }
            }
            .onAppear {
                loadEditingRecipe()
            }
        }
    }
    
    private func loadEditingRecipe() {
        guard let recipe = editingRecipe else { return }
        title = recipe.title
        
        let timeComponents = recipe.time.components(separatedBy: " ")
        if timeComponents.count >= 2 {
            if timeComponents.count == 2 {
                if timeComponents[1].contains("мин") {
                    minutes = Int(timeComponents[0]) ?? 0
                } else {
                    hours = Int(timeComponents[0]) ?? 0
                }
            } else if timeComponents.count == 4 {
                hours = Int(timeComponents[0]) ?? 0
                minutes = Int(timeComponents[2]) ?? 0
            }
        }
        
        description = recipe.description
        isFavorite = recipe.isFavorite
    }
    
    private func saveRecipe() {
        let timeString: String
        if hours == 0 && minutes == 0 {
            timeString = "Время не указано"
        } else if hours == 0 {
            timeString = "\(minutes) мин"
        } else if minutes == 0 {
            timeString = "\(hours) ч"
        } else {
            timeString = "\(hours) ч \(minutes) мин"
        }
        
        if let editingRecipe = editingRecipe {
            if let index = recipes.firstIndex(where: { $0.id == editingRecipe.id }) {
                recipes[index].title = title
                recipes[index].time = timeString
                recipes[index].description = description
                recipes[index].isFavorite = isFavorite
            }
        } else {
            let newRecipe = Recipe(
                title: title,
                time: timeString,
                description: description,
                isFavorite: isFavorite
            )
            recipes.append(newRecipe)
        }
        
        dismiss()
    }
}
