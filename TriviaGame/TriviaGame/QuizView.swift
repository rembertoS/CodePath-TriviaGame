//
//  QuizView.swift
//  TriviaGame
//
//  Created by Remberto Silva on 3/19/26.
//

import SwiftUI
import Combine

@MainActor
struct QuizView: View {
    let numberOfQuestions: Int
    let category: Int
    let difficulty: String
    let type: String

    @State private var questions: [TriviaQuestion] = []
    @State private var selectedAnswers: [UUID: String] = [:]
    @State private var isLoading = true
    @State private var showScore = false
    @State private var timeRemaining = 60
    @State private var timerActive = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var score: Int {
        questions.filter { selectedAnswers[$0.id] == $0.correctAnswer }.count
    }

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading questions...")
            } else {
                VStack(spacing: 0) {
                    Text("Time remaining: \(timeRemaining)s")
                        .font(.subheadline)
                        .foregroundStyle(timeRemaining <= 10 ? .red : .primary)
                        .padding(.vertical, 8)

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(questions) { question in
                                QuestionRow(
                                    question: question,
                                    selectedAnswer: selectedAnswers[question.id],
                                    onSelect: { answer in
                                        selectedAnswers[question.id] = answer
                                    }
                                )
                            }
                        }
                        .padding()
                    }

                    Button {
                        timerActive = false
                        showScore = true
                    } label: {
                        Text("Submit")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("Trivia")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchQuestions()
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                showScore = true
            }
        }
        .alert("Quiz Complete!", isPresented: $showScore) {
            Button("OK") { }
        } message: {
            Text("You scored \(score) out of \(questions.count)!")
        }
    }

    @MainActor
    private func fetchQuestions() async {
        let urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(category)&difficulty=\(difficulty)&type=\(type)"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
            questions = decoded.results
            isLoading = false
            timerActive = true
        } catch {
            print("Fetch error: \(error)")
            isLoading = false
        }
    }
}

