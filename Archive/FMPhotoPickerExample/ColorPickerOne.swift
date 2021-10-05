//
//  ColorPickerOne.swift
//  FMPhotoPickerExample
//
//  Created by Nawazish Abbas on 02/10/2021.
//  Copyright © 2021 Tribal Media House. All rights reserved.
//

import Foundation
import FlexColorPicker

var pickedColor = #colorLiteral(red: 0.6813090444, green: 0.253660053, blue: 1, alpha: 1)

@objc public protocol SelectedColorPicker: class {
    func setLabelTextColor(color: UIColor)
}

class ColorPickerOne: UIViewController  {
    @IBOutlet weak var pickerColorPreview: CircleShapedView!
    @objc weak var delegate: SelectedColorPicker?

    public override func viewDidLoad() {
        super.viewDidLoad()
        pickerColorPreview.backgroundColor = .clear
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationColorPicker = segue.destination as? ColorPickerControllerProtocol {
            destinationColorPicker.selectedColor = pickedColor
            destinationColorPicker.delegate = self
        }
    }
    @IBAction func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ColorPickerOne: ColorPickerDelegate {
    
    public func colorPicker(_: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        pickedColor = selectedColor
//        delegate?.setLabelTextColor(color: pickedColor)
        NotificationCenter.default.post(name: Notification.Name("CLTextViewColorSection"), object: pickedColor)

        pickerColorPreview.backgroundColor = selectedColor
    }

    public func colorPicker(_: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
        navigationController?.popViewController(animated: true)
    }
}
