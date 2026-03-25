//
//  QuestionRow.swift
//  TriviaGame
//
//  Created by Remberto Silva on 3/19/26.
//

import SwiftUI

struct QuestionRow: View {
    let question: TriviaQuestion
    let selectedAnswer: String?
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.question.htmlDecoded)
                .font(.body)
                .bold()

            ForEach(question.allAnswers, id: \.self) { answer in
                Button {
                    onSelect(answer)
                } label: {
                    Text(answer.htmlDecoded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(selectedAnswer == answer ? Color.green.opacity(0.3) : Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
