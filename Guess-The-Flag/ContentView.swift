//
//  ContentView.swift
//  Guess-The-Flag
//
//  Created by jimenez on 2/3/24.
//

import SwiftUI

struct flagImage: View {
    var text: String
    
    var body: some View {
        Image(text)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
    
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingRound = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var userRounds = 0
    @State private var animateButtons = Array(repeating: false, count: 3)
    @State private var animateOpacity = Array(repeating: 1.0, count: 3)
    
    @State private var animateButton = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.heavy)
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            rounds()
                            if number == correctAnswer {
                                withAnimation() {
                                    flagTapped(correctAnswer) //change to number
                                    print(correctAnswer)
                                }
                            } else {
                                withAnimation {
                                    flagTapped(number)
                                }
                            }
                        } label: {
                            flagImage(text: countries[number])
                            
                        }
                        .rotation3DEffect(.degrees(animateButtons[number] ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(animateOpacity[number])
                        .alert(scoreTitle, isPresented: $showingRound) {
                            Button("Restart", action: restart)
                        }
                        
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(Rectangle())
                .cornerRadius(20)
                
                Spacer()
                
                
                Text("\(userRounds) / 8 rounds")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Score: \(userScore)")
                    .titleStyle()
                
                Spacer()
                Spacer()
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your Score is \(userScore)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            self.animateButtons[number].toggle()
//            flipWrongImages(number)
            print(animateButtons)
        } else {
            scoreTitle = "Try Again, That's the flag of \(countries[number])"
            if userScore > 0 {
                userScore -= 1
            }
//            self.animateButtons[number].toggle()
//            flipWrongImages(number)
            print(animateButtons)
            
        }

        if userRounds == 8 {
            scoreTitle = "You got \(userScore) out of 8"
            showingRound = true
        } else {
            showingScore = true
        }
    }


    
//    func flipWrongImages(_ number: Int) {
//        ForEach(0..<3) { item in
//            if number != correctAnswer {
//                self.animateButtons[number].toggle()
//            }
//        }
//    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animateButton = false
        animateButtons = [false, false, false]
        animateOpacity = [1.0, 1.0, 1.0]
    }
    
    func rounds() {
        userRounds += 1
    }
    
    func restart() {
        userRounds = 0
        userScore = 0
        askQuestion()
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
