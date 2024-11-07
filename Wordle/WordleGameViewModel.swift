import SwiftUI
import Combine

class WordleGameViewModel: ObservableObject {
    @Published var wordToGuess: String = ""
    @Published var maskedWord: String = ""
    @Published var userGuess: String = ""
    @Published var attemptsLeft: Int = 5
    @Published var message: String = ""
    @Published var gameWon: Bool = false
    @Published var isLoading: Bool = false
    @Published var hintUsed: Bool = false

    @Published var showWinAnimation: Bool = false
    @Published var showLoseAnimation: Bool = false
    
    private let wordService = WordService()
    private var maskedWordArray: [Character] = []

    init() {
        startNewGame()
    }

    func startNewGame() {
        // Resetting values
        attemptsLeft = 5
        gameWon = false
        message = ""
        userGuess = ""
        isLoading = true
        hintUsed = false
        showWinAnimation = false
        showLoseAnimation = false

        // Random word and masking
        wordToGuess = wordService.getRandomWord()
        maskedWordArray = maskPartialWord(wordToGuess)
        maskedWord = maskedWordArray.map { String($0) }.joined(separator: " ")
        isLoading = false
    }

//    func startNewGame() {
//        attemptsLeft = 5
//        gameWon = false
//        message = ""
//        userGuess = ""
//        isLoading = true
//        hintUsed = false
//
//        // Get a random word from the local word list
//        wordToGuess = wordService.getRandomWord()
//        maskedWordArray = maskPartialWord(wordToGuess)
//        maskedWord = maskedWordArray.map { String($0) }.joined(separator: " ")
//        isLoading = false
//    }

    private func maskPartialWord(_ word: String) -> [Character] {
        let wordArray = Array(word.lowercased())
        var maskedWordArray = Array(repeating: Character("_"), count: word.count)

        // Always reveal exactly two random characters
        var availableIndices = Array(0..<word.count)
        availableIndices.shuffle() // Randomly shuffle the indices

        // Take the first two indices from the shuffled array
        let revealIndices = Array(availableIndices.prefix(2))

        // Reveal exactly two characters
        for index in revealIndices {
            maskedWordArray[index] = wordArray[index]
        }

        return maskedWordArray
    }

    func requestHint() {
        guard attemptsLeft > 0 && !hintUsed else {
            message = "No more attempts or hints left."
            return
        }

        attemptsLeft -= 1
        hintUsed = true
        revealRandomLetter()
    }

    private func revealRandomLetter() {
        var indices = Array(0..<wordToGuess.count)
        indices.shuffle()

        for index in indices {
            if maskedWordArray[index] == "_" {
                maskedWordArray[index] = wordToGuess[wordToGuess.index(wordToGuess.startIndex, offsetBy: index)]
                maskedWord = maskedWordArray.map { String($0) }.joined(separator: " ")
                message = "One letter has been revealed."
                break
            }
        }
    }
    
    func submitGuess() {
        guard !gameWon else { return }
        
        if userGuess.count != wordToGuess.count {
            message = "Guess must be \(wordToGuess.count) letters."
            return
        }
        
        // Check each character in userGuess
        var hasCorrectLetters = false
        for (index, char) in userGuess.lowercased().enumerated() {
            let correctChar = wordToGuess[wordToGuess.index(wordToGuess.startIndex, offsetBy: index)]
            
            // If the character matches and is in the correct position, reveal it
            if char == correctChar {
                maskedWordArray[index] = correctChar
                hasCorrectLetters = true
            }
        }
        
        // Update maskedWord with the newly revealed letters
        maskedWord = maskedWordArray.map { String($0) }.joined(separator: " ")
        
        // Check if the user has fully guessed the word
        if maskedWord.replacingOccurrences(of: " ", with: "") == wordToGuess {
            gameWon = true
            message = "Congratulations!"
            withAnimation {
                showWinAnimation = true
            }
        } else {
            attemptsLeft -= 1
            if attemptsLeft == 0 {
                message = "Game Over! The word was '\(wordToGuess)'."
                withAnimation {
                    showLoseAnimation = true
                }
            } else if hasCorrectLetters {
                message = "Some letters are correct! Keep going."
            } else {
                message = "Incorrect! Try again."
            }
        }
        
        userGuess = ""
    }

    
//    func submitGuess() {
//        guard !gameWon else { return }
//        
//        if userGuess.lowercased() == wordToGuess {
//            gameWon = true
//            message = "Congratulations! You guessed the word!"
//            withAnimation {
//                showWinAnimation = true
//            }
//        } else {
//            attemptsLeft -= 1
//            if attemptsLeft == 0 {
//                message = "Game Over! The word was '\(wordToGuess)'."
//                withAnimation {
//                    showLoseAnimation = true
//                }
//            } else {
//                message = "Incorrect! Try again."
//            }
//        }
//        userGuess = ""
//    }


//    func submitGuess() {
//        guard !gameWon else { return }
//        if userGuess.lowercased() == wordToGuess {
//            gameWon = true
//            message = "Congratulations! You guessed the word!"
//        } else {
//            attemptsLeft -= 1
//            if attemptsLeft == 0 {
//                message = "Game Over! The word was '\(wordToGuess)'."
//            } else {
//                message = "Incorrect! Try again."
//            }
//        }
//        userGuess = ""
//    }
}
