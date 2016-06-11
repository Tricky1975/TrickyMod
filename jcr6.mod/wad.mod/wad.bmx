strict
rem
bbdoc: Module jcr6.wad
about:This driver allows you to load WAD files in JCR. WAD stands for "Where's All the Data?" and it was used in DOOM, DOOM II, Ultimate DOOM, DOOM Evilution, DOOM Plutonia, Heretic, Hexen (beyond Heretic), Rise of the Triad and maybe a few other games. JCR6 provides you this reader to allow you to read WAD files into JCR6. This driver was only written for test purposes to test if the modular setup JCR6 uses, works the way it should and since WAD was a simple system, it was the ideal system to test this with. I strongly recommend against using WAD for any serious game projects, as JCR6 is by far more sophisticated than WAD, and I doubt JCR6 is the only system beating WAD for this purpose. ;)
end rem
module jcr6.wad
moduleinfo "Name: jcr6.wad"
moduleinfo "Author:Jeroen P. Broks"
moduleinfo "&copy; Copyright 2014-2016 Jeroen P. Broks"
moduleinfo "License:Mozilla Public License 2.0"
moduleinfo "Last mod build:11/6/2016"


import "JCR6_WAD.bmx"