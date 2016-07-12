# <img src="icon.png" align="center" width="60" height="60"> ISHHoverBar

[![Travis Build Status](https://travis-ci.org/iosphere/ISHHoverBar.svg?branch=master)](http://travis-ci.org/iosphere/ISHHoverBar)&nbsp;
[![Version](http://cocoapod-badges.herokuapp.com/v/ISHHoverBar/badge.png)](http://cocoadocs.org/docsets/ISHHoverBar)

**A floating `UIToolBar` replacement supporting vertical and horizontal orientation.**
It is designed to hover over your content and plays nicely with auto layout.

`ISHHoverBarOrientationVertical` |  `ISHHoverBarOrientationHorizontal`
:-------------------------:|:-------------------------:
![Screenshot showing a ISHHoverBar in vertical orientation](screenshot_vertical.png) | ![Screenshot showing a ISHHoverBar in horizontal orientation](screenshot_horizontal.png)

The content of the bar is set using `UIBarButtonItems` just as you would configure a `UIToolBar`. 
The bar is backed by a `UIVisualEffectsView` allowing you to select from several styles. 
You can customize most aspects of the view via *Interface Builder*.

## General info

The framework is written in **Objective-C** to allow easy integration into any iOS project 
and has fully documented headers. `ISHHoverBar` is annotated for easy integration into 
*Swift* code bases.

The `ISHHoverBar` class and sample app have a **Deployment Target** of **iOS8**.

## Integration into your project

### Include files directly

Currently the project relies on a single implementation file and its header. 
You can include them directly into your project:

* `ISHHoverBar/ISHHoverBar.h/m`

### CocoaPods

You can use CocoaPods to install ISHHoverBar as a static library:

```ruby
target 'MyApp' do
pod 'ISHHoverBar'
end
```

See the [official website](https://cocoapods.org/#get_started) to get started with
CocoaPods.

`ISHHoverBar` can also be installed as a framework through CocoaPods:

```ruby
target 'MyApp' do
use_frameworks!
pod 'ISHHoverBar'
end
```

It requires at least iOS 8 at runtime and can be imported as a module.

## TODO

* [ ] Allow changing the orientation with an animation
* [ ] Allow changing the items with an animation
