import Foundation

struct AsyncTypingSequence: AsyncSequence {
    typealias AsyncIterator = Iterator
    typealias Element = Substring
    
    let sourceString: String
    let chunkSize: Int
    let popDelay: UInt64
    
    func makeAsyncIterator() -> AsyncIterator {
        Iterator(string: sourceString,
                 chunkSize: chunkSize,
                 popDelay: popDelay)
    }
    
    public struct Iterator: AsyncIteratorProtocol {
        private let string: String
        private let chunkSize: Int
        private let popDelay: UInt64
        private var currentIndex: String.Index
        
        init(string: String, chunkSize: Int, popDelay: UInt64) {
            self.string = string
            self.chunkSize = chunkSize
            self.popDelay = popDelay
            self.currentIndex = string.startIndex
        }
        
        public mutating func next() async -> Substring? {
            try? await Task.sleep(nanoseconds: popDelay)
            
            guard currentIndex < string.endIndex else {
                return nil
            }
            
            let endIndex = string.index(currentIndex, offsetBy: chunkSize, limitedBy: string.endIndex) ?? string.endIndex
            let chunk = string[currentIndex..<endIndex]
            currentIndex = endIndex
            
            return chunk
        }
    }
}
