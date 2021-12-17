//
//  ChatViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 11/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: UIViewController, UIGestureRecognizerDelegate {
//    var currentUser = Sender(senderId: UserDefaults.standard.userID!, displayName: AppData.userDetails?.fullname?.capitalized ?? "")
    var currentUser:Sender { Sender(senderId: UserDefaults.standard.userID!, displayName: AppData.userDetails?.fullname?.capitalized ?? "") }
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.rgb(r: 244, g: 244, b: 244)
        setupViews()
        setupConstraints()
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMockMessages()
        isMessagesControllerBeingDismissed = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        addMenuControllerObservers()
        addObservers()
        setupDelegates()
        setupTargetActions()
        //        messageInputBar.sendButton.isEnabled = true
        //        messageInputBar.sendButton.isUserInteractionEnabled = true
        //        messageInputBar.sendButton.imageView?.isUserInteractionEnabled = true
        //        messageInputBar.sendButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        //        messagesCollectionView.isHidden = true
        //        messageInputBar.isHidden = true
        //        fetchedResultsController = externalConversationsFRC
        //        self.preFetchData(isArchived: false)
        //        self.fetchDataFromAPI(isArchive: false)
        //        segmentedControl.selectedSegmentIndex = 0
        //        updateTableContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate func setupViews() {
        view.addSubview(spinner)
        view.addSubview(backButton)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(messagesCollectionView)
    }
    fileprivate func setupConstraints() {
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        let imageSize:CGFloat = self.view.frame.width / 3.5
        profileImageView.anchor(top: backButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: imageSize, heightConstant: imageSize)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        messagesCollectionView.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Being dismissed")
        
        //        isMessagesControllerBeingDismissed = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        messages.removeAll()
        //        messagesCollectionView.reloadData()
        isMessagesControllerBeingDismissed = false
    }
    override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
        }
        adjustScrollViewTopInset()
    }
    
    // MARK: - Initializers
    
    deinit {
        removeKeyboardObservers()
        removeMenuControllerObservers()
        removeObservers()
        clearMemoryCache()
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    func setupTargetActions() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    let profileImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "football")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Driver Name"
        label.font =  UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    var messages:[Message] = []
    var messageInputBar = InputBarAccessoryView()
    var messagesCollectionView = MessagesCollectionView()
    
    func configureMessageCollectionView() {
        messagesCollectionView.isHidden = false
        messagesCollectionView.backgroundColor = UIColor.white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //        messagesCollectionView.messageCellDelegate = self
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarSize(.zero)
//        layout?.setMessageIncomingAvatarSize(.zero)
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 18))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)))
        layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 5, left: 50, bottom: 0, right: 0)))
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    func configureMessageInputBar() {
        messageInputBar.isHidden = false
        messageInputBar.delegate = self
        //        messageInputBar.inputTextView.tintColor = .telaWhite
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        
        messageInputBar.sendButton.title = nil
        let inset:CGFloat = -10
        messageInputBar.sendButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        //        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = UIColor.clear
        messageInputBar.contentView.backgroundColor = UIColor.clear
        messageInputBar.inputTextView.backgroundColor = UIColor.rgb(r: 234, g: 234, b: 234)
        messageInputBar.inputTextView.keyboardAppearance = UIKeyboardAppearance.default
        messageInputBar.inputTextView.layer.borderWidth = 0
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 36)
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 40, animated: false)
        messageInputBar.inputTextView.layer.shadowColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.shadowOpacity = 0.3
        messageInputBar.inputTextView.layer.shadowRadius = 2
        messageInputBar.inputTextView.layer.shadowOffset = CGSize.zero
        messageInputBar.inputTextView.layer.masksToBounds = false
    }
    // MARK: - Helpers
    func insert(_ message:Message) {
        self.messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    func insertMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            //            self?.messagesCollectionView.scrollToBottom(animated: true)
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
        
    }
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    
    
    
    func loadMockMessages() {
        messages = []
        let mockUser = Sender(senderId: "99", displayName: "Arya Stark")
        let message = Message(text: "Valar Morghulis!", sender: currentUser, messageId: UUID().uuidString, date: Date())
        //        self.insert(message)
        self.insertMessage(message)
        
        let replyMessage = Message(text: "Valar Dohaeris!", sender: mockUser, messageId: UUID().uuidString, date: Date())
        //            self.insert(replyMessage)
        self.insertMessage(replyMessage)
        
        
    }
    
    
    fileprivate func startOverlaySpinner() {
        OverlaySpinner.shared.spinner(mark: .Start)
    }
    fileprivate func stopOverlaySpinner() {
        OverlaySpinner.shared.spinner(mark: .Stop)
    }
    lazy var spinner:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.whiteLarge
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        return indicator
    }()
    fileprivate func startSpinner() {
        self.spinner.startAnimating()
    }
    fileprivate func stopSpinner() {
        self.spinner.stopAnimating()
    }
    fileprivate func startNetworkSpinner() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    fileprivate func stopNetworkSpinner() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    var scrollsToBottomOnKeyboardBeginsEditing: Bool = false
    var maintainPositionOnKeyboardFrameChanged: Bool = false
    
    var additionalBottomInset: CGFloat = 0 {
        didSet {
            let delta = additionalBottomInset - oldValue
            messageCollectionViewBottomInset += delta
        }
    }
    private var isFirstLayout: Bool = true
    internal var isMessagesControllerBeingDismissed: Bool = false
    
    internal var selectedIndexPathForMenu: IndexPath?
    
    internal var messageCollectionViewBottomInset: CGFloat = 0 {
        didSet {
            messagesCollectionView.contentInset.bottom = messageCollectionViewBottomInset
            messagesCollectionView.scrollIndicatorInsets.bottom = messageCollectionViewBottomInset
        }
    }
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        extendedLayoutIncludesOpaqueBars = true
        UIScrollView().contentInsetAdjustmentBehavior = .never
        
        messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.alwaysBounceVertical = true
    }
    // MARK: - Helpers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(clearMemoryCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc private func clearMemoryCache() {
        //        MessageStyle.bubbleImageCache.removeAllObjects()
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].user == messages[indexPath.section - 1].user
        
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].user == messages[indexPath.section + 1].user
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    var isTypingIndicatorHidden: Bool {
        return messagesCollectionView.isTypingIndicatorHidden
    }
//    var messagesCollectionViewFlowLayout: MessagesCollectionViewFlowLayout {
//        guard let layout = collectionViewLayout as? MessagesCollectionViewFlowLayout else {
//            fatalError(MessageKitError.layoutUsedOnForeignType)
//        }
//        return layout
//    }
//    func setTypingIndicatorViewHidden(_ isHidden: Bool) {
//        messagesCollectionViewFlowLayout.setTypingIndicatorViewHidden(isHidden)
//    }
    func setTypingIndicatorViewHidden(_ isHidden: Bool, animated: Bool, whilePerforming updates: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {

        guard isTypingIndicatorHidden != isHidden else {
            completion?(false)
            return
        }

        let section = messagesCollectionView.numberOfSections
//        messagesCollectionView.setTypingIndicatorViewHidden(isHidden)

        if animated {
            messagesCollectionView.performBatchUpdates({ [weak self] in
                self?.performUpdatesForTypingIndicatorVisability(at: section)
                updates?()
                }, completion: completion)
        } else {
            performUpdatesForTypingIndicatorVisability(at: section)
            updates?()
            completion?(true)
        }
    }

    /// Performs a delete or insert on the `MessagesCollectionView` on the provided section
    ///
    /// - Parameter section: The index to modify
    func performUpdatesForTypingIndicatorVisability(at section: Int) {
        if isTypingIndicatorHidden {
            messagesCollectionView.deleteSections([section - 1])
        } else {
            messagesCollectionView.insertSections([section])
        }
    }

    /// A method that by default checks if the section is the last in the
    /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
    /// is FALSE
    ///
    /// - Parameter section
    /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
    func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
        return !messagesCollectionView.isTypingIndicatorHidden && section == self.numberOfSections(in: messagesCollectionView) - 1
    }
    
}

extension UIViewController {
    
    func updateTitleView(title: String, subtitle: String?, baseColor: UIColor = .white) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = baseColor
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = baseColor.withAlphaComponent(0.95)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
    }
    
}

extension ChatViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        let sender = Sender(senderId: UserDefaults.standard.userID!, displayName: AppData.userDetails?.fullname ?? "")
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages.sort(by: { $0.sentDate < $1.sentDate })
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func isEarliest(_ message:Message) -> Bool {
        let filteredMessages = self.messages.filter{( Date.isDateSame(date1: message.sentDate, date2: $0.sentDate) )}
        return message == filteredMessages.min() ? true : false
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isEarliest(message as! Message) {
            let date = Date.getStringFromDate(date: message.sentDate, dateFormat: CustomDateFormat.chatHeaderDate)
            return NSAttributedString(
                string: date,
                attributes: [
                    .font: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)!,
                    .foregroundColor: UIColor.lightGray
                ]
            )
        }
        return nil
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let time = Date.getStringFromDate(date: message.sentDate, dateFormat: CustomDateFormat.hmma)
        return NSAttributedString(
            string: time,
            attributes: [
                .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 10.0)!,
                .foregroundColor: UIColor.darkGray
            ]
        )
    }
}
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .red
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
            switch detector {
            case .hashtag, .mention:
                if isFromCurrentSender(message: message) {
                    return [.foregroundColor: UIColor.white]
                } else {
                    return [.foregroundColor: UIColor.lightGray]
                }
            default: return MessageLabel.defaultAttributes
            }
        }

        func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
            return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
        }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
            
            var corners: UIRectCorner = []
            
            if isFromCurrentSender(message: message) {
                corners.formUnion(.topLeft)
                corners.formUnion(.bottomLeft)
                corners.formUnion(.topRight)
//                if !isPreviousMessageSameSender(at: indexPath) {
//                    corners.formUnion(.topRight)
//                }
                if !isNextMessageSameSender(at: indexPath) {
                    corners.formUnion(.bottomRight)
                }
            } else {
                corners.formUnion(.topRight)
                corners.formUnion(.bottomRight)
                if !isPreviousMessageSameSender(at: indexPath) {
                    corners.formUnion(.topLeft)
                }
                if !isNextMessageSameSender(at: indexPath) {
                    corners.formUnion(.bottomLeft)
                }
            }
            return .custom { view in
                let radius: CGFloat = 16
                let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                view.layer.mask = mask
            }
        }
        
        func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            let avatar = Avatar(image: #imageLiteral(resourceName: "football"), initials: "AR")
            avatarView.set(avatar: avatar)
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.layer.borderWidth = 0
        }
        
//        func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//            // Cells are reused, so only add a button here once. For real use you would need to
//            // ensure any subviews are removed if not needed
//            accessoryView.subviews.forEach { $0.removeFromSuperview() }
//            accessoryView.backgroundColor = .clear
//
//            let shouldShow = Int.random(in: 0...10) == 0
//            guard shouldShow else { return }
//
//            let button = UIButton(type: .infoLight)
//            button.tintColor = .primaryColor
//            accessoryView.addSubview(button)
//            button.frame = accessoryView.bounds
//            button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
//            accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
//            accessoryView.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)
//        }
    
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//    }
    //    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    //        return CGSize.zero
    //    }
    
    
}
extension ChatViewController: MessagesLayoutDelegate {
    
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize.zero
    }
//    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return isEarliest(message as! Message) ? 30.0 : 0
//    }
//
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 0
//    }
//
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 20
//    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + 20) : 0
        }
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath)) ? 16 : 0
    }

    
}

extension ChatViewController : MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        
    }
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                DispatchQueue.main.async {
                    print("Message Sent => \(str)")
                    self.insertMessage(Message(text: str, sender: self.currentUser, messageId: UUID().uuidString, date: Date()))
//                    self.handleSendingMessageSequence(message: str, type: .SMS)
                }
            } else if let _ = component as? UIImage {
//                self.handleSendingMessageSequence(message: , type: .MMS)
            }
        }
    }
    
    /*
     fileprivate func handleSendingMessageSequence(message:String, type:ChatMessageType) {
     self.startNetworkSpinner()
     FirebaseAuthService.shared.getCurrentToken { (token, error) in
     if let err = error {
     print("\n***Error***\n")
     print(err)
     DispatchQueue.main.async {
     self.stopNetworkSpinner()
     self.messageInputBar.sendButton.isEnabled = true
     }
     } else if let token = token {
     let id = self.internalConversation.internalConversationId
     print("Internal Conversation ID => \(id)")
     guard id != 0 else {
     self.stopNetworkSpinner()
     print("Error: Internal Convo ID => 0")
     self.messageInputBar.sendButton.isEnabled = true
     return
     }
     DispatchQueue.main.async {
     self.sendMessage(token: token, conversationId: String(id), message: message, type: type)
     }
     
     }
     }
     }
     
     
     private func sendMessage(token:String, conversationId:String, message:String, type:ChatMessageType) {
     ExternalConversationsAPI.shared.sendMessage(token: token, conversationId: conversationId, message: message, type: type, isDirectMessage: true) { (responseStatus, data, serviceError, error) in
     if let err = error {
     DispatchQueue.main.async {
     self.stopNetworkSpinner()
     UIAlertController.dismissModalSpinner(controller: self)
     print("***Error Sending Message****\n\(err.localizedDescription)")
     self.showAlert(title: "Error", message: err.localizedDescription)
     self.messageInputBar.sendButton.isEnabled = true
     }
     } else if let serviceErr = serviceError {
     DispatchQueue.main.async {
     self.stopNetworkSpinner()
     UIAlertController.dismissModalSpinner(controller: self)
     print("***Error Sending Message****\n\(serviceErr.localizedDescription)")
     self.showAlert(title: "Error", message: serviceErr.localizedDescription)
     self.messageInputBar.sendButton.isEnabled = true
     }
     } else if let status = responseStatus {
     guard status == .Created else {
     DispatchQueue.main.async {
     self.stopNetworkSpinner()
     UIAlertController.dismissModalSpinner(controller: self)
     print("***Error Sending Message****\nInvalid Response: \(status)")
     self.showAlert(title: "\(status)", message: "Unable to send Message. Please try again")
     self.messageInputBar.sendButton.isEnabled = true
     }
     return
     }
     self.stopNetworkSpinner()
     }
     }
     }
     */
}



struct Sender: SenderType, Equatable {
    let senderId: String
    let displayName: String
    init(senderId:String, displayName:String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}
struct Message: MessageType {
    
    let messageId: String
    let sentDate: Date
    var sender: SenderType {
        return user
    }
    let user: Sender
    var kind: MessageKind
    var text:String? = nil
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        //        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.user = sender
    }
    
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
        self.text = text
    }
    
    //    var messageId: String {
    //        return id ?? UUID().uuidString
    //    }
    
    //    var image: UIImage? = nil
    //    var downloadURL: URL? = nil
    //
    //    init(user: User, content: String) {
    //        sender = Sender(id: user.uid, displayName: AppSettings.displayName)
    //        self.content = content
    //        sentDate = Date()
    //        id = nil
    //    }
    //
    //    init(user: User, image: UIImage) {
    //        sender = Sender(id: user.uid, displayName: AppSettings.displayName)
    //        self.image = image
    //        content = ""
    //        sentDate = Date()
    //        id = nil
    //    }
    
}
extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate == rhs.sentDate
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

