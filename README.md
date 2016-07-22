JPEG-Autorotate
===============

Adds Windows right click menu items to folders and photo files (.jpg, .jpeg) for lossless rotation of JPEG files according to EXIF orientation metadata.
See http://www.pilpi.net/software/JPEG-EXIF_autorotate.php

(Developer details below added July 22, 2016)

All JPEG autorotate literally does is call jhead with the path given by explorer and a couple of parameters. The entire command line window that opens is called in accordance with registry keys like this

WriteRegStr HKEY_CLASSES_ROOT "Folder\shell\JPEG-EXIF_autorotate_folder\command" "" '"$INSTDIR\autooperatedir.bat" "$INSTDIR\jhead" "%l" "$INSTDIR" -autorot $setPauseAfterDone'

(https://github.com/savolai/JPEG-Autorotate/blob/master/autorotate.nsi )

Which calls the bat wile
( https://github.com/savolai/JPEG-Autorotate/blob/master/autooperatedir.bat (

which pretty much only calls jhead and nothing else.

%1 %4 %2\*.jpg
%1 = $INSTDIR\jhead
%4 = -autorot
%2 = directory path

If you want me to add any parameters of jhead, I can add parameters of course. Or if you can send a patch on github, that would be great. I don't really have much time to work on JPEG autorotate and would love someone to take its maintenance over on github.

http://www.sentex.net/~mwandel/jhead/usage.html
