photo_app_web
=============

This is a web server part of an android photo app, implemented in ruby on rails.
The mobile client part can be found in photo_app_android.

The android app takes a photo and uploads to this server to store. The image 
file will be stored on dropbox app because heroku doesn't allow to store 
uploaded files.

[check this file](config/application.example.yml) to see how to set up dropbox
settings. Check the dropbox documentation to learn how to create an app on
dropbox.
