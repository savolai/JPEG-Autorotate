@SET temppath=%PATH%
@SET PATH=%PATH%;%3
@echo JPEG-EXIF autorotate - jpegrotate.com
@echo Rotating images in the selected directory and subdirectories - please wait. On some systems startup may even take a couple of minutes.
@echo.
%1 %4 -ft %2\**\*.jpg
@SET PATH=%temppath%
@echo.
@echo ----------------------
@echo JPEG-EXIF autorotate - jpegrotate.com
@echo Rotating finished. Please press any key to close the window.
@echo.
@pause
