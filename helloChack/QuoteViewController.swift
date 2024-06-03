//
//  QuoteViewController.swift
//  helloChack
//
//  Created by Ярослав  Мартынов on 02.06.2024.
//

import UIKit

class QuoteViewController: UIViewController {
    
    
    var refreshAllQuote: ()-> Void = {}
    
    var refreshGroupQuote: ()-> Void = {}
    
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadQuoteButton: CustomButton = {
        let button = CustomButton(title: "Загрузить цитату", titleColor: .systemBlue){
            self.getQuote()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
  

        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        view.backgroundColor = .white
        title = "Рандомная цитата"
    }
    
    func addSubviews(){
        view.addSubview(quoteLabel)
        view.addSubview(loadQuoteButton)
    }
    
    func setupConstraints(){
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            quoteLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -32),
            quoteLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quoteLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            loadQuoteButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loadQuoteButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 32),
            
        ])
    }
    
    
    func getQuote(){
        NetworkManager.getQuote(){result  in
            switch result{
            case .success(let quote):
                QuoteManager.addItem(quote: quote)
                DispatchQueue.main.async{ [weak self] in
                    self?.quoteLabel.text = quote.value
                    print(quote.categories)
                    self?.refreshAllQuote()
                    self?.refreshGroupQuote()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
