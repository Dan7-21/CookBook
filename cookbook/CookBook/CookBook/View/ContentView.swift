import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = [
        Recipe(
            title: "Борщ",
            time: "50 мин",
            description: """
            Ингредиенты:
            -пупупу
            """,
            isFavorite: true
        ),
        Recipe(title: "Паста карбонара", time: "30 мин", description: "", isFavorite: false),
        Recipe(title: "Блины", time: "45 мин", description: "", isFavorite: false),
        Recipe(title: "Оливье", time: "10 мин", description: "", isFavorite: true)
    ]
    
    @State private var isShowingAddRecipe = false
    
    var sortedRecipes: [Recipe] {
        recipes.sorted { $0.isFavorite && !$1.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Кулинарная книга")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Spacer()
                    Button(action: {
                        isShowingAddRecipe = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 183/255, green: 55/255, blue: 55/255))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                List {
                    ForEach(sortedRecipes) { recipe in
                        NavigationLink(
                            destination: RecipeDetailView(
                                recipe: Binding(
                                    get: {
                                        recipes.first(where: { $0.id == recipe.id }) ?? recipe
                                    },
                                    set: { updatedRecipe in
                                        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
                                            recipes[index] = updatedRecipe
                                        }
                                    }
                                ),
                                recipes: $recipes
                            )
                        ) {
                            RecipeRowView(
                                recipe: recipe,
                                onDelete: { deleteRecipe(recipe) },
                                onToggleFavorite: { toggleFavorite(recipe) }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparatorTint(.white)
                        .listRowBackground(Color.white)
                    }
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .animation(.easeInOut, value: sortedRecipes.map { $0.id })
            }
        }
        .sheet(isPresented: $isShowingAddRecipe) {
            AddRecipeView(recipes: $recipes, editingRecipe: nil)
        }
    }
    
    private func deleteRecipe(_ recipe: Recipe) {
        withAnimation {
            recipes.removeAll { $0.id == recipe.id }
        }
    }
    
    private func toggleFavorite(_ recipe: Recipe) {
        withAnimation {
            if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                recipes[index].isFavorite.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
