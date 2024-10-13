//
//  FoodDetailView.swift
//  foodnutrition
//
//  Created by Roxy  on 3/10/24.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food

    var body: some View {
        VStack(alignment: .leading) {
            Text(food.description)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()

            Text("Brand: \(food.brandName)")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Text("Ingredients: \(food.ingredients)")
                .padding(.horizontal)

            Text("Category: \(food.foodCategory)")
                .padding(.horizontal)

            Text("Nutrients")
                .font(.title2)
                .padding(.top)

            ForEach(food.foodNutrients, id: \.nutrientName) { nutrient in
                HStack {
                    Text(nutrient.nutrientName)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(nutrient.value, specifier: "%.1f") \(nutrient.unitName)")
                        .foregroundColor(.black)
                }
                .padding()
            }
        }
        .padding()
        .background(
            VisualEffectBlur(blurStyle: .systemMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
        ) // Glassmorphism effect
    }
}

// A view to create the glassmorphism effect
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
