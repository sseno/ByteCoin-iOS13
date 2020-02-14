//
//  MainViewController.swift
//  ByteCoin
//
//  Created by Rohmat Suseno on 13/02/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import UIKit
import LBTATools

class MainViewController: UIViewController {
    
    let titleLabel = UILabel(text: "ByteCoin", font: .systemFont(ofSize: 50, weight: .thin), textAlignment: .center)
    let img = UIImageView(image: UIImage(systemName: .init(stringLiteral: "bitcoinsign.circle.fill")))
    let containerView = UIView(backgroundColor: .gray)
    let bitcointLabel = UILabel(text: "...", font: .systemFont(ofSize: 25), textColor: .white, textAlignment: .right)
    let currencyLabel = UILabel(text: "IDR", font: .systemFont(ofSize: 25), textColor: .white)
    let currencyPicker = UIPickerView(backgroundColor: .clear)
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        view.backgroundColor = .white
        
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    private func setupViews() {
        view.stack(titleLabel,
                   containerView.withHeight(80),
                   UIView(),
                   currencyPicker.withHeight(200),
                   spacing: 25,
                   alignment: .center)
            .withMargins(.init(top: 10, left: 0, bottom: 0, right: 0))
        
        containerView.layer.cornerRadius = 10
        img.tintColor = .white
        containerView.hstack(img.withWidth(80),
                             bitcointLabel,
                             currencyLabel,
                             spacing: 10)
            .withMargins(.init(top: 0, left: 14, bottom: 0, right: 14))
    }
}

// MARK: - UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

// MARK: - UIPickerViewDataSource
extension MainViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK: - CoinManagerDelegate
extension MainViewController: CoinManagerDelegate {
    
    func didSuccess(_ coinModel: CoinModel) {
        DispatchQueue.main.async {
            self.bitcointLabel.text = coinModel.rateFormatter(rate: coinModel.rate)
            self.currencyLabel.text = coinModel.assetIdQuote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

#if DEBUG
import SwiftUI
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    struct ContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainViewController_Previews.ContentView>) -> UIViewController {
            return MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MainViewController_Previews.ContentView>) {
            
        }
    }
}
#endif
