Rem
                  BetterBlitz.bmx
                  version: 15.09.16
                  set up in years: 2015
                  
                  This file is simply a collection of functions and featuers other people wrote
                  And all I did was collect them. I therefore cannot license this file itself.
                  Use it as you see fit. 
                  
                  Please respect the original authors of the contents and don't claim ownership
                  on them or sublicense this in any way, unless you have the original author's
                  explicit permission to do so.
                  
                  Wherever possible I credited the original author of the content.
End Rem
Strict

Import tricky_units.MKL_Version
Import brl.max2d

MKL_Version "Tricky's Units - BetterBlitz.bmx","15.09.16"
MKL_Lic     "Tricky's Units - BetterBlitz.bmx","Unlicensed"

Rem 
bbdoc: This is a modified version of BRL.Max2D.TileImage. It behaves just like TileImage(), but uses the current Scale and Rotation.
about: This function was written by: agent4125
End Rem
Function TileImage2(image:TImage, x:Float=0# ,y:Float=0#, frame:Int=0)

    Local scale_x#, scale_y#
    GetScale(scale_x#, scale_y#)

    Local viewport_x%, viewport_y%, viewport_w%, viewport_h%
    GetViewport(viewport_x, viewport_y, viewport_w, viewport_h)

    Local origin_x#, origin_y#
    GetOrigin(origin_x, origin_y)

    Local handle_X#, handle_y#
    GetHandle(handle_X#, handle_y#)

    Local image_h# = ImageHeight(image)
    Local image_w# = ImageWidth(image)

    Local w#=image_w * Abs(scale_x#)
    Local h#=image_h * Abs(scale_y#)

    Local ox#=viewport_x-w+1
    Local oy#=viewport_y-h+1

    origin_X = origin_X Mod w
    origin_Y = origin_Y Mod h

    Local px#=x+origin_x - handle_x
    Local py#=y+origin_y - handle_y

    Local fx#=px-Floor(px)
    Local fy#=py-Floor(py)
    Local tx#=Floor(px)-ox
    Local ty#=Floor(py)-oy

    If tx>=0 tx=tx Mod w + ox Else tx = w - -tx Mod w + ox
    If ty>=0 ty=ty Mod h + oy Else ty = h - -ty Mod h + oy

    Local vr#= viewport_x + viewport_w, vb# = viewport_y + viewport_h

    SetOrigin 0,0
    Local iy#=ty
    While iy<vb + h ' add image height to fill lower gap
        Local ix#=tx
        While ix<vr + w ' add image width to fill right gap
            DrawImage(image, ix+fx,iy+fy, frame)
            ix=ix+w
        Wend
        iy=iy+h
    Wend
    SetOrigin origin_x, origin_y

End Function

