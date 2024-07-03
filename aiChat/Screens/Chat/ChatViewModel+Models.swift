import Foundation

extension ChatViewModel {
    enum PopoverMenuAction {
        case history, newChat, settings, upgrade
        
        var title: String {
            switch self {
            case .history:
                return "History"
            case .newChat:
                return "New Conversation"
            case .settings:
                return "Settings"
            case .upgrade:
                return "Upgrade to pro"
            }
        }
        
        var icon: String {
            switch self {
            case .history:
                return "clock.arrow.circlepath"
            case .newChat:
                return "plus.square"
            case .settings:
                return "gear"
            case .upgrade:
                return "arrowshape.up"
            }
        }
    }
    
    enum PlusMenuAction {
        case generate, addFromGallery, addFromBookmarks, camera, photos
        
        var title: String {
            switch self {
            case .generate:
                return "Generate an image"
            case .addFromGallery:
                return "Add from Prompt Gallery"
            case .addFromBookmarks:
                return "Add from Bookmarks"
            case .camera:
                return "Camera"
            case .photos:
                return "Photos"
            }
        }
        
        var icon: String {
            switch self {
            case .generate:
                return "generate"
            case .addFromGallery:
                return "addFromGallery"
            case .addFromBookmarks:
                return "addFromBookmarks"
            case .camera:
                return "camera"
            case .photos:
                return "photos"
            }
        }
    }
    
    enum ContextAction {
        case divider, copy, select, read, share, resend, addToBookmark
        
        var title: String {
            switch self {
            case .divider:
                return ""
            case .copy:
                return "Copy"
            case .select:
                return "Select Text"
            case .read:
                return "Read Aloud"
            case .share:
                return "Share"
            case .resend:
                return "Resend Prompt"
            case .addToBookmark:
                return "Add Bookmark"
            }
        }
        
        var systemImage: String {
            switch self {
            case .divider:
                return ""
            case .copy:
                return "doc.on.doc"
            case .select:
                return "selection.pin.in.out"
            case .read:
                return "speaker.wave.2"
            case .share:
                return "square.and.arrow.up"
            case .resend:
                return "arrow.up.circle"
            case .addToBookmark:
                return "bookmark"
            }
        }
    }
}
