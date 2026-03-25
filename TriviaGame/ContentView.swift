//
//  ContentView.swift
//  TriviaGame
//
//  Created by Remberto Silva on 3/19/26.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfQuestions = 5
    @State private var selectedCategory = 9
    @State private var selectedDifficulty = "easy"
    @State private var selectedType = "multiple"
    @State private var navigateToQuiz = false

    let categories = [
        (id: 9, name: "General Knowledge"),
        (id: 10, name: "Books"),
        (id: 11, name: "Film"),
        (id: 12, name: "Music"),
        (id: 14, name: "Television"),
        (id: 15, name: "Video Games"),
        (id: 17, name: "Science & Nature"),
        (id: 21, name: "Sports"),
        (id: 23, name: "History"),
        (id: 27, name: "Animals"),
    ]

    let difficulties = ["easy", "medium", "hard"]
    let types = ["multiple": "Multiple Choice", "boolean": "True / False"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Number of Questions") {
                    Stepper("\(numberOfQuestions) Questions", value: $numberOfQuestions, in: 5...20)
                }

                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.id) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                }

                Section("Difficulty") {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { difficulty in
                            Text(difficulty.capitalized).tag(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(Array(types.keys), id: \.self) { key in
                            Text(types[key]!).tag(key)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Trivia Game")
            .safeAreaInset(edge: .bottom) {
                Button {
                    navigateToQuiz = true
                } label: {
                    Text("Start Trivia")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToQuiz) {
                QuizView(
                    numberOfQuestions: numberOfQuestions,
                    category: selectedCategory,
                    difficulty: selectedDifficulty,
                    type: selectedType
                )
            }
        }
    }
}
