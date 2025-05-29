// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AZLogger",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AZLogger",
            targets: ["AZLogger"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AZLogger"),
        .testTarget(
            name: "AZLoggerTests",
            dependencies: ["AZLogger"]
        ),
    ]
)

/*
 1. name: 패키지 이름 -> 패키지를 import 할 때의 식별자로 사용
 2. platforms: 패키지가 지원하는 플랫폼과 최소 OS 버전 (.iOS .macOS .tvOS .watchOS .visionOS 등이 있겠네요!)
 3. products: 패키지가 외부에 제공하는 라이브러리(.library) 혹은 실행 가능한 파일(.executable) 정의
 4. dependencies: 패키지에서 사용하는 외부 라이브러리
 5. targets: 소스 코드(.target)와 테스트 타겟(.testTarget)을 포함하는 패키지의 빌드 단위를 의미
   ⚠️ [targets 작성 시 주의 사항] 4.dependencies에서 불러온 라이브러리를 사용하는 경우 target 혹은 testTarget의 파라미터로 dependencies를 Array에 함께 추가해줘야 합니다!
 */
