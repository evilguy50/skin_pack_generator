import uuids
import os
from strutils import replace

var strmanifest = """{
	"format_version": 2,
	"header": {
		"name": "$packName",
		"uuid": "$uuid1",
		"version": [
			1,
			0,
			0
		]
	},
	"modules": [
		{
			"type": "skin_pack",
			"uuid": "$uuid2",
			"version": [
				1,
				0,
				0
			]
		}
	]
}
"""

proc newManifest*(packName: string)=
    var uuid1 = $genUUID()
    var uuid2 = $genUUID()
    var manifest = strmanifest.replace("$packName", packName).replace("$uuid1", uuid1).replace("$uuid2", uuid2)
    if os.fileExists("./output/" & packName & "/manifest.json") == false:
        writeFile("./output/" & packName & "/manifest.json", manifest)