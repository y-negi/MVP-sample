//
//  SampleListPresenter.swift
//  MVP-sample
//
//  Created by 根岸 裕太 on 2019/01/29.
//  Copyright © 2019年 根岸 裕太. All rights reserved.
//

import Foundation

// ※ MVPのPにあたる。UIロジックを司る。ModelとViewの橋渡しのような役割。今回のMVPはPassiveViewパターンのため、全てPresenterを経由することになる。

// ※ この画面のInputを定義する。メソッド名はInputの動作そのものになるように意識している。Presenterで行う動作を表すようなメソッド名にしても悪くはないと思うが、プロジェクト内で統一されていることが重要。
protocol SampleListPresenterInput {
    var numberOfSample: Int { get }
    func viewDidLoad()
    func sample(forRow row: Int) -> Sample?
    func didSelectRow(at indexPath: IndexPath)
}

// ※ この画面のOutputを定義する。主にViewに何か動作をして欲しいようなメソッドを定義する。classOnlyProtocolなためAnyObjectを継承。
protocol SampleListPresenterOutput: AnyObject {
    func updateSamples()
    func transitionToSampleDetail(sample: Sample)
}

final class SampleListPresenter: SampleListPresenterInput {
    
    // Inject
    // ※ 必要なものを定義しておき、initで渡してもらうことで、モックを注入出来るようにしてPresenterのテスタビリティを向上させる。
    private weak var view: SampleListPresenterOutput!
    private var sampleAPI: SampleAPIInput
    
    // DataSource
    private var samples: [Sample] = []
    
    init(view: SampleListPresenterOutput, sampleAPI: SampleAPIInput) {
        self.view = view
        self.sampleAPI = sampleAPI
    }
    
    // MARK: - PresenterInput
    
    /// サンプルの数
    var numberOfSample: Int {
        return self.samples.count
    }
    
    /// 画面生成時処理
    /// SampleAPIをコールし、画面の更新を促す。
    func viewDidLoad() {
        self.sampleAPI.fetchSample(succeeded: { [weak self] (response) in
            self?.samples = response
            
            // ※ 画面更新のためメインスレッドに戻す。Vで記述するかPで記述するかはプロジェクト内で統一する。
            DispatchQueue.main.async {
                self?.view.updateSamples()
            }
        }) { (error) in
            print(error)
        }
    }
    
    /// 指定したindexのサンプルを返す
    ///
    /// - Parameter row: index
    /// - Returns: サンプル
    func sample(forRow row: Int) -> Sample? {
        guard row < self.samples.count else { return nil }
        
        return self.samples[row]
    }
    
    /// サンプル選択時処理
    ///
    /// - Parameter indexPath: IndexPath
    func didSelectRow(at indexPath: IndexPath) {
        guard let sample = self.sample(forRow: indexPath.row) else { return }
        
        self.view.transitionToSampleDetail(sample: sample)
    }
    
}
