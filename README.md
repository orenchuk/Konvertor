# Konvertor

Demo (animated)
<img src="konvertor_demo.gif" width="200"/>

Idea: currency conversion iOS app with numbers recognition feature, bring your camera to a price label and find out the price in your local currency.

ML part: 
- text detection using Apple's Vision framework
- numbers recognition with TesseractOCRiOS library (Tesseract got better results comparing to Apple's SwiftOCR)

TODO:
- improve numbers recognition with bad lighting conditions
- impove text detection when other text strings get into frame
- display converted number to screen
