# Swift에서 Unicode.Scalar 다루기

## 개요

이 문서는 Swift에서 `Unicode.Scalar` 타입을 이해하고, 이를 활용하여 문자열을 보다 세밀하게 다루는 방법을 소개합니다.  

이 문서를 통해 다음을 얻을 수 있습니다:

- Unicode 배경에 대한 이해
- Unicode 스칼라(Unicode Scalar)와 그 역할에 대한 이해
- `Unicode.Scalar` 타입이 제공하는 주요 기능 파악
- 실제 코드 예시를 통한 `Unicode.Scalar` 활용법 습득

<br>

## Unicode 개요

### Unicode란?

Unicode는 전 세계의 모든 문자를 고유한 숫자(코드 포인트, Code Point)로 일관되게 표현하기 위해 만들어진 국제 표준입니다.  
각 문자는 "U+0000" 같은 형식으로 표현되는 고유 번호를 가집니다.  
예를 들면:

- 'A' → U+0041
- '가' → U+AC00
- '😀' → U+1F600

Unicode의 목표는 **모든 문자와 기호를 하나의 통합된 체계**로 다루는 것입니다.

### UTF-8, UTF-16, UTF-32 인코딩

Unicode 자체는 "숫자 목록"일 뿐입니다.  
컴퓨터가 이를 저장하거나 전송하려면 **인코딩**이 필요합니다.

- **UTF-8**  
  - 가변 길이 인코딩 (1 ~ 4 바이트)
  - ASCII와 호환됩니다. (영어권 텍스트에서는 매우 효율적)
  - 웹에서 가장 많이 사용됩니다.

- **UTF-16**  
  - 가변 길이 인코딩 (2바이트 또는 4바이트)
  - 일부 문자(U+10000 이상)는 2개 16비트 코드 유닛(서로게이트 페어)로 표현됩니다.
  - Windows 및 일부 프로그래밍 언어에서 널리 사용됩니다.

- **UTF-32**  
  - 고정 길이 인코딩 (4바이트)
  - 모든 문자를 4바이트로 직접 표현 (단순하지만 메모리 비효율적)

### Swift와 Unicode

Swift의 `String` 타입은 내부적으로 UTF-16을 기반으로 하면서, 개발자가 필요할 경우 UTF-8, UTF-16, Unicode Scalar View로 자유롭게 접근할 수 있도록 제공합니다.

- `string.utf8` → UTF-8 뷰
- `string.utf16` → UTF-16 뷰
- `string.unicodeScalars` → Unicode 스칼라 뷰
- `string` → 인간 친화적 Character 뷰

이러한 구조 덕분에 Swift에서는 텍스트를 다양한 레벨로 세밀하게 다룰 수 있습니다.

<br>

## Unicode.Scalar의 기본 개념

- **Unicode Scalar**  
  Swift에서는 문자열을 여러 가지 방법으로 다룰 수 있습니다.  
예를 들어, 어떤 사람은 글자를 하나하나 읽고 싶고, 어떤 사람은 파일로 저장할 때 작은 크기로 압축하고 싶을 수도 있습니다.
Unicode는 모든 글자에 고유한 번호(코드 포인트)를 붙여놓은 국제 표준입니다.  
하지만 컴퓨터는 이 번호를 저장할 때, 크기나 방식에 따라 다양한 방법(인코딩)을 사용합니다. 대표적인 인코딩 방법이 바로 **UTF-8**, **UTF-16**입니다.

- **UTF-8**은 글자마다 저장하는 크기가 달라집니다. (영어는 작게, 이모지나 한글은 크게)
- **UTF-16**은 보통 2바이트(16비트)씩 쓰는데, 복잡한 글자는 두 덩어리로 저장합니다.

하지만 만약 **"이 글자가 어떤 글자인지"** 를 알고 싶다면, 저장방식(UTF-8, UTF-16) 같은 건 몰라도 됩니다.  
**그저 Unicode에서 정해준 번호(코드 포인트)만 알면 됩니다.**

여기서 Swift의 `Unicode.Scalar`가 등장합니다.

> `Unicode.Scalar`는 글자 하나에 해당하는 고유 번호(코드 포인트)를 Swift에서 쉽게 다루게 해주는 타입입니다.

즉, 복잡한 저장 방식과 상관없이 **"글자 하나"** 를 직접 보고, 비교하고, 조작할 수 있게 해주는 기본 단위가 바로 `Unicode.Scalar`입니다.


- **Swift의 Unicode.Scalar**  
  Swift에서는 `Unicode.Scalar` 타입을 통해 이 스칼라 값을 표현합니다.  
  `Unicode.Scalar`는 다음을 보장합니다:
  - 항상 유효한 스칼라 범위 내의 값
  - 문자열 내부에서 개별 유니코드 스칼라를 다룰 수 있는 기능 제공

<br>

## Unicode.Scalar가 제공하는 기능

- 유니코드 스칼라 값(Unicode Scalar Value)을 안전하게 다룰 수 있음
- 스칼라 값의 정수형 코드 포인트 접근 가능 (`value` 프로퍼티)
- 스칼라의 문자열 표현 제공 (`description`, `escaped(asASCII:)` 등)
- 유니코드 스칼라 범위 검사 및 비교 지원
- 문자열(`String`) 및 문자(`Character`) 타입과의 상호 변환

<br>

## Unicode.Scalar의 기본 활용

### 스칼라 생성

```swift
let scalarA: Unicode.Scalar = "A"
let scalarHeart: Unicode.Scalar = Unicode.Scalar(0x2665)!
```

### 스칼라의 값 접근

```swift
print(scalarA.value) // 출력: 65
print(scalarHeart.value) // 출력: 9829
```

### 스칼라를 문자열로 변환

```swift
let stringFromScalar = String(scalarHeart) // "♥"
```

### 스칼라와 Character, String 간 변환

```swift
let characterFromScalar = Character(scalarA)
let stringFromCharacter = String(characterFromScalar)
```

---

## 예시 코드

```swift
// Unicode.Scalar 생성
if let smiley = Unicode.Scalar(0x1F600) {
    print("Smiley:", smiley)            // 😀
    print("Code point:", smiley.value)   // 128512
}

// 문자열로 변환
let heart = Unicode.Scalar("♥")
print("Heart as string:", String(heart)) // ♥

// 문자열을 Unicode.Scalar 배열로 분해
let text = "Hi! 🌟"
for scalar in text.unicodeScalars {
    print("Scalar:", scalar, "Value:", scalar.value)
}
```