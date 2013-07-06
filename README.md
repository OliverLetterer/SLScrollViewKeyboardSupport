# SLScrollViewKeyboardSupport
SLScrollViewKeyboardSupport auto adjusts UIScrollViews contentInset based on the first responder.

## Usage

* Allocate and keep a reference to an instance of `SLScrollViewKeyboardSupport`.
* From now on, the `SLScrollViewKeyboardSupport` instance will observe keyboard notifications and adjusts the scrollViews contentInset if the firstResponder lies in scrollView.

```
- (void)loadView
{
    UIScrollView *scrollView = ...;
    SLScrollViewKeyboardSupport *support = [[SLScrollViewKeyboardSupport alloc] initWithScrollView:scrollView];
}
```

## License
MIT
