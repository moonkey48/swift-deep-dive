# Fluid Interfaces: @Namespace & matchedGeometryEffect

##  개요

SwiftUI는 부드럽고 자연스러운 사용자 경험을 구현할 수 있는 다양한 애니메이션 기능을 제공합니다. 그중에서도 @Namespace와 matchedGeometryEffect를 활용하면 두 개의 서로 다른 뷰 간 전환에서 시각적으로 일관된 애니메이션을 쉽게 구현할 수 있습니다. 이 문서에서는 애플이 말하는 Fluid Animation의 개념을 이해하고, 이를 구현하기 위해 @Namespace와 matchedGeometryEffect를 어떻게 활용하는지 알아봅니다.


## Fluid Interfaces이란?

애플은 Fluid Animation을 “사용자의 행동에 즉각적이고 자연스럽게 반응하며, 물리적 연속성을 지닌 전환”으로 정의합니다. 예를 들어, 리스트의 썸네일을 탭했을 때 그 이미지가 자연스럽게 전체 화면으로 확장되는 애니메이션은 Fluid Animation의 전형적인 예입니다. 사용자에게 뷰 간의 전환이 끊기지 않고 연결되어 있다는 느낌을 주는 것이 핵심입니다.
> 💭 개인적으로는 애플이 제공하고 있는 인터페이스가 가지는 큰 특징 중 하나라고 생각합니다. 자연스러운 애니메이션은 부가적인 기능이나 심미성 측면 뿐만 아니라 사용자의 인지적인 측면에서의 피로도를 낮추고 예측가능하게 합니다. 

[Fluid Interface WWDC18](https://developer.apple.com/videos/play/wwdc2018/803/)


## @Namespace란?

@Namespace는 SwiftUI에서 뷰 간의 연결을 식별하는 
**공유된 ID 영역(namespace)**
입니다. 서로 다른 뷰 간에도 같은 @Namespace를 통해 해당 뷰의 위치, 크기, 속성 변화를 추적할 수 있도록 해줍니다.

```swift
@Namespace var animationNamespace
```

이렇게 선언한 namespace는 여러 뷰에 걸쳐 사용될 수 있으며, SwiftUI는 이 값을 기준으로 애니메이션을 적용할 수 있는 요소를 추적합니다.


## @Namespace와 연결해주는 matchedGeometryEffect(_:in:)

matchedGeometryEffect는 두 개의 뷰가 같은 Geometry ID와 Namespace를 공유할 때, SwiftUI가 자동으로 위치와 크기 등 다양한 속성을 보간하여 애니메이션을 수행하게 해줍니다.

> 여기서 id는 Hashable 프로토콜을 준수하는 값입니다. 같은 id를 사용하는 View는 상태가 변경될 때 서로의 View로 자연스럽게 이동되게 됩니다. 
```swift
.matchedGeometryEffect(id: "image", in: animationNamespace)
```


이 효과를 활용하면, 하나의 뷰에서 다른 뷰로 전환될 때의 변화가 부드럽게 애니메이션되며, 사용자가 뷰의 연속성을 자연스럽게 인식할 수 있도록 만듭니다.

### 예시코드
```swift
import SwiftUI

struct MatchedSource: View {
    @Namespace private var namespace
    @State private var isOn = true

    var body: some View {
        VStack {
            Spacer()
            if isOn {
                HStack {
                    Spacer()
                    Circle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "ball", in: namespace)
                }
            } else {
                HStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "ball", in: namespace)
                    Spacer()
                }
            }
            Spacer()
            Button {
                withAnimation {
                    isOn.toggle()
                }
            } label: {
                Text(isOn ? "Turn Off" : "Turn On")
            }
        }
    }
}
```

|withAnimation만 사용한 경우|matchedGeometryEffect를 사용한 경우|
|------|---|
|<img src='/docs/screenshorts/fluid-interface/ball-notApplied.gif'>|<img src='/docs/screenshorts/fluid-interface/ball-applied.gif.gif'>|


## 사용 시 유의 점

1. `matchedGeometryEffect`를 적용해도 `withAnimation`또는 `.animation` 모디파이어를 적용해야 기대하는 자연스러운 애니메이션을 만들 수 있습니다. 
2. 모든 경우에 `matchedGeometryEffect`를 사용하는 것이 유용한 것은 아닙니다.
   
   > 조건에 따라 전혀 다른 뷰가 되어버리는 경우 `withAnimation`을 사용한 것과 다르지 않게 됩니다. 
   <br>
   조건에 따라 화면이 달라지지만 **같은 View가 남아있는 경우**에 자연스러운 애니메이션을 만들 수 있습니다. 
   <br>


## Fluid Navigation

화면을 이동할 때 자연스러운 애니메이션이 가능합니다. 애플은 iOS 18부터 사용 가능한 `matchedTransitionSource`은 Navigation 이동 시 자연스럽게 이동할 수 있는 트렌지션을 제공합니다.

1. `.matchedTransitionSource(id:, in: )`을 원하는 View에 적용합니다. 
2. `.navigtaionTransition()`에서 `.zoom(sourceID:,in:)`에 소스로 저장했던 ID와 namespace를 적용합니다. 

```swift
struct ContentView: View {
    @Namespace private var todoAnimation
    @State private var colors: [Color] = [
        .green, .yellow, .blue
    ]


    var body: some View {
        NavigationStack {
            ForEach(colors, id: \.hashValue) { color in
                NavigationLink(value: color) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        // 1)
                        .matchedTransitionSource(id: color, in: todoAnimation)
                }
            }
            .navigationDestination(for: Color.self) { color in
                color
                    .ignoresSafeArea()
                    .navigationTransition(.zoom(sourceID: color, in: todoAnimation))
            }
        }
    }
}

```

|withAnimation만 사용한 경우|matchedTransitionSource를 사용한 경우|
|------|---|
|<img src='/docs/screenshorts/fluid-interface/color-notApplied.gif'>|<img src='/docs/screenshorts/fluid-interface/color-applied.gif'>|



## 정리

- [ ] `@Namespace`는 서로 다른 뷰의 변화를 연결해주는 식별자 역할을 합니다.
- [ ] `matchedGeometryEffect`는 같은 `ID`와 `Namespace`를 공유하는 뷰 간의 속성 차이를 부드럽게 애니메이션 처리해 줍니다.
- [ ] 두 기능을 활용하면 SwiftUI에서 끊김 없는 전환 애니메이션, 즉 Fluid Animation을 구현할 수 있습니다.
- [ ] 사용자 경험을 향상시키고 싶은 인터랙션 디자인에서 활용할 수 있습니다. 
