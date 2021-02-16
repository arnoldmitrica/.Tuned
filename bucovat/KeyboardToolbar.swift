//
//  KeyboardToolbar.swift
//  bucovat
//
//  Created by Arnold Mitricã on 16.02.2021.
//

import Foundation
import UIKit

protocol KeyboardToolbarDelegate: class {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textView: UITextView)
}

class KeyboardToolbar: UIToolbar {

    private weak var toolBarDelegate: KeyboardToolbarDelegate?
    private weak var textView: UITextView!

    init(for textView: UITextView, toolBarDelegate: KeyboardToolbarDelegate) {
        super.init(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44)))
        barStyle = .default
        isTranslucent = true
        self.textView = textView
        self.toolBarDelegate = toolBarDelegate
        textView.inputAccessoryView = self
    }

    func setup(leftButtons: [KeyboardToolbarButton], rightButtons: [KeyboardToolbarButton]) {
        let leftBarButtons = leftButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped(sender:)))
        }
        let rightBarButtons = rightButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped(sender:)))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems(leftBarButtons + [spaceButton] + rightBarButtons, animated: false)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    @objc func buttonTapped(sender: UIBarButtonItem) {
        guard let type = KeyboardToolbarButton.detectType(barButton: sender) else { return }
        toolBarDelegate?.keyboardToolbar(button: sender, type: type, isInputAccessoryViewOf: textView)
    }
}

extension UITextView {
    func addKeyboardToolBar(leftButtons: [KeyboardToolbarButton],
                            rightButtons: [KeyboardToolbarButton],
                            toolBarDelegate: KeyboardToolbarDelegate) {
        let toolbar = KeyboardToolbar(for: self, toolBarDelegate: toolBarDelegate)
        toolbar.setup(leftButtons: leftButtons, rightButtons: rightButtons)
    }
}
