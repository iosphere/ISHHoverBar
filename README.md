# <img src="icon.png" align="center" width="60" height="60"> ISHHoverBar

[![Travis Build Status](https://travis-ci.org/iosphere/ISHHoverBar.svg?branch=master)](http://travis-ci.org/iosphere/ISHHoverBar)&nbsp;
[![Version](http://cocoapod-badges.herokuapp.com/v/ISHHoverBar/badge.png)](http://cocoadocs.org/docsets/ISHHoverBar)

**A floating `UIToolBar` replacement as seen in the iOS10 Maps app, supporting both vertical and horizontal orientation.**  

It is designed to hover above your content and it plays nicely with auto layout.

`ISHHoverBarOrientationVertical` |  `ISHHoverBarOrientationHorizontal`
:-------------------------:|:-------------------------:
![Screenshot showing a ISHHoverBar in vertical orientation](screenshot_vertical.png) | ![Screenshot showing a ISHHoverBar in horizontal orientation](screenshot_horizontal.png)

The content of the bar is set using `UIBarButtonItem`s, just as you would configure a `UIToolBar`. 
The bar is backed by a `UIVisualEffectsView` allowing you to choose from several styles. 
You can customize most aspects of the view via *Interface Builder*.

## Basic usage

### Setting the bar's contents

`ISHHoverBar` is populated similarly to a `UIToolbar` using instances of 
`UIBarButtonItem`. The content can be changed at any time by setting the `items` property.
The layout and `intrinsicContentSize` will automatically be updated.

A few limitation apply: `ISHHoverBar` only supports instances of `UIBarButtonItem` that 
have a `title`, `image`, or `customView` (subclass of `UIControl`). Most importantly, 
`UIBarButtonItem` instances created using a `UIBarButtonSystemItem` are not supported as 
access to the underlying content is restricted to private APIs.

### Appearance and orientation

`ISHHoverBar` supports vertical and horizontal layouts. The orientation can be changed 
at any time by setting the `orientation` property (default is vertical). Use auto layout 
to position the bar in your view hierarchy.

The following aspects of `ISHHoverBar` can be changed via code or *Interface Builder*:

* Shadow: 
  * `shadowColor`
  * `shadowOpacity`
  * `shadowRadius`
* Corner radius: `cornerRadius`
* Border (also applied to separators between items):
  * `borderWidth`
  * `borderColor`
  
## General info

`ISHHoverBar` is written in **Objective-C** to allow easy integration into any iOS project 
and has fully documented headers. It is annotated for easy integration into 
*Swift* code bases.

The `ISHHoverBar` class and sample app have a **Deployment Target** of **iOS 8**.

## Integration into your project

### Include files directly

Currently the project relies on a single implementation file and its header. 
You can include them directly into your project:

* `ISHHoverBar/ISHHoverBar.h/m`

### CocoaPods

You can use CocoaPods to install `ISHHoverBar` as a static library:

```ruby
target 'MyApp' do
  pod 'ISHHoverBar'
end
```

See the [official website](https://cocoapods.org/#get_started) to get started with
CocoaPods.

`ISHHoverBar` can also be installed as a framework:

```ruby
target 'MyApp' do
  use_frameworks!
  pod 'ISHHoverBar'
end
```

## TODO

* [ ] Allow changing the orientation with an animation
* [ ] Allow changing the items with an animation
