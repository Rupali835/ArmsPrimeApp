//
//  SelectionView.swift
//  Producer
//
//  Created by Pankaj Bawane on 20/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

typealias SelectionViewCompletionHandler = (([IndexPath]?) -> ())

class SelectionView: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    // Public properties to configure SelectionView.
    fileprivate var unSelectedCheckbox: UIImage {
        return properties.unSelectedCheckbox
    }
    fileprivate var selectedCheckbox: UIImage {
        return properties.selectedCheckbox
    }
    fileprivate var optionButtonImage: UIImage? {
        return properties.optionButtonImage
    }
    fileprivate var rowHeight: CGFloat {
        return properties.rowHeight
    }
    fileprivate var contentViewWidth: CGFloat {
        return properties.contentViewWidth
    }
    fileprivate var backgroundOpacity: CGFloat {
        return properties.backgroundOpacity
    }
    fileprivate var animated: Bool = false
    fileprivate var backgroundColor: UIColor {
        return properties.backgroundColor
    }
    fileprivate var textColor: UIColor {
        return properties.textColor
    }
    fileprivate var font: UIFont {
        return properties.font
    }
    fileprivate var multipleSelection: Bool {
        return properties.multipleSelection
    }
    fileprivate var doneButtonColor: UIColor {
        return properties.doneButtonColor
    }
    fileprivate var doneFont: UIFont {
        return properties.doneFont
    }
    fileprivate var offset: CGPoint {
        return properties.offset
    }
    
    // Private.
    fileprivate var selectionType: SelectionType?
    fileprivate var selectionHandler: SelectionViewCompletionHandler?
    fileprivate var selectedIndices: [IndexPath] = [] {
        didSet {
            if selectionType == .filter, doneButton != nil {
                if selectedIndices.count > 0 {
                    doneButton.isEnabled = true
                    doneButton.backgroundColor = doneButtonColor
                } else {
                    doneButton.isEnabled = false
                    doneButton.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    fileprivate var selectedTitles: [String] = []
    fileprivate var tableView: UITableView!
    fileprivate var anchorUIView: UIView!
    fileprivate var containerView: UIView!
    fileprivate var optionButton: UIButton!
    fileprivate var doneButton: UIButton!
    fileprivate var selectionDataSource: [SelectionDataSource] = []
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var containerShapeLayer = CAShapeLayer()
    fileprivate var doneFooterHeight: CGFloat = 40.0
    fileprivate var properties = SelectionViewProperties()
    fileprivate var preSelectedIndices: [IndexPath]? {
        didSet {
            if let indices = preSelectedIndices {
                selectedIndices.append(contentsOf: indices)
            }
        }
    }
    
    // MARK: - Initialize.
    required init(anchorView: UIView, type: SelectionType, dataSource: [SelectionDataSource], properties: SelectionViewProperties = SelectionViewProperties()) {
        super.init(nibName: nil, bundle: nil)
        
        anchorUIView = anchorView
        selectionType = type
        selectionDataSource = dataSource
        
        self.properties = properties
        
        initializeViews()
        setupViewProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
}

// MARK: - Custom Methods.
extension SelectionView {
    // Initialize views and add constraints.
    fileprivate func initializeViews() {
        // Background view.
        view = UIView(frame: .zero)
        
        let containerFrame = getFrameForContainer()
        containerView = UIView(frame: containerFrame)
        
        view.addSubview(containerView)
        
        // TableView.
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        
        // Menu Button.
        optionButton = UIButton(type: .custom)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(optionButton)
        
        // Add constraints.
        optionButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        optionButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0).isActive = true
        optionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: optionButton.bottomAnchor, constant: 0.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    // Setup properties.
    fileprivate func setupViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(1.0 - backgroundOpacity)
        
        containerView.masksToBounds = true
        containerView.cornerRadius = 10.0
        
        containerView.masksToBounds = false
        containerView.shadowColor = UIColor.black
        containerView.shadowOffest = CGSize(width: 5.0, height: 5.0)
        containerView.shadowRadius = 10.0
        containerView.shadowOpacity = 0.4
        
        // Setup TableView.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        
        tableView.register(SelectionTableViewCell.self, forCellReuseIdentifier: SelectionTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.cornerRadius = 10.0
        tableView.masksToBounds = true
        tableView.backgroundColor = backgroundColor
        containerView.backgroundColor = backgroundColor
        
        optionButton.setImage(optionButtonImage, for: .normal)
        optionButton.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
        
        // Add Tap gesture to the view to dismiss on tap.
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        if selectionType == .filter {
            let tableFooter = UIView(frame: CGRect(x: 0.0, y: 0.0, width: containerView.frame.width, height: doneFooterHeight))
            tableFooter.backgroundColor = backgroundColor
            
            doneButton = UIButton(type: .custom)
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            
            tableFooter.addSubview(doneButton)
            
            doneButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            doneButton.centerXAnchor.constraint(equalTo: tableFooter.centerXAnchor, constant: 0.0).isActive = true
            doneButton.centerYAnchor.constraint(equalTo: tableFooter.centerYAnchor, constant: 0.0).isActive = true
            
            doneButton.backgroundColor = UIColor.lightGray
            doneButton.setTitle("Done", for: .normal)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            doneButton.setTitleColor(UIColor.white, for: .selected)
            doneButton.titleLabel?.font = doneFont
            doneButton.cornerRadius = 17.5
            doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
            doneButton.isEnabled = false
            
            tableView.tableFooterView = tableFooter
        }
        
        // Animate.
        if animated {
            setupContainerShapeLayer()
            animateContainer(reveal: true)
        }
    }
    
    // Get Frame for ContainerView.
    fileprivate func getFrameForContainer() -> CGRect {
        let rows = selectionDataSource.reduce(0, ( { previousTotal, element in
            let total = previousTotal + (element.rows?.count ?? 0)
            return total
        }))
        
        var contentViewHeight: CGFloat = CGFloat(rows) * rowHeight // Total rows * row height
        
        if selectionType == .filter {
            contentViewHeight = contentViewHeight + 7.0 //doneFooterHeight
        }
        
        var contentFrame = CGRect(x: 15.0, y: 50.0, width: contentViewWidth, height: contentViewHeight) // Default frame in case found nil values.
        
        if let anchorView = anchorUIView, let window = UIApplication.shared.keyWindow {
            let frameInWindow = anchorView.convert(anchorView.frame, to: window)
            
            var x = frameInWindow.maxX - anchorView.frame.maxX - contentViewWidth + anchorView.frame.width + 5.0
            var y = frameInWindow.maxY - anchorView.frame.maxY - 5.0
            
            // If the calculated Coordinates are quite less, set it with appropriate values. Otherwise, it may go beyond the view.
            x = x <= 15.0 ? 15.0 : x
            y = y <= 10.0 ? 10.0 : y
            
            x = x + offset.x
            y = y + offset.y
            
            contentFrame = CGRect(x: x, y: y, width: contentViewWidth, height: contentViewHeight)
        }
        
        return contentFrame
    }
    
    // Setup Animation.
    fileprivate func setupContainerShapeLayer() {
        containerView.layer.mask = containerShapeLayer
        let bezierCurve = UIBezierPath(arcCenter: CGPoint(x: containerView.frame.width, y: 0.0), radius: containerView.frame.size.height * 2.0, startAngle: CGFloat.pi * 0.0, endAngle:  CGFloat.pi * 2.0, clockwise: false)
        containerShapeLayer.path = bezierCurve.cgPath
        containerShapeLayer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    }
    
    // Add Animation.
    fileprivate func animateContainer(reveal: Bool) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.fromValue             = reveal ? 0.0 : 1.0
        animation.toValue               = reveal ? 1.0 : 0.0
        animation.repeatCount           = 1
        animation.timingFunction        = CAMediaTimingFunction(name: reveal ? .easeIn : .easeOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode              = CAMediaTimingFillMode.forwards
        animation.duration              = 0.2
        animation.delegate              = self
        
        containerShapeLayer.add(animation, forKey: reveal ? "scaleUp" : "scaleDown")
    }
    
    // Method to show the SelectionView.
    open func show(animated: Bool = false, preSelectedIndices: [IndexPath]? = nil, completion: SelectionViewCompletionHandler?) {
        selectionHandler = completion
        self.preSelectedIndices = preSelectedIndices
        tableView.reloadData()
        self.animated = animated
        guard let topViewController = UIViewController.topViewController() else { return }
        modalPresentationStyle = .overCurrentContext
        topViewController.present(self, animated: false, completion: nil)
    }
    
    @objc fileprivate func didTapOption(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc fileprivate func didTapDone(_ sender: UIButton) {
        dismiss(animated: false) { [weak self] in
            self?.selectionHandler?(self?.selectedIndices)
        }
    }
    
    @objc fileprivate func dismissView(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - UITableView DataSource and Delegate Methods.
extension SelectionView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectionDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionDataSource[section].rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier) as? SelectionTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = selectionDataSource[indexPath.section].rows?[indexPath.row].title
        cell.titleLabel.textColor = textColor
        cell.titleLabel.font = font
        cell.backgroundColor = backgroundColor
        
        if selectionType == .menu {
            cell.icon.image = selectionDataSource[indexPath.section].rows?[indexPath.row].icon
        } else {
            cell.icon.image = selectedIndices.contains(indexPath) ? selectedCheckbox : unSelectedCheckbox
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectionDataSource[section].section == nil {
            return nil
        } else {
            let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 30.0))
            let headerLabel = UILabel(frame: headerView.frame)
            headerView.addSubview(headerLabel)
            
            headerLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
            headerLabel.textAlignment = .left
            headerLabel.text = selectionDataSource[section].section
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return selectionDataSource[section].section == nil ? 0.0 : 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionType == .menu {
            // Dismiss View after selecting a menu.
            selectionHandler?([indexPath])
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            }
        } else {
            // Select/De-select after selecting a filter.
            if multipleSelection {
                if selectedIndices.contains(indexPath) {
                    selectedIndices.removeAll(where: { $0 == indexPath })
                } else {
                    selectedIndices.append(indexPath)
                }
            } else {
                selectedIndices.removeAll()
                selectedIndices.append(indexPath)
            }
            tableView.reloadData()
        }
    }
}

extension SelectionView: UIGestureRecognizerDelegate, CAAnimationDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer == tapGesture ? (touch.view == view ? true : false) : true
    }
}

fileprivate class SelectionTableViewCell: UITableViewCell {
    var icon: UIImageView!
    var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        // Add Icon ImageView and Title Label.
        icon = UIImageView()
        titleLabel = UILabel()
        
        // Setup constraints.
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        
        icon.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 15.0).isActive = true
        icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true
        
        // Setup properties.
        titleLabel.textAlignment = .left
        
        icon.contentMode = .scaleAspectFit
        icon.cornerRadius = 3.0
        icon.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum SelectionType {
    case menu
    case filter
}

struct SelectionDataSource {
    var section: String?
    var rows: [SelectionRow]?
}

struct SelectionRow {
    var title: String?
    var icon: UIImage?
    
    init(title: String, icon: UIImage? = nil) {
        self.title = title
        self.icon = icon
    }
}

class SelectionViewProperties {
    var unSelectedCheckbox: UIImage = #imageLiteral(resourceName: "VG_TickBox")
    var selectedCheckbox: UIImage = #imageLiteral(resourceName: "check")
    var optionButtonImage: UIImage? = #imageLiteral(resourceName: "VG_Filter")
    var rowHeight: CGFloat = 60.0
    var contentViewWidth: CGFloat = 180.0
    var backgroundOpacity: CGFloat = 1.0
    var animated: Bool = false
    var backgroundColor = UIColor.darkGray
    var textColor = UIColor.black
    var font: UIFont = UIFont.systemFont(ofSize: 16.0)
    var multipleSelection: Bool = false
    var doneButtonColor: UIColor = #colorLiteral(red: 0.9098039216, green: 0.05098039216, blue: 0, alpha: 1)
    var doneFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .bold)
    var offset: CGPoint = CGPoint(x: 0.0, y: 0.0)
}

