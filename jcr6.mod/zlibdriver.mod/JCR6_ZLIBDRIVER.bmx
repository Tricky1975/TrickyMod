Rem
        JCR6_ZLIBDRIVER.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.23
End Rem
Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.05.20

End Rem
Rem ***** THIS IS THE ZLIB DRIVER FOR JCR6 *****

	It simply makes use of the BlitzMax adeption of zlib by Mark Subly.
	The original ZLib module is copyrighted by the original authors.
	
	This module is in honor of their work, licensed under the zLIB license.
	
	Oh yeah, this module ONLY works in combination with JCR6 :P
	
End Rem	
Import pub.zlib
Import jcr6.jcr6Main
Import brl.bank
Import brl.Stream
Import tricky_units.MKL_Version

MKL_Version "JCR6 - JCR6_ZLIBDRIVER.bmx","15.09.23"
MKL_Lic     "JCR6 - JCR6_ZLIBDRIVER.bmx","Mozilla Public License 2.0"


Type JCR6_ZLIBDRIVER Extends DRV_Compression
	
	Method compress:TBank(b:TBank)	
	Local dest:TBank = CreateBank(BankSize(b)*2)
	Local i = BankSize(dest)
	compress2 BankBuf(dest),i,BankBuf(b),BankSize(b),9
	Local bt:TStream = CreateBankStream(dest)
	Local ret:TBank = CreateBank(i)
	ReadBank ret,bt,0,i
	CloseStream bt
	Return ret
	End Method

	Method Expand:TBank(b:TBank,truesize)
	Local ret:TBank = CreateBank(truesize)
	Local size = truesize
	uncompress BankBuf(ret),size,BankBuf(b),BankSize(b)
	Return ret
	End Method

	End Type

RegisterCompDriver "zlib",New JCR6_ZLIBDRIVER

