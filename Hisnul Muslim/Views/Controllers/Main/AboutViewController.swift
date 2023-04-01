//
//  AboutViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 4/1/23.
//

import UIKit

class AboutViewController: UIViewController {
    
    private let book_Img  = UIImageView(frame: .zero)
    
    private let book_description: UITextView = {
        let textView = UITextView()
        let attributeText = NSMutableAttributedString(string: "حِصن المسلمِ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 36), NSAttributedString.Key.foregroundColor: UIColor.label])
        attributeText.append(NSAttributedString(string: "\n\n\n حصن المسلم، المعروف أيضًا باسم قلعة المؤمن، هو كتاب شهير للأدعية والأذكار الإسلامية. وقد جمعه سعيد بن علي بن وهف القحطاني، ويتضمن العديد من الأدعية من القرآن والسنة النبوية.يتميز الكتاب بأنه مقسم إلى أقسام مختلفة، ويحتو على أدعية\r لمناسبات مختلفة، بما في ذلك الاستيقاظ من النوم والذهاب إلى النوم، والدخول والخروج من المسجد، والسفر، والمزيد. كما يتضمن الكتاب أدعية للحماية من الشر، وطلب المغفرة، وطلب الهداية والبركات من الله.\rتم ترجمة حصن المسلم إلى العديد من اللغات ويستخدمه المسلمون في جميع أنحاء العالم. يعتبر الكتاب موردًا قيمًا لأي شخص يسعى لتقوية علاقته مع الله وتحسين صلواته وأذكاره اليومية. يمكن قراءة الأدعية البسيطة والعميقة في الكتاب طوال اليوم لجلب المرء أقرب إلى الله والبحث عن حمايته وإرشاده.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        textView.attributedText = attributeText
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configAboutBook()
    }
    
    private func configAboutBook() {
        view.addSubViews(book_Img, book_description)
        book_Img.image = UIImage(named: "HisnulMuslimBook")
        book_Img.contentMode = .scaleAspectFit
        book_Img.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            book_Img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            book_Img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            book_Img.heightAnchor.constraint(equalToConstant: 300),
            book_Img.widthAnchor.constraint(equalToConstant: 300),
            
            book_description.topAnchor.constraint(equalTo: book_Img.bottomAnchor, constant: 30),
            book_description.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            book_description.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            book_description.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
        ])
    }
}
