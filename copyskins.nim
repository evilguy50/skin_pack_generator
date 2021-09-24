from os import walkFiles, copyFile
from strutils import split

proc copySkins*(projectname: string)=
    for skin in walkFiles("./skins/*.png"):
        var skinname = skin.split("skins\\")[1]
        copyFile(skin, "./output/" & projectname & "/" & skinname)
