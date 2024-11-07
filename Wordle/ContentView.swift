import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WordleGameViewModel()
    @State private var shakeAnimation = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // Win or Lose Animation
                if viewModel.showWinAnimation {
                    LottieView(animationName: "win", loopMode: .playOnce)
                        .frame(width: 200, height: 200)
                        .transition(.scale)
                        .animation(.easeInOut, value: viewModel.showWinAnimation)
                        .shadow(radius: 10)
                } else if viewModel.showLoseAnimation {
                    LottieView(animationName: "sad_face", loopMode: .playOnce)
                        .frame(width: 100, height: 100)
                        .transition(.scale)
                        .animation(.easeInOut, value: viewModel.showLoseAnimation)
                        .shadow(radius: 10)
                }
                
                // Title with shadows
                Text("Wordle Game")
                    .font(.system(size: 50, weight: .heavy, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                } else {
                    Text("Guess the word:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 30)

                    // Masked word display
                    Text(viewModel.maskedWord)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(viewModel.gameWon ? .green : .white)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(12)
                        .shadow(radius: 5)

                    // Guess text field with shadow
                    TextField("Enter your guess", text: $viewModel.userGuess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disabled(viewModel.gameWon || viewModel.attemptsLeft == 0)
                        .autocapitalization(.none)
                        
                    HStack {
                        // Submit guess button with shadow and animation
                        Button("Submit Guess") {
                            viewModel.submitGuess()
                        }
                        .padding()
                        .background(viewModel.userGuess.isEmpty || viewModel.gameWon || viewModel.attemptsLeft == 0 ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .scaleEffect(viewModel.gameWon ? 1.2 : 1.0)
                        .shadow(color: .black, radius: 10, x: 0, y: 5)
                        .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: viewModel.gameWon)

                        Spacer()

                        // Reveal hint button with opacity change
                        Button("Reveal A Character") {
                            viewModel.requestHint()
                        }
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .opacity(viewModel.hintUsed ? 0.5 : 1.0)
                        .disabled(viewModel.hintUsed)
                        .shadow(radius: 5)
                    }

                    // Attempts left with aesthetic design
                    Text("Attempts left: \(viewModel.attemptsLeft)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Message with smooth transition
                    Text(viewModel.message)
                        .foregroundColor(viewModel.gameWon ? .green : .red)
                        .font(.title2)
                        .bold()
                        .transition(.slide)
                        .animation(.easeInOut, value: viewModel.message)
                        .shadow(radius: 5)

                    // Play Again button with transition effect
                    if viewModel.gameWon || viewModel.attemptsLeft == 0 {
                        Button("Play Again") {
                            viewModel.startNewGame()
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .transition(.opacity.combined(with: .scale))
                        .shadow(radius: 10)
                    }
                }
            }
            .padding()
//            .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .onChange(of: viewModel.message) {
            if $0 == "Incorrect! Try again." {
            }
        }
    }
}



//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var viewModel = WordleGameViewModel()
//    @State private var shakeAnimation = false
//
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
//                           startPoint: .topLeading,
//                           endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//
//            VStack(spacing: 20) {
//                
//                // Win or Lose Animation at the Top
//                if viewModel.showWinAnimation {
//                    LottieView(animationName: "win", loopMode: .playOnce)
//                        .frame(width: 200, height: 200)
//                        .transition(.scale)
//                        .animation(.easeInOut, value: viewModel.showWinAnimation)
//                } else if viewModel.showLoseAnimation {
//                    LottieView(animationName: "sad_face", loopMode: .playOnce)
//                        .frame(width: 100, height: 100)
//                        .transition(.scale)
//                        .animation(.easeInOut, value: viewModel.showLoseAnimation)
//                }
//                
//                Text("Wordle Game")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.white)
//
//                if viewModel.isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    Text("Guess the word:")
//                        .font(.headline)
//                        .foregroundColor(.white)
//
//                    Text(viewModel.maskedWord)
//                        .font(.system(size: 30, design: .monospaced))
//                        .foregroundColor(viewModel.gameWon ? .green : .white)
//                        .padding()
//
//                    TextField("Enter your guess", text: $viewModel.userGuess)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                        .disabled(viewModel.gameWon || viewModel.attemptsLeft == 0)
//                        .autocapitalization(.none)
//                        
//                    HStack {
//                        Button("Submit Guess") {
//                            viewModel.submitGuess()
//                        }
//                        .padding()
//                        .background(viewModel.userGuess.isEmpty || viewModel.gameWon || viewModel.attemptsLeft == 0 ? Color.gray : Color.green)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                        .scaleEffect(viewModel.gameWon ? 1.2 : 1.0)
//                        .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: viewModel.gameWon)
//
//                        Spacer()
//
//                        Button("Reveal A Character") {
//                            viewModel.requestHint()
//                        }
//                        .padding()
//                        .background(Color.yellow)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                        .opacity(viewModel.hintUsed ? 0.5 : 1.0)
//                        .disabled(viewModel.hintUsed)
//                    }
//
//                    Text("Attempts left: \(viewModel.attemptsLeft)")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//
//                    Text(viewModel.message)
//                        .foregroundColor(viewModel.gameWon ? .green : .red)
//                        .font(.headline)
//                        .transition(.slide)
//                        .animation(.easeInOut, value: viewModel.message)
//
//                    if viewModel.gameWon || viewModel.attemptsLeft == 0 {
//                        Button("Play Again") {
//                            viewModel.startNewGame()
//                        }
//                        .padding()
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                        .transition(.opacity.combined(with: .scale))
//                    }
//                }
//            }
//            .padding()
//        }
//        .onChange(of: viewModel.message) {
//            if $0 == "Incorrect! Try again." {
//            }
//        }
//    }
//}
