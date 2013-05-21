@SET temppath=%PATH%
@SET PATH=%PATH%;%3
@echo JPEG-EXIF autorotate - http://pilpi.net/software/JPEG-EXIF_autorotate.php
@echo Rotating the selected image(s) - please wait. On some systems startup may even take a couple of minutes.
@echo.
%1 %4 -ft %2
@SET PATH=%temppath%
@echo.
@echo ----------------------
@echo JPEG-EXIF autorotate - http://pilpi.net/software/JPEG-EXIF_autorotate.php
@echo Rotating finished. Please press any key to close the window.
@echo.
@pause
