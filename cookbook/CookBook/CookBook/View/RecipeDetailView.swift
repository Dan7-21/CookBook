import SwiftUI

struct RecipeDetailView: View {
    @Binding var recipe: Recipe
    @Binding var recipes: [Recipe]
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 12) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("Время приготовления: \(recipe.time)")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        recipe.isFavorite.toggle()
                    }) {
                        HStack {
                            Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                            Text(recipe.isFavorite ? "В избранном" : "Добавить в избранное")
                                .font(.headline)
                        }
                        .foregroundColor(recipe.isFavorite ? .red : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(recipe.isFavorite ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.title2)
                            .foregroundColor(Color(red: 183/255, green: 55/255, blue: 55/255))
                        Text("Рецепт")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    if recipe.description.isEmpty {
                        Text("Описание рецепта отсутствует")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(recipe.description)
                            .font(.body)
                            .lineSpacing(6)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                            )
                    }
                }
                
               
                VStack {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.title3)
                            Text("Удалить рецепт")
                                .font(.headline)
                        }
                        .foregroundColor(.red)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                    .padding(.top, 20)
                }
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Детали рецепта")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing = true
                }) {
                    Text("Изменить")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            AddRecipeView(recipes: $recipes, editingRecipe: recipe)
        }
        
        .alert("Удалить рецепт?", isPresented: $showDeleteAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                deleteRecipe()
            }
        } message: {
            Text("Вы уверены, что хотите удалить рецепт \"\(recipe.title)\"? Это действие нельзя отменить.")
        }
    }
    
    
    private func deleteRecipe() {
        withAnimation {
            recipes.removeAll { $0.id == recipe.id }
        }
        dismiss()
    }
}
