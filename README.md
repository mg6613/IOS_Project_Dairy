# IOS_MyDiary (WORKING TITLE)
Our team's project for App store

@copyright : 

## Demo video

# Version
### Swift version
- Swift 5

### Xcode Version
- 12.4


## Add Library

```swift
# For Library import

# For Charts
pod 'Charts'

# For Animation
pod 'lottie-ios' 

# For Password Pattern
pod "CCGestureLock"
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
## Image
![image](https://user-images.githubusercontent.com/46651965/108167033-6d40c280-7138-11eb-81f4-b693d868488b.png)

## Supporting Files

### Images = Image File
- JPG
- PNG

### StoryBoard

### Assets
- Assets.xcassets

## Source

### Models = Bean
### VCs = View Controller's

