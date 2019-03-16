; JPEG Autorotate installation script for NSIS. Will copy 
; the needed files to the directory the user selects
; and creates the necessary registry entries for the
; right-click menu items and for unistallation.

;Include Modern UI

  !include "MUI.nsh"
  !addplugindir "nsis-plugins\inetc\Plugins"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

; The name of the installer
Name "JPEG Autorotate 2.1"
BrandingText "jpegrotate.com - Scanrobot Oy / Olli Savolainen"
;XPStyle on
	
; The file to write
OutFile "installer\JPEG_Autorotate.exe"

; The default installation directory
InstallDir $PROGRAMFILES\JPEG-EXIF_autorotate

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\JPEG-EXIF_autorotate" "Install_Dir"

;--------------------------------
; Pages
;--------------------------------

  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;Page components
;Page directory
;Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------
Function setPauseAfterDone 
Var /GLOBAL setPauseAfterDone 
StrCpy $setPauseAfterDone "-pauseAfterDone" 
FunctionEnd 

; The stuff to install
Section "!JPEG Autorotate program files (required)" SecRotate

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put files there
  File "jhead.exe"
  File "jpegtran.exe"
  File "style.css"
  File "autooperatedir.bat"
  File "autooperate.bat"
  File "autorotate.nsi"
  File "autooperatedir_recursive.bat"
  ;File "mogrify.exe"
  File "imagemagick_license.txt"

  ; Autorotate: Create the Folder context menus
  ; Write the context menu registry keys

  ; Todo: is .jfif a valid extension which could be rotated? any other extensions?
  
  ; Autorotate: Find out the JPEG file registry keys in which to write 
  ReadRegStr $0 HKEY_CLASSES_ROOT .jpg ""
  ReadRegStr $1 HKEY_CLASSES_ROOT .jpeg ""
  ReadRegStr $2 HKEY_CLASSES_ROOT .jpe ""

  ReadRegStr $3 HKEY_CLASSES_ROOT SystemFileAssociations\.jpg ""
  ReadRegStr $4 HKEY_CLASSES_ROOT SystemFileAssociations\.jpeg ""
  ReadRegStr $5 HKEY_CLASSES_ROOT SystemFileAssociations\.jpe ""

  ; Autorotate: Store the registry keys where we wrote for uninstall
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpg $0
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpeg $1
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpe $2
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpg2 $3
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpeg2 $4
  WriteINIStr $INSTDIR\uninstall.ini registry_keys jpe2 $5

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\JPEG-EXIF_autorotate "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows (_ removed)
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JPEG-EXIF_autorotate" "DisplayName" "JPEG-EXIF_autorotate"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JPEG-EXIF_autorotate" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JPEG-EXIF_autorotate" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JPEG-EXIF_autorotate" "NoRepair" 1
  WriteUninstaller "uninstall.exe"



SectionEnd
;--------------------------------



; Optional section (can be disabled by the user)
Section "Wait for user confirmation after operation completed" SecPauseAfterDone
	Call setPauseAfterDone
SectionEnd

;--------------------------------

;--------------------------------
;--------------------------------

SectionGroup /e "Folder menu items"

;--------------------------------

; Optional section (can be disabled by the user)
Section "Rotate in folder and subfolders" SecFolderRecursive

  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder_recursive" "" "Autorotate all JPEGs in folder and in all subfolders"
  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder_recursive\command" "" '"$INSTDIR\autooperatedir_recursive.bat" "$INSTDIR\jhead" "%l" "$INSTDIR" -autorot $setPauseAfterDone'
  
SectionEnd

;--------------------------------

; Optional section (can be disabled by the user)
Section "Rotate (not in subfolders)" SecFolder

  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder" "" "Autorotate all JPEGs in folder"
  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder\command" "" '"$INSTDIR\autooperatedir.bat" "$INSTDIR\jhead" "%l" "$INSTDIR" -autorot $setPauseAfterDone'
  
SectionEnd
SectionGroupEnd

;--------------------------------
;--------------------------------

SectionGroup /e "JPEG file menu items"

; Optional section (can be disabled by the user)
Section "Autorotate" SecFileAutorotate

  ; Create the JPEG context menus

  ;for .jpg
  WriteRegStr HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'

  ;for .jpeg
  WriteRegStr HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'

  ;for .jpe
  WriteRegStr HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'

  ;for image
  WriteRegStr HKEY_CLASSES_ROOT "SystemFileAssociations\Image\shell\JPEG-EXIF_autorotate" "" "Autorotate"
  WriteRegStr  HKEY_CLASSES_ROOT "SystemFileAssociations\Image\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -autorot $setPauseAfterDone'

  
SectionEnd

;--------------------------------


; Optional section (disabled by default: /o)
;Section /o "Strip all metadata" SecFilepurejpg


  ;Create the JPEG context menus

  ;for .jpg
 ; WriteRegStr HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_autorotate" "" "Strip metadata"
;  WriteRegStr  HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -purejpg'

  ;for .jpeg
 ; WriteRegStr HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_autorotate" "" "Strip metadata"
 ; WriteRegStr  HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_autorotate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -purejpg'

;SectionEnd
SectionGroupEnd

;--------------------------------

; Optional section (disabled by default: /o)
Section /o "Set the timestamp of selected files to EXIF date" SecFiletstampset
  Delete $INSTDIR\autooperate.bat
  Delete $INSTDIR\autooperatedir.bat
  Delete $INSTDIR\autooperatedir_recursive.bat
  File autooperate_ft.bat
  File autooperatedir_ft.bat
  File autooperatedir_recursive_ft.bat
  Rename autooperate_ft.bat autooperate.bat
  Rename autooperatedir_ft.bat autooperatedir.bat
  Rename autooperatedir_recursive_ft.bat autooperatedir_recursive.bat 
SectionEnd
;--------------------------------

; Optional section (disabled by default: /o)
Section /o "Regenerate thumbnails (1.4 MB download)" SecFilergtthumb
  AddSize 5900
  Delete $INSTDIR\mogrify.exe
  Delete $INSTDIR\imagemagick_license.txt
  inetc::get  /BANNER "ImageMagick mogrify.exe download in progress..." \
    "http://pilpi.net/software/mogrify_sfx.exe" \
    "$INSTDIR\mogrify_sfx.exe"
    Pop $0
    StrCmp $0 "OK" dlok
    MessageBox MB_OK|MB_ICONEXCLAMATION "Download Error, click OK to abort installation" /SD IDOK
    Abort
  dlok:
    nsExec::ExecToLog "$INSTDIR\mogrify_sfx.exe" /TIMEOUT=5000
    Delete $INSTDIR\mogrify_sfx.exe


  ; Autorotate: Create the JPEG context menus

  ;for .jpg
  WriteRegStr HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'

  ;for .jpeg
  WriteRegStr HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'

   ;for .jpe
  WriteRegStr HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'
  WriteRegStr HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_regenerate" "" "Regenerate thumbnail(s)"
  WriteRegStr HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_regenerate\command" "" '"$INSTDIR\autooperate.bat" "$INSTDIR\jhead" "%1" "$INSTDIR" -rgt $setPauseAfterDone'

  ;for folders and subfolders
  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_regenerate_folder_recursive" "" "Regenerate thumbnails of JPEGs in folder and in all subfolders"
  WriteRegStr HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_regenerate_folder_recursive\command" "" '"$INSTDIR\autooperatedir_recursive.bat" "$INSTDIR\jhead" "%l" "$INSTDIR" -rgt $setPauseAfterDone'


SectionEnd


;--------------------------------

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts" SecShortcuts

  CreateDirectory "$SMPROGRAMS\JPEG Autorotate"
  CreateShortCut "$SMPROGRAMS\JPEG Autorotate\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\JPEG Autorotate\Program folder.lnk" "$INSTDIR"
  CreateShortCut "$SMPROGRAMS\JPEG Autorotate\ImageMagick License.lnk" "$INSTDIR\imagemagick_license.txt"

SectionEnd


;--------------------------------


;Descriptions

  ;Language strings
  LangString DESC_SecRotate ${LANG_ENGLISH} "Install program files (required)"
  LangString DESC_SecFolderRecursive ${LANG_ENGLISH} "Folder menu item: Autorotate all JPEGs in folder and in all subfolders"
  LangString DESC_SecFolder ${LANG_ENGLISH} "Folder menu item: Autorotate all JPEGs in folder"
  LangString DESC_SecFileAutorotate ${LANG_ENGLISH} "File menu item: Autorotate (selected files)"
;  LangString DESC_SecFilepurejpg ${LANG_ENGLISH} "File menu item: Remove metadata (-purejpg command line parameter)"
  LangString DESC_SecFilergtthumb ${LANG_ENGLISH} "File menu item: Regenerate thumbnail in selected file(s). Useful for users of old jhead/JPEG-EXIF autorotate (jhead -rgt). Will download 1.4 MB, requires internet connection!"
  LangString DESC_SecFiletstampset ${LANG_ENGLISH} "Selected: file timestamps of *all selected* files are changed to EXIF date. / Not selected: timestamps of *rotated* files changed to rotating date. (See readme.txt)"
  LangString DESC_SecShortcuts ${LANG_ENGLISH} "Add shortcuts to the Start menu to the uninstall application and the program folder"
  LangString DESC_SecPauseAfterDone ${LANG_ENGLISH} "Wait for user confirmation after operation completed"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecRotate} $(DESC_SecRotate)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFolderRecursive} $(DESC_SecFolderRecursive)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFolder} $(DESC_SecFolder)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFileAutorotate} $(DESC_SecFileAutorotate)
    ;!insertmacro MUI_DESCRIPTION_TEXT ${SecFilepurejpg} $(DESC_SecFilepurejpg)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFilergtthumb} $(DESC_SecFilergtthumb)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFiletstampset} $(DESC_SecFiletstampset)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} $(DESC_SecShortcuts)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPauseAfterDone} $(DESC_SecPauseAfterDone)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys AUTOROTATE: the context menu registry keys
  ReadINIStr $0 $INSTDIR\uninstall.ini registry_keys jpg
  ReadINIStr $1 $INSTDIR\uninstall.ini registry_keys jpeg
  ReadINIStr $2 $INSTDIR\uninstall.ini registry_keys jpe
  ReadINIStr $3 $INSTDIR\uninstall.ini registry_keys jpg2
  ReadINIStr $4 $INSTDIR\uninstall.ini registry_keys jpeg2
  ReadINIStr $5 $INSTDIR\uninstall.ini registry_keys jpe2
  DeleteRegKey HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$0\shell\JPEG-EXIF_regenerate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$1\shell\JPEG-EXIF_regenerate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$3\shell\JPEG-EXIF_regenerate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$4\shell\JPEG-EXIF_regenerate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_autorotate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$2\shell\JPEG-EXIF_regenerate" "" 
  DeleteRegKey HKEY_CLASSES_ROOT "$5\shell\JPEG-EXIF_regenerate" "" 

  DeleteRegKey HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder" 
  DeleteRegKey HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_autorotate_folder_recursive" 
  DeleteRegKey HKEY_CLASSES_ROOT "Directory\shell\JPEG-EXIF_regenerate_folder_recursive" 

    ;for image
  DeleteRegKey HKEY_CLASSES_ROOT "SystemFileAssociations\Image\shell\JPEG-EXIF_autorotate" "" 
  
  ; Remove registry keys (first _ removed)
  
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\JPEG-EXIF_autorotate"
  DeleteRegKey HKLM SOFTWARE\JPEG-EXIF_autorotate

  ; Remove files and uninstaller
  Delete $INSTDIR\uninstall.ini
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\jhead.exe
  Delete $INSTDIR\jpegtran.exe
  Delete $INSTDIR\autooperatedir.bat
  Delete $INSTDIR\autooperate.bat
  Delete $INSTDIR\autorotate.nsi
  Delete $INSTDIR\autooperatedir_ft.bat
  Delete $INSTDIR\autooperate_ft.bat
  Delete $INSTDIR\autorotate_ft.nsi
  Delete $INSTDIR\style.css
  Delete $INSTDIR\autorotatedir_recursive.bat
  Delete $INSTDIR\autooperatedir_recursive.bat
  Delete $INSTDIR\mogrify_sfx.exe
  Delete $INSTDIR\mogrify.exe
  Delete $INSTDIR\imagemagick_license.txt

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\JPEG Autorotate\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\JPEG Autorotate"
  RMDir "$INSTDIR"

SectionEnd
