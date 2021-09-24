from os import walkFiles, direxists, fileExists, createdir
from strutils import replace

proc genLang*(packName: string, author: string)=
    if dirExists("./output/" & packName & "/texts") == false:
        createDir("./output/" & packName & "/texts")
    for i in walkFiles("./output/" & packName & "/*.png"):
        var skinName = i.replace(".png", "")
        skinName = skinName.replace("./output/" & packName & "/", "")
        var skinLang = "skin." & author & "." & skinName & "=" & skinName
        if fileExists("./output/" & packName & "/texts/" & "en_US.lang") == false:
            writeFile("./output/" & packName & "/texts/" & "en_US.lang", skinLang)
        else:
            var enLang = open("./output/" & packName & "/texts/" & "en_US.lang", fmappend)
            enLang.write("\n")
            enLang.write(skinLang)
            enLang.close()
    var enEnd = open("./output/" & packName & "/texts/" & "en_US.lang", fmappend)
    enEnd.write("\n")
    enEnd.write("skinpack." & author & "=" & packName)
    enEnd.close()
    

