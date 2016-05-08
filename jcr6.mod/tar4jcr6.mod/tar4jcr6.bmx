strict
rem
bbdoc: Module jcr6.tar4jcr6
about:This is a TAR driver for JCR6 and it should enable JCR6 to read data from TAR files. A few notes are in order<ol type=i><li>This module is still in an experimental stage. I would recommend AGAINST using it in your own programs except for testing purposes.</li><li>TAR is originally set up for the Unix system being case sensitive in file names. At the moment this driver was written the support for case sensitive references was deprecated in JCR6, and thus JCR6 will handle TAR case insensitively.</li><li>If a ffilename is encountered twice or even more times, JCR6 will only pick up the last one found and ingore the rest. Sorry, nothing to do about that.</li><li>In the current version of the TAR driver the limit for filenames is 100 characters. This could lead to truncated filenanames I know.</li><li>Only PURE .TAR archives are supported. Packed .TAR archives like .TAR.GZ and others, are not supported, and with the way JCR6 has been setup, support for those kind of archives will even be impossible!</li></ol>
end rem
module jcr6.tar4jcr6
moduleinfo "Name: jcr6.tar4jcr6"
moduleinfo "Author:Jeroen P. Broks"
moduleinfo "&copy; Copyright 2014-2016 Jeroen P. Broks"
moduleinfo "License:Mozilla Public License 2.0"
moduleinfo "Last mod build:8/5/2016"


import "JCR6_TAR4JCR6.bmx"