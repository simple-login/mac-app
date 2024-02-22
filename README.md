macOS client for SimpleLogin with Safari [extension](https://github.com/simple-login/browser-extension) support

# How to debug
1. Reveal the extension in Safari
2. Drag and drop the top left logo into a chromium browser to retrieve the URI to that logo

```
safari-web-extension://3FAD6DAE-0632-4DE6-ACBA-13C69C5D62B5/images/horizontal-logo.svg
```

3. Replace the path to the logo with `popup/popup.html` and open the new URI in a Safari tab

```
safari-web-extension://3FAD6DAE-0632-4DE6-ACBA-13C69C5D62B5/popup/popup.html
```

# License
See [LICENSE](LICENSE) file