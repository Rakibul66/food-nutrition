import SwiftUI

struct FoodResultSheet: View {
    let food: Food
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            HStack {
                Text("Nutrition Lookup")
                    .font(.title.bold())

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            Divider().padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(food.description).font(.headline)
                    Text("Brand: \(food.brandName)").foregroundColor(.secondary)
                    Text("Category: \(food.foodCategory)").foregroundColor(.secondary)
                    if !food.ingredients.isEmpty {
                        Text("Ingredients: \(food.ingredients)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }

                    Divider().padding(.vertical)

                    Text("Nutrients")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                        ForEach(food.foodNutrients, id: \.nutrientName) { nutrient in
                            NutrientCard(nutrient: nutrient)
                        }
                    }
                }
                .padding()
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .shadow(radius: 8)
        .padding()
    }
}



struct NutrientCard: View {
    let nutrient: Nutrient

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                Text(icon(for: nutrient.nutrientName)) // 🍎 Icon
                    .font(.title3)
                Text(nutrient.nutrientName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }

            Text("\(nutrient.value, specifier: "%.1f") \(nutrient.unitName.uppercased())")
                .font(.footnote)
                .foregroundColor(.secondary)

            // 🎯 Circular Progress for Macros
            if isMacro(nutrient.nutrientName) {
                CircleProgressRing(progress: min(nutrient.value / 100, 1.0))
                    .frame(width: 50, height: 50)
            } else {
                // Normal Linear Progress for others
                ProgressView(value: min(nutrient.value, 100), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground)) // 🌑 Light/Dark auto
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    // 🔥 Choose an emoji based on nutrient type
    private func icon(for name: String) -> String {
        switch name.lowercased() {
        case "calories", "energy":
            return "🔥"
        case "protein":
            return "🧪"
        case "carbohydrate", "carbohydrates":
            return "🍞"
        case "fat", "total fat":
            return "🥑"
        case "fiber":
            return "🌾"
        case "sugars":
            return "🍬"
        case "sodium":
            return "🧂"
        default:
            return "🍎"
        }
    }

    // 🏋️ Identify if a nutrient is a macro
    private func isMacro(_ name: String) -> Bool {
        let macros = ["calories", "energy", "protein", "fat", "total fat", "carbohydrate", "carbohydrates"]
        return macros.contains(name.lowercased())
    }
}



struct CircleProgressRing: View {
    let progress: Double // 0.0 to 1.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 6)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)

            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}
