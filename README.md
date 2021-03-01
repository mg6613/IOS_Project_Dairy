# Ssdam(Stroke)


Stroke the mood of the day
> Life is good :smile:   
> But, Sometimes bad  
> So.. Come here when you're lonely  
> We'll Stroke(ssdam) your felling  

     
<details>
    <summary>Table of Contents</summary>

[1.Demo video](#demo-video)    
[2.Logo](#logo)    
[3.Version](#version)    
[4.Folder](#folder)   

</details>
    
@copyright : MInwoo Lee, Mingyu Yoo
    
## Demo video

## Logo
<img src="https://user-images.githubusercontent.com/46651965/108586872-58606b00-7394-11eb-87db-a2efb79a1680.png" width="30%">

# Version
### Swift version
- Swift 5

### Xcode Version
- 12.4


## Add Library

```swift
# For Library import

# For Use a calendar
pod 'FSCalendar'
```

---

# How to add CocoaPods to your project

## Adding CocoaPods to our project at Terminal

```swift
sudo gem install cocoapods
```

## Create a new Project

```swift
# Set folder path
cd ~/Desktop/Paraphrase

# Create Podfile
pod init   
# touch pod = Empty folder
```

## Called Podfile

```swift

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Paraphrase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Paraphrase
	pod 'Library'
end
```

## At the terminal

```swift
# Create folder Pods, Kanna_07.xcworkspace, Podfile.lock 
pod install     
```
--- 
# Folder
### Image
![image](https://user-images.githubusercontent.com/46651965/108167033-6d40c280-7138-11eb-81f4-b693d868488b.png)

### Supporting Files

#### Images = Image File
- PNG

#### StoryBoard

#### Assets
- Assets.xcassets

### Source

#### Models = Data
#### VCs = View Controller's

# Reference
### 앱스토어 등록 방법
https://ithub.tistory.com/95

### Xcode → App store 빌드 방법
https://sansanji.tistory.com/entry/Xcode에서-앱스토어-등록-배포-하기

### 개인정보 처리방침 예시
https://github.com/CSID-DGU/2020-1-OSSP2-SEOULLO-3/edit/master/개인정보처리방침.txt

