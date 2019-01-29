//
//  SampleListViewController.swift
//  MVP-sample
//
//  Created by 根岸 裕太 on 2019/01/29.
//  Copyright © 2019年 根岸 裕太. All rights reserved.
//

import UIKit

// ※ MVPのVにあたる。UIのInput/Outputのみを司る。Inputは状況に応じてPresenterに流し、ロジックは全て他に任せて表示のみを行う。

final class SampleListViewController: UIViewController {
    // ※ Presenterを初期化する。initでselfを定義したいため、lazyプロパティを設定している。
    private lazy var presenter = SampleListPresenter(view: self,
                                                     sampleAPI: SampleAPI())
    
    // SegueIdentifier
    // ※ Segueを利用しているため定数定義。Segueを利用しない場合は、ViewControllerにinitを生やしてPresenter等依存性のあるものはinjectしてもいいかもしれない。
    private static let toDetail = "toDetailShow"

    // IBOutlet
    @IBOutlet private weak var sampleTableView: UITableView!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailView = segue.destination as? SampleDetailViewController,
            let detailSender = sender as? SampleDetailViewControllerSender {
            detailView.sender = detailSender
        }
    }

}

// MARK: - SampleListPresenterOutput

extension SampleListViewController: SampleListPresenterOutput {
    
    /// リストを更新する
    func updateSamples() {
        self.sampleTableView.reloadData()
    }
    
    /// サンプル詳細画面に遷移する
    ///
    /// - Parameter sample: サンプル
    func transitionToSampleDetail(sample: Sample) {
        let detailSender = SampleDetailViewControllerSender(sample: sample)
        self.performSegue(withIdentifier: SampleListViewController.toDetail, sender: detailSender)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SampleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfSample
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = self.presenter.sample(forRow: indexPath.row)?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.presenter.didSelectRow(at: indexPath)
    }
    
}
