import Foundation

public struct Song {
    public let name: String
    public let artists: [String]
    public let imageUrl: URL
    public let trackUrl: URL
    
    public init(name: String, artists: [String], imageUrl: URL, trackUrl: URL) {
        self.name = name
        self.artists = artists
        self.imageUrl = imageUrl
        self.trackUrl = trackUrl
    }
}
