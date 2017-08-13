Import BaH.libcurlssl
Import BRL.StandardIO


' This is just some experimental code with libcurl
' In the end it should catch data over the internet and put it in strings, or at least that's the idea.

Rem
bbdoc: Quickly reads an url using Brucye's BaH.libcurlssl module. This was a quick set up to deal with sites only allowing https:// protocls.
returns: The site's content as a string
End Rem
Function QCurl$(url$)
	Local curl:TCurlEasy = TCurlEasy.Create()
	curl.setOptInt(CURLOPT_VERBOSE, 0)
	curl.setOptInt(CURLOPT_FOLLOWLOCATION, 1)
	curl.setwritestring
	curl.setOptString(CURLOPT_URL, url)
	Local res:Int = curl.perform()
	Local ret$=curl.tostring()
	curl.cleanup()
	Return ret
End Function	


