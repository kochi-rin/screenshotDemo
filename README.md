## run UITest command

### Run test
```
xcodebuild -scheme screeshot -project ./screeshot.xcodeproj -derivedDataPath './ScreenshotOutput' -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.3' build test
```

### Export png
```
xcparse screenshots --os --model --test-plan-config ./ScreenshotOutput/Logs/Test/Logs/Test/XXX.xcresult ./ScreenshotOutput/Screenshots
```

## Export attachments
```
xcparse attachments ./ScreenshotOutput/Logs/Test/Logs/Test/XXX.xcresult ./ScreenshotOutput/Attachments --uti public.plain-text public.image
```
