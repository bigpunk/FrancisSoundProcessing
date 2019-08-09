# FrancisSoundProcessing
Basic iOS app to test out AudioKit sound analysis

To get started make sure you have cocoapods on your machine.  Then run `pod install`
For now you must delete the Pods/Header dir to working around an AudioKit/Cocoapods non-modular 
header issue.  (ex) rm -rf  Pods/Headers.  

NOTE: you need ruby to do this.  Use: https://githubto do this.  Use: https://github.com/rbenv/rbenv 

Now open the FrancisSoundProcessing.xcworkspace in xcode.

TROUBLESHOOTING:
-) If you run into "Module compiled with Swift x.x.x can't be imported by Swift y.y.y compiler", try going to https://audiokit.io/downloads/ to find the lastest version of Audio kit, update the Podfile with that version and then run: pod install --repo-update
