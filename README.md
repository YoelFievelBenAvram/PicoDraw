# PicoDraw

> A library to utilize fenster compatible with Pico 8 sprite sheets, the Pico 8 palette, and P8SCII with an API roughly compatible with most of Pico 8's draw functions

This is not a Pico 8 emulator and is not code compatible with Pico 8 carts. The API will be familiar to Pico 8 users, but copying and pasting from a cart's draw loop will likely not work as expected. The intention is to provide a basic graphical interface for Lua that is optionally compatible with the Pico 8 palette and sprite sheets and would be familiar enough to a Pico 8 users be immediately usable. 

## Dependencies and necessary files

https://github.com/jonasgeiler/lua-fenster

Install fenster from LuaRocks server:

```shell
luarocks install fenster
```

https://github.com/Didericis/png-lua

Download png.lua and deflatelua.lua and place them in the same folder as your main program.

Put the draw.lua library and P8SCII.png in that same folder along with any sprite sheets and map files you intend to utilize.

## Setting up main loop

Again, this is not a Pico 8 emulator, and it does not utilize _init _update _draw loop. Everything goes in the Window:loop() and fenster sets a target FPS. The majority of your program will sit in the Window:loop(), but minimally, your program should first initialize a global table Window, load the PicoDraw library, open a window. A skeletal program that continues to loop until the Esc key is pressed would look like this.

```shell
Window={}
local draw=require("draw")
draw.screen(128,128,"PicoDraw",4)

while Window:loop() and not Window.keys[27] do
	--main body of program
end
```

## Fenster API Reference

PicoDraw is built on top of fenster which uses an object Window to manage the running GUI. This is set as a global variable in this implimentation, so Window is capitalized. While fenster has a larger API available through the Window object, PicoDraw has functions that supercede much of it. The Window functions and properties compatible are listed below with some explanation.

* Window:close()

* Window:loop()

Window:loop() returns true while the window is opened. Window:close() terminates the program.

* Window.keys: boolean[]

This property is an array of boolean values representing the state of each key on the keyboard. Each index in the array corresponds to a specific key, and the value at that index is true if the key is currently pressed, and false otherwise. The key codes are mostly ASCII, but arrow keys are 17 to 20.

* Window.delta: number

Returns the number of milliseconds since the last frame was drawn. Fenster attempts to hit a target fps, but there is nothing that guarantees the rate at which the main loop runs. Multiplying everything that changes by the delta syncs the rate of change to the actual FPSs. See the wikipedia article on delta timing.

* Window.mousex: integer

* Window.mousey: integer

* Window.mousedown: boolean

The pixel the mouse cursor is on in x and y coordinates and if the mouse is clicked. Does not differentiate between a left, right, or middle click.

* Window.modcontrol: boolean

* Window.modshift: boolean

* Window.modalt: boolean

* Window.modgui: boolean

Is true if the Ctrl, Shift, Alt, or Meta key respectively is pressed. These may not register if pressed alone. This is a known bug in lua-fenster.

The rest of the properties below are set by the draw:screen() function at the time the window is opened.

* Window.width: integer

* Window.height: integer

* Window.title: string

* Window.scale: integer

* Window.targetfps: number

## PicoDraw API Reference

* draw.screen(width,height,[title],[scale],[targetfps])

Opens a window width pixels wide and height pixels high. Scale sets the integer scaling and must be a power of 2. E.g., 1, 2, 4, 8. Targetfps pauses the loop at the end to limit frame rate and cpu usage. Defaults to 60 fps. 0 disables the limiter and runs the program as fast as possible.

* draw.picopal([bool])

Default is true. If true, sprite sheets, maps, and draw functions will store color and accept commands with numbers corresponding to the Pico 8 pallette. If false, commands will expect hex colors. For example, this is both ways to draw a white circle at 20,20 that has a 5 pixel radius.

```shell
circfill(20,20,5,7)

circfill(20,20,5,0xFFFFFF)
```

* draw.color([color])

Returns the draw state. If a color is entered, it sets the draw state to that color. The draw state is the color of the last pixel put on the screen. Defaults to 6 or 0xC2C3C7 which is light gray.

* draw.pal([c1],[c2])

When run without parameters, it resets the Col table to default and resets the swapped colors. The Col table is a global table where the index is the Pico 8 pallette number and the value is the hex color code. The pallette can adjusted by editing the table. This table is referenced by the draw function if picopal is true. If picopal is false, you can still directly reference the table. For example:

```shell
picopal(false)
circfill(20,20,5,Col[7])
```

If both parameters are present, when the draw function encounters the first color, the second color will be drawn. When picopal is true, this function accepts integers from -16 to 15. When picopal is false, use hex. The function uses the original pallette color for c2. So pal(7,7) will reset 7 to white even if previously changed.

* draw.palt(color,[bool])

When the draw.spr() and draw.map() functions draw, this color will be ignored. By default, 0 will not be drawn. When either draw.palt() or draw.pal() is ran without parameters, the transparency table is reset to default. When run without a parameter, defaults to true.

* draw.camera(x,y)

Sets the offset for all draw commands. It essentially sets the coordinate of the pixel in the top left corner. For example, if you wanted to center (0,0) on a 128x128 screen, you would run draw.camera(-64,-64). Defaults to (0,0) being the top left pixel.

* function draw.cls([color])

Clears the screen with a solid color. Defaults to black.

* draw.pset(x,y,color)

Puts a pixel on the screen at the (x,y) coordinate.

* draw.pget(x,y)

Returns the color at the (x,y) coordinate.

* draw.time()

Returns the time in milliseconds since the start of the program.

* draw.sleep(t)

Pauses for t milliseconds.

* draw.charbyte(char,x,y,[color])

Draws a character from the font sheet at the (x,y) coordinate. Uses the P8SCII codes 32 to 153. For now.

* draw.print(string,[x],[y],[color],[puny])

Prints a string to the screen. If no coordinates are given, it prints right below the last printed line. If puny is true, uses the puny font.

* draw.loadss(file)

Loads a 128x128 sprite sheet into memory. Run after running draw.picopal().

* draw.spr(number,x,y,[w],[h],[flipx],[flipy])

Draw sprite number to the (x,y) coordinate. A sprite is an 8x8 square, and there are 16 sprites a row. The top left sprite is 0. For other sized sprites, w and h are scaling factors. to draw a 16x16 sprite that's top left corner is the 8th sprite at coordinates (5,5) write:

```shell
draw.spr(8,5,5,2,2)
```

The scaling factor does not have to be a whole number. Each pixel is equivalent to 0.125, so a 10x5 sprite would be scaled 1.25,0.625. Flipx and flipy flip the sprite along the obvious axis if true.

* draw.loadmap(file)

Loads a png into memory to be utilized by draw.map() and draw.tline(). Run after running draw.picopal().

PicoDraw does not support Pico 8 maps, and PicoDraw maps are not a table of sprites. Rather, the expected use is to load a file that is a single large image.

* draw.map([mapx],[mapy],[screenx],[screeny],[maxx],[maxy])

Draws the map sprite to the screen. Mapx and mapy repsent the top left pixel of the map, and it's drawn to the screen beginning at the screenx and screeny coordinate. By default, the entire map image is drawn, and you can use draw.camera() to pan around the image. However, the map function is more computationally expensive than in Pico 8, so you may want to put a limit to what's drawn. Maxx and maxy sets the maximum map coordinate drawn.

* draw.tlinedraw.tline(x1,y1,x2,y2,mx,my,[mdx],[mdy],[maxx],[maxy],[minx],[miny],[term])

This one requires a bit of explanation and departs significantly from Pico 8. This draws a line from (x0,y0) to (x1,y1), but instead of defining a color, the functiom samples the map sprite for colors. It starts at the pixel at map coordinate (mx,my) and each next pixel is sampled algorthymically by adding deltas to each axis. Mdx is added to mx and mdy is added to my. By default, mdx is 1 and mdy is 0, resulting in a horizontal line starting from (mx,my).

By default, the function will loop between the minimum and maximum values of the x and y parameters. The minimums are by default the starting pixel and the maximums are the edge of the map sprite. If a delta is negative, the edge is minimum and the starting pixel is maximum.

If term is true, instead of looping, the line terminates when the function hits the edge of the defined map area. Get your mode 7 on.

* draw.line(x1,y1,x2,y2,[color])

* draw.rect(x1,y1,x2,y2,[color])

* draw.rectfill(x1,y1,x2,y2,[color])

* draw.circ(x,y,radius,[color])

* draw.circfill(x,y,radius,[color])
