import strutils
import pixie
import json
import marshal
import os
import strformat

type
    skin = object
        localization_name: string
        geometry: string
        texture: string
        `type`: string
    skinMeta* = object
        author: string
        pack_name: string

proc isSame(img1: Image, img2: Image): bool=
    var imgInfo: (float32, Image) = img1.diff(img2)
    if imgInfo[0] == 0.0:
        return true
    else:
        return false
proc toJson(skin: skin): string=
    result = $$skin

proc newskinJson*(): skinMeta=
    var skinsjson = ""
    echo "Is this a marketplace pack? (y or n)\n"
    var paidAnswer = readLine(stdin)
    var isPaid: bool
    if paidAnswer == "y":
        isPaid = true
    if paidAnswer == "n":
        isPaid = false

    echo "Author name:\n"
    var author = readLine(stdin)

    echo "Pack name:\n"
    var pack_name = readLine(stdin)
    if dirExists(pack_name) == false:
        createDir("./output/" & pack_name)

    var armImage: Image = readImage("./emptyArm.png")
    var stevePos: (int, int) = (54, 20)
    var steveDim: (int, int) = (2, 12)
    var skinNum = 0


    for i in os.walkFiles("./skins/*.png"):
        skinNum.inc(1)
        var newSkin: skin
        var imgNameSplit = i.split("\\", 2)
        var imageName = imgNameSplit[1]
        var skinName = imageName.split(".", 2)[0]
        newSkin.localization_name = skinName
        newSkin.texture = imageName
        if isPaid:
            newSkin.`type` = "paid"
        else:
            newSkin.`type` = "free"
        var tmpImage = subImage(readImage(i), stevePos[0], stevePos[1], steveDim[0], steveDim[1])
        var isAlex = armImage.isSame(tmpImage)
        if isAlex == true:
            newSkin.geometry = "geometry.humanoid.customSlim"
        else:
            newSkin.geometry = "geometry.humanoid.custom"
        var newskinjson = toJson(newSkin)
        if skinNum == 1:
            skinsjson = skinsjson & newskinjson
        else:
            skinsjson = skinsjson & "," & newskinjson

    var jsonStart = """
    {
        $skinrep,
    	"serialize_name": "$pack_name",
    	"localization_name": "$author"
    }
    """
    var skinmap = jsonStart.replace("$skinrep", "\"skins\": [" & skinsjson & "]")
    var skinmap2 = skinmap.replace("$pack_name", pack_name).replace("$author", author)
    var finaljson = pretty(parseJson(skinmap2))
    if os.fileExists(fmt"./output/{pack_name}/skins.json"):
        os.removeFile(fmt"./output/{pack_name}/skins.json")
    writeFile(fmt"./output/{pack_name}/skins.json", $finaljson)
    result = skinMeta(author: author, pack_name: pack_name)