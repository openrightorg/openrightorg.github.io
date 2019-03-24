# ThinSlides

*by Don Mahurin, 2018-03-24*

https://github.com/dmahurin/ThinSlides

## Summary

ThinSlides is a Media gallery and slide show program that resides primarly on the client side.  The only requirement of the server is to serve an index of files.

## Features of ThinGallery.
* Works with trivial web server setup
* Wervice is compiled to a single html file
* Provides full page media slide show, with key and swipe navigation between slides
* Finds and uses associated audio file for images (picture.jpg.mp3), for a narrated slide show experience.
* Lazy recursive folder traversal to show all media in selected folder

ThinSlides was inpired by ThinGallery, and the gallery portion of ThinSlides is derived directly from ThinGallery.

(See: https://github.com/gfwilliams/ThinGallery )

Some additions to ThinGallery code:
* lazy loading of images
* support for video files
* support for audio files

# Setup

* Run 'make' to generate slides.html
* Put `slides.html` in the folder with your images/media
* Alternatively, rename slides.html to index.html, and move images to a subidrectory names 'files'
* Open the location or slides.html in a browser

## Web Server

* python: python -m SimpleHTTPServer 8000
* nodejs: npx http-server
* php: php -S localhost:8000 -file index.php

## Slide show usage

* Press ESC to start slide show or return to gallery/index.
* Click on an image to start slide show at that image
* Use arrows or space to navigate and play.
* You may also use swipe or mouse click to navigate
