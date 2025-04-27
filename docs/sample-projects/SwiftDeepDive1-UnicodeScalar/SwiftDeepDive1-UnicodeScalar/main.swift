//
//  main.swift
//  SwiftDeepDive1-UnicodeScalar
//
//  Created by Austin's Macbook Pro M3 on 4/27/25.
//

import Foundation

/// Unicode.Scalar와 UnicodeScalar는 같은 표현입니다.
/// `public typealias UnicodeScalar = Unicode.Scalar`
/// UnicodeScalar로 얻게 된 스칼라값을 통해 해당 스칼라값이 가지는 문자를 생성할 수 있습니다.
let scalarA: Unicode.Scalar = "A"
let characterA = Character(UnicodeScalar(scalarA.value)!)
print(scalarA.value)
print(characterA)
// 65
// A

/// Unicode 숫자를 통해 직접 생성할 수 있습니다.
let scalarB: UnicodeScalar = Unicode.Scalar(0042)!
let scalarHeart: Unicode.Scalar = Unicode.Scalar(0x2665)!
print(scalarHeart)
print(scalarB)
// ♥
// *

/// 해당 문자에 대한 Unicode값을 value property를 통해 접근할 수 있습니다.
print(scalarA.value)
// 65

/// 그럼 문자들을 a-z까지 돌면서 확인하는 상황도 가능해집니다.
let start = UnicodeScalar("a").value
let end = UnicodeScalar("z").value
for i in start...end {
    print(String(UnicodeScalar(i)!))
}
// a
// b
// ...
// z

