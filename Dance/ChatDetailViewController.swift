
import UIKit
import MessageUI
import MessageKit

class ChatDetailViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate, MessageInputBarDelegate {
    
    
    func currentSender() -> SenderType {
        return Sender(id: "12345", displayName: "taro")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
}

struct Message: MessageType {
    
    var sender: SenderType
    /// 必須
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    
}
