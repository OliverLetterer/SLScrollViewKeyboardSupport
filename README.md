# SLScrollViewKeyboardSupport
SLScrollViewKeyboardSupport auto adjusts UIScrollViews contentInset based on the first responder.

## Usage
```
- (void)loadView
{
	SLScrollViewKeyboardSupport *support = [[SLScrollViewKeyboardSupport alloc] initWithScrollView:...];
	// store `support` somewhere
}
```

## License
MIT
