//
//  EntryViewController.swift
//  Daily Journal
//
//  Created by Vatsal Patel on 18/01/21.
//

import UIKit

class EntryViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var entryTextView: UITextView!
    
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        if entry == nil {
            //create
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                entry = Entry(context: context)
                entry?.date = datePicker.date
                entry?.text = "Today was ..."
                entryTextView.becomeFirstResponder()
            }
        }
        
        entryTextView.text = entry?.text
        if let dateToBeShowen = entry?.date {
            datePicker.date = dateToBeShowen
        }
        entryTextView.delegate = self
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        // Make an entry
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            bottomConstraint.constant = keyboardHeight
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if entry != nil {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(entry!)
                try? context.save()
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func textViewDidChange(_ textView: UITextView) {
        entry?.text = entryTextView.text
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        entry?.date = datePicker.date
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

    }
}
