import Foundation

struct WordResponse: Codable {
    let word: String
}

class WordService {
    // List of common English words
    private let words = [
        "apple", "beach", "chair", "dance", "eagle", "flask", "grape", "house",
        "image", "juice", "knack", "lemon", "mouse", "noble", "ocean", "piano",
        "queen", "river", "snake", "table", "uncle", "voice", "water", "zebra",
        "bread", "clock", "dream", "earth", "flame", "green", "heart", "ivory",
        "jolly", "knife", "light", "music", "night", "olive", "peace", "quiet",
        "radio", "smile", "tiger", "urban", "video", "wheel", "youth", "cloud",
        "phone", "storm", "books", "faith", "happy", "magic", "paper", "world"
    ]
    
    func getRandomWord() -> String {
            return words.randomElement() ?? "apple"
        }
   
}
