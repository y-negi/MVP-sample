//
//  SampleDetailViewController.swift
//  MVP-sample
//
//  Created by 根岸 裕太 on 2019/01/29.
//  Copyright © 2019年 根岸 裕太. All rights reserved.
//

import UIKit

// ※ 値渡ししたいものを定義している。MVPとは関係ないが、Segueを利用する時は個人的に定義したりしている。Segueを利用しない場合はinitでinjectしてもらってもいいと思う。
struct SampleDetailViewControllerSender {
    let sample: Sample
}

final class SampleDetailViewController: UIViewController {
    
    // Inject
    var sender: SampleDetailViewControllerSender!
    
    // IBOutlet
    @IBOutlet private weak var contentLabel: UILabel!

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentLabel.text = self.sender.sample.content
    }

}
