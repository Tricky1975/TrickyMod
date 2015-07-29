Graphics 600,600
Const N#=.2,Z=512
BlopRadius=511
Width=1024

For R#=1 To BlopRadius Step N
Print "R = "+R+" MaxRadius = "+BlopRadius
A#=R*R/Width
SetColor A,A,A
DrawOval R/2,R/2,Z-R,Z-R 'change to DrawRect for inverted blobs
Next

Pix:TPixmap = GrabPixmap(0,0,512,512)
SavePixmapPNG Pix,"Blop.png"
