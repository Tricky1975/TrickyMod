Rem
/* 
  HSVRGB

  Copyright (C) 2015 Jeroen P. Broks (based on code by Leszek S)

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/



Version: 15.07.18

End Rem
Strict

Rem

	In a subfolder you can find the original C++ code this blitzmax mode is based upon.
	It's ported to BlitzMax by Jeroen P. Broks.
	
	I released it in the zLib License
	
	I'm not quite certain about this code's reliability. I'm still trying to sort this out. :)
	
End Rem

Import tricky_units.MKL_Version

MKL_Version "Units - HSVRGB/HSVRGB.bmx","15.07.18"
MKL_Lic     "Units - HSVRGB/HSVRGB.bmx","zLIB License"


Rem
bbdoc: This type can be used to store the rgb color
End Rem
Type RgbColor
    Field r;
    Field g;
    Field b;
    EndType

Rem
bbdoc: This type can be used to store the hsv color
End Rem
Type HsvColor
    Field h;
    Field s;
    Field v;
    EndType

Rem
bbdoc: HSV to RGB converter
returns: an RgbColor with the RGB values from HSV
End Rem
Function HsvToRgb:RgbColor(hsv:HsvColor)
    Local rgb:RgbColor;
    Local region, remainder, p, q, t;

    If (hsv.s = 0)
        rgb.r = hsv.v;
        rgb.g = hsv.v;
        rgb.b = hsv.v;
        Return rgb;
        EndIf

    region = hsv.h / 43;
    remainder = (hsv.h - (region * 43)) * 6; 

    p = (hsv.v * (255 - hsv.s)) Shr 8;
    q = (hsv.v * (255 - ((hsv.s * remainder) Shr 8))) Shr 8;
    t = (hsv.v * (255 - ((hsv.s * (255 - remainder)) Shr 8))) Shr 8;

    Select region
        Case 0
            rgb.r = hsv.v; rgb.g = t; rgb.b = p;
            'break;
        Case 1
            rgb.r = q; rgb.g = hsv.v; rgb.b = p;
            'break;
        Case 2
            rgb.r = p; rgb.g = hsv.v; rgb.b = t;
            'break;
        Case 3
            rgb.r = p; rgb.g = q; rgb.b = hsv.v;
            'break;
        Case 4
            rgb.r = t; rgb.g = p; rgb.b = hsv.v;
            'break;
        Default
            rgb.r = hsv.v; rgb.g = p; rgb.b = q;
            'break;
       End Select
    Return rgb;
End Function

Private
Function Evaluate(logic,ex1,ex2) ' As BlitzMax has no native support for "c ? a : b" expressions as used in C++ this function will have to suffice.
If logic Return ex1 Else Return ex2
End Function
Public

Rem
bbdoc: RGB to SH converter
returns: an HsvColor with the HSV values from RGB
End Rem

Function RgbToHsv:hsvcolor(rgb:RgbColor)
'{
    Local hsv:HsvColor;
    Local rgbMin, rgbMax;

    'rgbMin = rgb.r < rgb.g ? (rgb.r < rgb.b ? rgb.r : rgb.b) : (rgb.g < rgb.b ? rgb.g : rgb.b);
    'rgbMax = rgb.r > rgb.g ? (rgb.r > rgb.b ? rgb.r : rgb.b) : (rgb.g > rgb.b ? rgb.g : rgb.b);
    rgbmin = Evaluate(rgb.r < rgb.g, Evaluate(rgb.r < rgb.b , rgb.r , rgb.b),evaluate(rgb.g < rgb.b , rgb.g , rgb.b))
    rgbMax = evaluate(rgb.r > rgb.g, Evaluate(rgb.r > rgb.b , rgb.r , rgb.b),evaluate(rgb.g > rgb.b , rgb.g , rgb.b))

    hsv.v = rgbMax;
    If (hsv.v = 0)
        hsv.h = 0;
        hsv.s = 0;
        Return hsv;
        EndIf

    hsv.s = 255 * Long(rgbMax - rgbMin) / hsv.v;
    If (hsv.s = 0)
        hsv.h = 0;
        Return hsv;
        EndIf

    If (rgbMax = rgb.r)
        hsv.h = 0 + 43 * (rgb.g - rgb.b) / (rgbMax - rgbMin);
    Else If (rgbMax = rgb.g)
        hsv.h = 85 + 43 * (rgb.b - rgb.r) / (rgbMax - rgbMin);
    Else
        hsv.h = 171 + 43 * (rgb.r - rgb.g) / (rgbMax - rgbMin);
        EndIf

    Return hsv;
End Function
