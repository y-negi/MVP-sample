//
//  SampleAPI.swift
//  MVP-sample
//
//  Created by 根岸 裕太 on 2019/01/29.
//  Copyright © 2019年 根岸 裕太. All rights reserved.
//

import Foundation

// ※ MVPのMにあたる。俗にいうModel。

// ※ このModelのInputを定義する。モック作成が出来るようにしている。
protocol SampleAPIInput {
    func fetchSample(succeeded: @escaping ([Sample]) -> (), failed: @escaping (Error) -> ())
}

final class SampleAPI: SampleAPIInput {
    
    /// サンプルを取得する
    ///
    /// - Parameters:
    ///   - succeeded: 成功時コールバック
    ///   - failed: 失敗時コールバック
    func fetchSample(succeeded: @escaping ([Sample]) -> (), failed: @escaping (Error) -> ()) {
        // 省略
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            succeeded(
                [
                    Sample(id: 0, title: "title1", content: "content1"),
                    Sample(id: 1, title: "title2", content: "content2"),
                    Sample(id: 2, title: "title3", content: "content3")
                ]
            )
        }
    }
    
}
