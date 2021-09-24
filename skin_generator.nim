include "skin_json.nim"
include "copyskins.nim"
include "manifest.nim"
include "lang.nim"

var skinpack: skinMeta = newskinJson()
copySkins(skinpack.pack_name)
newManifest(skinpack.pack_name)
genLang(skinpack.pack_name, skinpack.author)
echo "\nMETA INFO: " & skinpack.author & " " & skinpack.pack_name