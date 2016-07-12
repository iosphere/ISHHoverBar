# <img src="icon.png" align="center" width="60" height="60"> ISHHoverBar

**A floating `UIToolBar` replacement supporting vertical and horizontal orientation.**
It is designed to hover over your content and plays nicely with autolayout.

`ISHHoverBarOrientationVertical` |  `ISHHoverBarOrientationHorizontal`
:-------------------------:|:-------------------------:
![Screenshot showing a ISHHoverBar in vertical orientation](screenshot_vertical.png) | ![Screenshot showing a ISHHoverBar in horizontal orientation](screenshot_horizontal.png)

The content of the bar is set using `UIBarButtonItems` just as you would configure a `UIToolBar`. 
The bar is backed by a `UIVisualEffectsView` allowing you to select from several styles. 
You can customize most aspects of the view via the *Interface Builder*.

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

## TODO

* [ ] Allow changing the orientation with an animation
* [ ] Allow changing the items with an animation
