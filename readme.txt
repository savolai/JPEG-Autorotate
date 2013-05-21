JPEG-EXIF autorotate 
(version 1.2/2007-07-28) 
Right click menu items for Windows explorer for automatic 
JPEG rotating according to EXIF metadata

http://pilpi.net/software/JPEG-EXIF_autorotate.php
Please consult this URL to read the most up-to-date
version of this readme file.
* * * * * * 


What does it do?
---

According to the EXIF orientation metadata stored in JPEG 
files by digital cameras, JPEG-EXIF autorotate losslessly 
rotates the files which are oriented wrong, usually by 90 
or 270 degrees.

"I own a canon ixus digital camera, which has the ability 
to save the orientation the camera was in while taking the 
picture in tag in the exif headers of the pictures, thanks 
to a gravity sensor. Exif-enabled software can read this 
tag and display the images the right side up, but these 
programs are still uncommon (well, photoshop does, but the 
standard windows image viewer doesn't. The solution I 
prefer is to rotate the images in the correct direction 
once and for all, and then I can forget about using exif 
enabled software" -Thomas Bonfort, the original writer of 
the batch files

The graphical user interface of the application is the 
right-click menu items in Windows. (Clicking any one of 
them will launch jhead with the appropriate command line 
parameters in a console window.) See "Acknowledgements" 
below for further details.

Includes jhead and jpegtran compiled for Windows. See the 
installation directory, for default a folder called 
"JPEG-EXIF_autorotate" in the "Program Files" (or 
equivalent in local language) folder.



Usage
---

Run the installer, follow the instructions. 

As of JPEG-EXIF autorotate 1.2, during installation there 
are two choices with the "Set the timestamp of selected 
files to EXIF date" selection:

- Not selected (default): jpegtran will change the 
timestamp of all the rotated files to the current 
date and time (of rotating).

- Selected: the date *all the selected files, regardless of 
whether they have been rotated or not* will be changed to 
the moment of taking the photo, according to the EXIF 
metadata (jhead parameter -ft).

When the installer is finished you should be able to 
right-click any folder or a file with .jpg or .jpeg 
extension. For folders, you should see the menu items 
"Auto-rotate all JPEGs in folder" and "Auto-rotate all 
JPEGs in folder and in all subfolders". For JPEG files, you 
should see the menu item "Auto-rotate".

Clicking any of the menu items should bring up a console, 
showing the progress of the auto-rotating process and 
telling you to "Press any key to continue . . ." when 
completed.


Acknowledgements
---

Some might consider the optimal solution to not touch the 
file timestamps at all. Unfortunately with jhead this is 
currently not possible.

As of version 1.2, IPTC metadata will be left intact. 
Earlier versions deleted all IPTC metadata due to a problem 
in jhead.

From the jhead documentation: "After rotation, the 
orientation tag of the Exif header is set to '1' (normal 
orientation). The exif thumbnail is also rotated as of 
Jhead version 2.5. Other fields of the Exif header, 
including dimensions are untouched, but the JPEG 
height/width are adjusted. This feature is especially 
useful with newer digital cameras, which set the 
orientation field in the Exif header automatically using a 
built in orientation sensor in the camera."

In some cases, the context menu entries will not be 
directly under the right click menu, but in the submenu 
"Open with..." If you know how to force it directly in the 
context menu, please tell me. http://pilpi.net/contact/

From the jpegtran documentation: "The transpose 
transformation has no restrictions regarding image 
dimensions.  The other transformations operate rather oddly 
if the image dimensions are not a multiple of the iMCU size 
(usually 8 or 16 pixels), because they can only transform 
complete blocks of DCT coefficient data in the desired 
way." ... "For practical use, you may prefer to discard 
any untransformable edge pixels rather than having a 
strange-looking strip along the right and/or bottom edges 
of a transformed image.  To do this, add the -trim switch: 
-trim Drop non-transformable edge blocks."

The transformation is truly lossless - jhead is not using 
the -trim command line argument when calling jpegtran to do 
the actual rotating. With JPEG files coming straight out of 
a digital camera, I understand that the dimensions of the 
image dimensions usually are a multiple of the iMCU size, 
so no strange results should appear. Be careful when 
rotating "custom-sized" JPEGs though.

If you want to remove some menu items you already have 
installed, you need to uninstall the entire JPEG-EXIF 
autorotate via Control Panel -> Add/Remove Programs and 
then reinstall it with only the desired menu options 
selected.


Developer Notes
---

With version 1.2, the installer UI is getting a bit 
crowded. I couldn't be bothered to learn the relatively 
obscure NSIS scripting language well enough to create new 
option pages to move some of the options to. If you know 
how to achieve this or how to make the installer window 
bigger/resizable, please let me know :).

The compiling the installer with NSIS requires the 
InetLoad plugin, see credits below.

The 1.2 installer also uses some files, which will not be 
placed "as is" to the final installation directory
when using the installer: autooperate_ft.bat,
autooperatedir_ft.bat and autooperatedir_recursive_ft.bat
These can be acquired by installing the scripts with 
"Set the timestamp of selected files to EXIF date"
selected, and then renaming the three batch files to
the above names. Of course you will also need the default
versions autooperate.bat, autooperatedir.bat 
and autooperatedir_recursive.bat, which will be 
installed if you leave the above option unselected.
The only difference with these two sets of files is that
the _ft versions have the -ft command line parameter
passed to jhead, in order to set the file dates
according to EXIF metadata.


Feedback 
---

See http://pilpi.net/contact/ 
or send mail to Olli Savolainen:
firstname.lastname (at) pilpi.net


License
---

JPEG-EXIF autorotate is distributed as Public Domain 
(for the .nsi script, this readme and the batch files. 
Use it, edit it, distribute it if you wish, but please 
keep the credits below and contact me (see 
feedback above) if you do (any of these things =), so 
that I can keep track of any developments.

jhead seems to have a PD license too, but I'm not sure of 
jpegtran. 

If during the installation you chose to install the 
regenerate thumbnails feature, you also have 
mogrify.exe, which is a part of ImageMagick.
http://www.imagemagick.org/
ImageMagick is Copyright 1999-2006 ImageMagick 
Studio LLC, a non-profit organization dedicated to 
making software imaging solutions freely available.
See imagemagick_license.txt for the license of
Imagemagick.

Changelog
---

Version 1.2/2007-07-28 (Using NSIS 2.29)
 - Added an option to set the file dates to the date in
EXIF date field, which is supposed to be the photo taking
time/date. 
 - Updated to a jhead post-2.7 head revision copy, to
avoid resetting the IPTC data of rotated files. Thanks to 
Matthias Wandel, the author of jhead, for compiling it for 
me on 2007-07-25.
 - Updated the documentation (this file), added Developer 
Notes.
 - Tested the installer with wine on Ubuntu Linux. It 
works. Not that it would be any use ;).
 - Made JPEG-EXIF autorotate version number visible in 
the installer title bar.

Version 1.1/2006-05-06
 - Updated jhead to version 2.6, which means that now 
JPEG-EXIF autorotate also rotates the thumbnails inside
JPEG images
 - Added a "regenerate thumbnails" feature, to fix the 
thumbnails of images rotated by previous versions of 
jhead or JPEG-EXIF autorotate. This feature uses 
mogrify.exe from Imagemagick. mogrify.exe is over 4 
megabytes, so the installer now downloads it only if
the user selects it for installation.
 - Added the URL of the JPEG-EXIF autorotate website in 
the beginning and in the end of the rotating process.

Version 1.03/2006-01-05
 - Updated the package with the new documentation
 - Added a note in the beginning and in the end of the rotating process

Version 1.02/2004-05-21 
(just documentation - not yet updated in the installation file)
 - Added 'acknowledgements' section
    - noting that jpegtran changes timestamps
    - describing the true lossless rotation that JPEG-EXIF 
autorotate does 
    - and noting that the orientation EXIF tag is set to '1'
(normal orientation) after rotation.

Version 1.01/2004-04-24
 - Cleaned up the NSI file, fixed the name of the application 
to "JPEG-EXIF autorotate", fixed some minor bugs, fixed 
errors in this readme

Version 2004-04-22
 - First release, 1.0


Credits
---

-jhead by Matthias Wandel, 
http://www.sentex.net/~mwandel/jhead/

-jpegtran, http://sylvana.net/jpegcrop/ 
           http://jpegclub.org/jpegcrop/ 

-Registry edits and batch files originally by Thomas Bonfort, 
http://www.inrialpes.fr/movi/people/Bonfort/ (pages removed)

-NSIS, Nullsoft Scriptable Install System, 
http://nsis.sourceforge.net/

-InetLoad plugin for NSIS, 
http://nsis.sourceforge.net/InetLoad_plug-in

-ImageMagick, Copyright 1999-2006 ImageMagick Studio LLC,
http://www.imagemagick.org

-This readme.txt, the installer script for NSIS (also included 
in the installer package) and major modifications to Thomas' 
batch files by Olli Savolainen, http://www.pilpi.net/
