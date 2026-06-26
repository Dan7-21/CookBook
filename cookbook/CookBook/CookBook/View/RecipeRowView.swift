import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(recipe.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Text(recipe.time)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.43))
                
              
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.black.opacity(0.6))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 212/255, green: 212/255, blue: 212/255))
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Удалить", systemImage: "trash")
            }
            
            Button(action: onToggleFavorite) {
                Label(
                    recipe.isFavorite ? "Убрать из избранного" : "В избранное",
                    systemImage: recipe.isFavorite ? "heart.slash" : "heart"
                )
            }
            .tint(recipe.isFavorite ? .gray : .orange)
        }
    }
}
