## 📖 목차
🍀 [소개](#-소담) <br>
👨‍💻 [팀원](#-팀원) <br>
✨ [주요기능](#-주요-기능) <br>
🛠 [기술스택](#-기술-스택) <br>
🧨 [트러블슈팅](#-트러블슈팅) <br>

# <img src="https://github.com/user-attachments/assets/5dc1d9ed-487c-403a-9471-4be49dc602b2" width="40"> 소담 (Sodam)

![iOS](https://img.shields.io/badge/iOS-16.6+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![UIKit](https://img.shields.io/badge/UIKit-Programmatic-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Enabled-green.svg)
![MVVM](https://img.shields.io/badge/Architecture-MVVM-green.svg)

> **소담**은 순우리말로 ‘작지만 정겹고 아름답다’는 뜻을 지니며, **소소한 행복을 담다** 라는 의미도 담고 있습니다.<br>
> 매일 소소한 행복을 기록할수록, 귀여운 캐릭터가 함께 성장하는 특별한 **행복 기록 앱! 🌱💛** 입니다.

- 캐릭터 이름을 직접 설정할 수 있어요. 
- 기록 횟수에 따라 점점 성장하는 캐릭터를 키우는 재미가 있어요.
- 사진, 그날 기억을 저장할 수 있어요. 
---

## 📌 팀원  

| 역할  | Leader | SubLeader | Member | Member | Member |
|:----:|:------:|:---:|:------:|:------:|:----:|
| 이름  | [@김손겸](https://github.com/gyeomsony) | [@전지혜](https://github.com/emilyj4482) | [@박민석](https://github.com/maxminseok) | [@박시연](https://github.com/sy0201) | [@박진홍](https://github.com/jbnong07) |
| 담당  | 프로젝트 관리 | 데이터 모델링, QC | 카메라, 테스트 | 로컬 알림, 테스트 | 캐릭터 디자인, QC |

---

## 📌 주요 기능  

✅ **기록 기능**  
- 소소한 행복을 간직할 수 있도록 특별한 순간을 기록할 수 있어요.

✅ **사진 기능**  
- 직접 촬영한 사진을 추가하여 소중한 순간을 기록할 수 있어요.
- 앨범에 있는 사진을 선택해 행복한 기억을 더욱 특별하게 남길 수 있어요.

✅ **알림 기능**  
- UserDefaults를 이용해 원하는 시간에 행복 기록 알림을 받을 수 있어요. ⏰💛

✅ **Core Data**  
- Core Data를 활용해 지난 행복한 기록을 저장하고 확인할 수 있어요.

✅ **커스텀 폰트**

- 캐릭터와 어울리도록 커스텀 폰트를 적용하여 더욱 귀여운 느낌을 줄 수 있어요.

---

## 📌 기술 스택  

| 분류 | 사용 기술 |
| ---- | ---- |
| **언어** | Swift 5.0.0 |
| **프레임워크** | UIKit, SwiftUI |
| **아키텍처** | MVVM |
| **데이터 저장소** | Core Data, UserDefaults, fileManager |
| **디자인 시스템** | AutoLayout (SnapKit) |
| **의존성 관리** | Swift Package Manager (SPM) |
| **버전 관리** | GitHub Projects |

---

## 📌 트러블슈팅

<details>
<summary>1️⃣ 이미지 저장 및 최적화 문제 해결</summary>
<div markdown="1">
<br>
🔄 문제 상황
행복 기록 작성 시 촬영된 이미지가 저장될 때 크기 및 품질 조절이 필요했습니다.
리스트에서 섬네일을 사용할 때 원본 이미지 크기가 커서 로딩 지연 문제가 발생했고,
반대로 이미지 품질을 낮추면 상세 화면에서 해상도가 낮아지는 문제가 있었습니다.
🎯 해결 방안
✅ 1. 이미지 저장용 크기와 섬네일용 이미지를 따로 저장
기본 저장 크기 450px로 조정 (너무 크거나, 작지 않도록 기본 크기 설정)

```swift
/// 이미지를 저장하는 함수 : 리사이징 목표치 기본값 450
func saveImage(_ image: UIImage, with imagePath: String, size: CGFloat = 450) {
    /// 1.  이미지 리사이징
    let resizedImage = resizeImage(image, resizeFloat: size)
        
    /// 2. FileManager로 기기에 저장
    saveImageAsFile(image: resizedImage, imagePath: imagePath)
}
```
✅ 2. 리스트에서 표시할 썸네일 최적화
썸네일 크기를 150px로 줄여 리스트에서 빠르게 로드
비율을 유지하면서 가운데 영역을 crop하여 작은 이미지여도 깨지지않고 유지할 수 있도록 조정
```swift
    /// 썸네일 이미지 만드는 함수 : 리사이징 목표치 기본값 150
    func getThumbnailImage(with imagePath: String, size: CGFloat = 150) -> UIImage {
        guard let image = getImage(with: imagePath) else {
            return UIImage(resource: .kingdam3)
        }
        
        /// 이미지 크기
        let width = image.size.width
        let height = image.size.height
        
        let scale = size / min(width, height)
        
        /// 이미지 비율 유지한 채 150 크기로 줄임
        let newWidth = width * scale
        let newHeight = height * scale
        
        /// 가운데 부분을 crop 하기 위해 긴 부분만큼 이동시킬 offset 계산
        let xOffset = (newWidth - size) / -2.0
        let yOffset = (newHeight - size) / -2.0
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        
        let thumbnail = renderer.image { _ in
            image.draw(in: CGRect(x: xOffset, y: yOffset, width: newWidth, height: newHeight))
        }
        
        return thumbnail
    }
```
최종 개선 결과
✅ 저장 시 원본 크기를 적절하게 조절하여 저장 공간 최적화
✅ 섬네일 이미지를 별도로 생성해 리스트 로딩 속도 개선
✅ 이미지 삭제 기능 추가로 불필요한 데이터 관리 가능

📌 추가 고려점:
캐싱 적용 시 NSCache 활용 검토
UIImage의 압축률을 추가 조절하여 더 최적화
<br>
</div>
</details>

<details>
<summary>2️⃣ 카메라 실행시 작성된 내용이 지워지는 문제</summary>
<div markdown="2">
<br>
https://www.notion.so/teamsparta/dfb08183f5214e43a7409b81c64be026
<br>
</div>
</details>

