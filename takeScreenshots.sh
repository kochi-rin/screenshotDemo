#!/bin/bash

# The Xcode project to create screenshots for
projectName="./screenshot.xcodeproj"

# The scheme to run tests for
schemeName="screenshot"


# All the simulators we want to screenshot
# Copy/Paste new names from Xcode's
# "Devices and Simulators" window
# or from `xcrun simctl list`.
simulators=(
    "iPhone 11 Pro"
)

# All the languages we want to screenshot (ISO 3166-1 codes)
languages=(
    "en"
)

# All the appearances we want to screenshot
# (options are "light" and "dark")
appearances=(
    "light"
)

#Save the test result
testResultFolder="./ScreenshotOutput/Test"

# Save final screenshots into this folder (it will be created)
targetFolder="./ScreenshotOutput/Screenshots"


## No need to edit anything beyond this point


for simulator in "${simulators[@]}"
do
    for language in "${languages[@]}"
    do
        for appearance in "${appearances[@]}"
        do
            rm -rf $testResultFolder
            echo "📲  Building and Running for $simulator in $language"

            # Boot up the new simulator and set it to 
            # the correct appearance
            xcrun simctl boot "$simulator"
            xcrun simctl ui "$simulator" appearance $appearance

            # Build and Test
            xcodebuild -testLanguage $language -scheme $schemeName -project $projectName -derivedDataPath $testResultFolder -destination "platform=iOS Simulator,name=$simulator" build test
            echo "🖼  Collecting Results..."
            mkdir -p "$targetFolder/$simulator/$language/$appearance"
            find "$testResultFolder/Logs/Test" -maxdepth 1 -type d -exec xcparse screenshots {} "$targetFolder/$simulator/$language/$appearance" \;
        done
    done

    echo "✅  Done"
done

