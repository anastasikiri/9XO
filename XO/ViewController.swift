//
//  ViewController.swift
//  XO
//
//  Created by Anastasia Bilous on 2022-01-17.
//

import UIKit

class ViewController: UIViewController {
    
    let userChart = "X"
    let computerChart = "O"
    let defaultChart = "*"
    var fieldsItems: [[String]]!
    
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet weak var oTextField: UITextField!
    @IBOutlet var fieldsImageView: [UIImageView]!
    @IBOutlet weak var playAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAgain.isEnabled = false
        
        fieldsItems = [
            [defaultChart, defaultChart, defaultChart],
            [defaultChart, defaultChart, defaultChart],
            [defaultChart, defaultChart, defaultChart],
        ]
    }
    
    @IBAction func setButton(_ sender: Any) {
        
        titleLabel.text = "Let's play XO!"
        titleLabel.textColor = .systemPurple
        
        guard let xText = xTextField.text,
              let yText = oTextField.text,
              let x = Int(xText),
              let y = Int(yText)
        else {
            return
        }
        if x > 2 || y > 2 {
            warningMessage()
            return
        }
        
        //check if the field is available
        if fieldsItems[y][x] != defaultChart{
            titleLabel.text = "Not available!"
            titleLabel.textColor = .systemRed
            return
        }
        
        // check if all fields are completed and no winner still
        if isFieldsCompleted() {
            titleLabel.textColor = .systemCyan
            titleLabel.text = "No Winner!"
            playAgain.isEnabled = true
            setButton.isEnabled = false
        }
        
        fieldsItems[y][x] = userChart
        draw()
        
        // check if user wins
        if isRightDiagonalWin(with: userChart) || isLeftDiagonalWin(with: userChart)
            || isLineWin(with: userChart) || isColumnWin(with: userChart) {
            titleLabel.text = "You win!"
            titleLabel.textColor = .systemGreen
            playAgain.isEnabled = true
            setButton.isEnabled = false
            return
        }
        
        //check if computer wins
        playComputer()
        if isRightDiagonalWin(with: computerChart) || isLeftDiagonalWin(with: computerChart)
            || isLineWin(with: computerChart) || isColumnWin(with: computerChart) {
            titleLabel.text = "Computer wins!"
            titleLabel.textColor = .yellow
            playAgain.isEnabled = true
            setButton.isEnabled = false
            return
        }
    }
    
    @IBAction func playAgainButton(_ sender: UIButton) {
        
        xTextField.text = ""
        oTextField.text = ""
        titleLabel.text = "Let's play XO!"
        titleLabel.textColor = .systemPurple
        
        fieldsItems = [
            [defaultChart, defaultChart, defaultChart],
            [defaultChart, defaultChart, defaultChart],
            [defaultChart, defaultChart, defaultChart],
        ]
        
        draw()
        playAgain.isEnabled = false
        setButton.isEnabled = true
    }
    
    func warningMessage() {
        let alertVC = UIAlertController(
            title: nil,
            message: "Please input numbers 0, 1 or 2 to continue",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: {_ in
            self.xTextField.text = ""
            self.oTextField.text = ""
        }
        )
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    // check all fields are completed
    func isFieldsCompleted() -> Bool {
        var count = 8
        for i in 0..<fieldsItems.count {
            for j in 0..<fieldsItems[i].count {
                if  fieldsItems[i][j] != defaultChart {
                    count -= 1
                }
            }
        }
        return count == 0
    }
    
    // MARK:methods for checking if computer or user wins
    func isRightDiagonalWin(with char :String) -> Bool {
        var count = 0
        for i in 0..<fieldsItems.count {
            for j in 0..<fieldsItems[i].count {
                if i == j && fieldsItems[i][j] == char {
                    count += 1
                }
            }
        }
        return count == 3
    }
    
    func isLeftDiagonalWin(with char :String) -> Bool {
        var count = 0
        
        for i in 0..<fieldsItems.count {
            for j in 0..<fieldsItems[i].count {
                if i == fieldsItems.count - 1 - j && fieldsItems[i][j] == char {
                    count += 1
                }
            }
        }
        return count == 3
    }
    
    func isLineWin(with char: String) -> Bool {
        var count = 0
        for i in 0..<fieldsItems.count {
            count = 0
            for j in 0..<fieldsItems[i].count {
                if fieldsItems[i][j] == char {
                    count += 1
                }
            }
            if count == 3 {
                break
            }
        }
        return count == 3
    }
    
    func isColumnWin(with char: String) -> Bool {
        var count = false
        var count0 = 0
        var count1 = 0
        var count2 = 0
        for i in 0..<fieldsItems.count {
            for j in 0..<fieldsItems[i].count {
                if fieldsItems[i][j] == char {
                    switch j {
                    case 0:
                        count0 += 1
                    case 1:
                        count1 += 1
                    case 2:
                        count2 += 1
                    default:
                        break
                    }
                }
                if count0 == 3 || count1 == 3 || count2 == 3 {
                    count = true
                }
            }
        }
        return count
    }
    
    func playComputer() {
        for i in 0..<fieldsItems.count {
            for j in 0..<fieldsItems[i].count {
                if fieldsItems[i][j] == defaultChart {
                    fieldsItems[i][j] = computerChart
                    draw()
                    return
                }
            }
        }
    }
    
    func draw() {
        var imgIndex = 0
        for items in fieldsItems{
            for item in items {
                switch item {
                case defaultChart:
                    fieldsImageView[imgIndex].image = UIImage(systemName: "pencil")
                case userChart:
                    fieldsImageView[imgIndex].image = UIImage(named: "icon.x")
                case computerChart:
                    fieldsImageView[imgIndex].image = UIImage(named: "icon.o")
                default: break
                }
                imgIndex += 1
            }
        }
    }
}

