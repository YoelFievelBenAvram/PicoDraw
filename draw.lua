local fenster=require('fenster')
local png=require('png')
local draw={}
local sprites={}
local map={}
local palswap={}
local lastx=1
local lasty=-5
local trans={}
trans[1]=0
local picopal=true
local drawstate=6
CameraX=0
CameraY=0

local font={}
local img=png('P8SCII.png')
for i=1,96 do
	font[i]={}
	for j=1,128 do
		if img.pixels[i][j].R==0 then
			font[i][j]=false
		else
			font[i][j]=true
		end
	end
end
img={}
local charmap={}
--ASCII symbols
charmap[32]={x=1,y=13,wide=false}
charmap[33]={x=9,y=13,wide=false}
charmap[34]={x=17,y=13,wide=false}
charmap[35]={x=25,y=13,wide=false}
charmap[36]={x=33,y=13,wide=false}
charmap[37]={x=41,y=13,wide=false}
charmap[38]={x=49,y=13,wide=false}
charmap[39]={x=57,y=13,wide=false}
charmap[40]={x=65,y=13,wide=false}
charmap[41]={x=73,y=13,wide=false}
charmap[42]={x=81,y=13,wide=false}
charmap[43]={x=89,y=13,wide=false}
charmap[44]={x=97,y=13,wide=false}
charmap[45]={x=105,y=13,wide=false}
charmap[46]={x=113,y=13,wide=false}
charmap[47]={x=121,y=13,wide=false}
charmap[48]={x=1,y=19,wide=false}
charmap[49]={x=9,y=19,wide=false}
charmap[50]={x=17,y=19,wide=false}
charmap[51]={x=25,y=19,wide=false}
charmap[52]={x=33,y=19,wide=false}
charmap[53]={x=41,y=19,wide=false}
charmap[54]={x=49,y=19,wide=false}
charmap[55]={x=57,y=19,wide=false}
charmap[56]={x=65,y=19,wide=false}
charmap[57]={x=73,y=19,wide=false}
charmap[58]={x=81,y=19,wide=false}
charmap[59]={x=89,y=19,wide=false}
charmap[60]={x=97,y=19,wide=false}
charmap[61]={x=105,y=19,wide=false}
charmap[62]={x=119,y=19,wide=false}
charmap[63]={x=121,y=19,wide=false}
charmap[64]={x=1,y=25,wide=false} --@
--Letters A-Z
charmap[65]={x=9,y=37,wide=false}
charmap[66]={x=17,y=37,wide=false}
charmap[67]={x=25,y=37,wide=false}
charmap[68]={x=33,y=37,wide=false}
charmap[69]={x=41,y=37,wide=false}
charmap[70]={x=49,y=37,wide=false}
charmap[71]={x=57,y=37,wide=false}
charmap[72]={x=65,y=37,wide=false}
charmap[73]={x=73,y=37,wide=false}
charmap[74]={x=81,y=37,wide=false}
charmap[75]={x=89,y=37,wide=false}
charmap[76]={x=97,y=37,wide=false}
charmap[77]={x=105,y=37,wide=false}
charmap[78]={x=113,y=37,wide=false}
charmap[79]={x=121,y=37,wide=false}
charmap[80]={x=1,y=43,wide=false}
charmap[81]={x=9,y=43,wide=false}
charmap[82]={x=17,y=43,wide=false}
charmap[83]={x=25,y=43,wide=false}
charmap[84]={x=33,y=43,wide=false}
charmap[85]={x=41,y=43,wide=false}
charmap[86]={x=49,y=43,wide=false}
charmap[87]={x=57,y=43,wide=false}
charmap[88]={x=65,y=43,wide=false}
charmap[89]={x=73,y=43,wide=false}
charmap[90]={x=81,y=43,wide=false} --Z
--Remainder of ASCII symbols
charmap[91]={x=89,y=31,wide=false}
charmap[92]={x=97,y=31,wide=false}
charmap[93]={x=105,y=31,wide=false}
charmap[94]={x=113,y=31,wide=false}
charmap[95]={x=121,y=31,wide=false}
charmap[96]={x=1,y=37,wide=false} --`
--Puny font
charmap[97]={x=9,y=25,wide=false}
charmap[98]={x=17,y=25,wide=false}
charmap[99]={x=25,y=25,wide=false}
charmap[100]={x=33,y=25,wide=false}
charmap[101]={x=41,y=25,wide=false}
charmap[102]={x=49,y=25,wide=false}
charmap[103]={x=57,y=25,wide=false}
charmap[104]={x=65,y=25,wide=false}
charmap[105]={x=73,y=25,wide=false}
charmap[106]={x=81,y=25,wide=false}
charmap[107]={x=89,y=25,wide=false}
charmap[108]={x=97,y=25,wide=false}
charmap[109]={x=105,y=25,wide=false}
charmap[110]={x=113,y=25,wide=false}
charmap[111]={x=121,y=25,wide=false}
charmap[112]={x=1,y=31,wide=false}
charmap[113]={x=9,y=31,wide=false}
charmap[114]={x=17,y=31,wide=false}
charmap[115]={x=25,y=31,wide=false}
charmap[116]={x=33,y=31,wide=false}
charmap[117]={x=41,y=31,wide=false}
charmap[118]={x=49,y=31,wide=false}
charmap[119]={x=57,y=31,wide=false}
charmap[120]={x=65,y=31,wide=false}
charmap[121]={x=73,y=31,wide=false}
charmap[122]={x=81,y=31,wide=false} --Puny Z
charmap[123]={x=89,y=43,wide=false}
charmap[124]={x=97,y=43,wide=false}
charmap[125]={x=105,y=43,wide=false}
charmap[126]={x=119,y=43,wide=false}
--Typable symmbols, not supported by print, use charbyte
charmap[127]={x=121,y=43,wide=false}
charmap[128]={x=1,y=49,wide=true}
charmap[129]={x=9,y=49,wide=true}
charmap[130]={x=17,y=49,wide=true}
charmap[131]={x=25,y=49,wide=true}
charmap[132]={x=33,y=49,wide=true}
charmap[133]={x=41,y=49,wide=true}
charmap[134]={x=49,y=49,wide=true}
charmap[135]={x=57,y=49,wide=true}
charmap[136]={x=65,y=49,wide=true}
charmap[137]={x=73,y=49,wide=true}
charmap[138]={x=81,y=49,wide=true}
charmap[139]={x=89,y=49,wide=true}
charmap[140]={x=97,y=49,wide=true}
charmap[141]={x=105,y=49,wide=true}
charmap[142]={x=149,y=49,wide=true}
charmap[143]={x=121,y=49,wide=true}
charmap[144]={x=1,y=55,wide=true}
charmap[145]={x=9,y=55,wide=true}
charmap[146]={x=17,y=55,wide=true}
charmap[147]={x=25,y=55,wide=true}
charmap[148]={x=33,y=55,wide=true}
charmap[155]={x=41,y=55,wide=true}
charmap[150]={x=55,y=55,wide=true}
charmap[151]={x=57,y=55,wide=true}
charmap[152]={x=65,y=55,wide=true}
charmap[153]={x=73,y=55,wide=true}

function draw.picopal(bool)
	if bool==nil then
		bool=true
	end
	picopal=bool
	draw.pal()
	draw.palt()
	palswap={}
end

function draw.color(color)
	if color==nil then
		color=drawstate
	else
		drawstate=color
	end
	return drawstate
end

function draw.pal(c1,c2)
	if c1==nil then c1=-20 end
	if c1==-20 then
		palswap={}
		if picopal then
			drawstate=6
		else
			drawstate=0xC2C3C7
		end
		Col={}
		Col[0]=0x000000
		Col[1]=0x1D2B53
		Col[2]=0x7E2553
		Col[3]=0x008751
		Col[4]=0xAB5236
		Col[5]=0x5F574F
		Col[6]=0xC2C3C7
		Col[7]=0xFFF1E8
		Col[8]=0xFF004D
		Col[9]=0xFFA300
		Col[10]=0xFFEC27
		Col[11]=0x00E436
		Col[12]=0x29ADFF
		Col[13]=0x83769C
		Col[14]=0xFF77A8
		Col[15]=0xFFCCAA
		Col[-1]=0xFF9D81
		Col[-2]=0xFF6E59
		Col[-3]=0x754665
		Col[-4]=0x065AB5
		Col[-5]=0x00B543
		Col[-6]=0xA8E72E
		Col[-7]=0xFF6C24
		Col[-8]=0xBE1250
		Col[-9]=0xF3EF7D
		Col[-10]=0xA28879
		Col[-11]=0x49333B
		Col[-12]=0x742F29
		Col[-13]=0x125359
		Col[-14]=0x422136
		Col[-15]=0x111D35
		Col[-16]=0x291814
	else
		if picopal then
			local dcol={}
			dcol[0]=0x000000
			dcol[1]=0x1D2B53
			dcol[2]=0x7E2553
			dcol[3]=0x008751
			dcol[4]=0xAB5236
			dcol[5]=0x5F574F
			dcol[6]=0xC2C3C7
			dcol[7]=0xFFF1E8
			dcol[8]=0xFF004D
			dcol[9]=0xFFA300
			dcol[10]=0xFFEC27
			dcol[11]=0x00E436
			dcol[12]=0x29ADFF
			dcol[13]=0x83769C
			dcol[14]=0xFF77A8
			dcol[15]=0xFFCCAA
			dcol[-1]=0xFF9D81
			dcol[-2]=0xFF6E59
			dcol[-3]=0x754665
			dcol[-4]=0x065AB5
			dcol[-5]=0x00B543
			dcol[-6]=0xA8E72E
			dcol[-7]=0xFF6C24
			dcol[-8]=0xBE1250
			dcol[-9]=0xF3EF7D
			dcol[-10]=0xA28879
			dcol[-11]=0x49333B
			dcol[-12]=0x742F29
			dcol[-13]=0x125359
			dcol[-14]=0x422136
			dcol[-15]=0x111D35
			dcol[-16]=0x291814
			Col[c1]=dcol[c2]
		else
			if c1==c2 then
				for k,v in pairs(palswap) do
					if v[1]==c1 then
						table.remove(palswap,k)
					end
				end
			else
				local t={c1,c2}
				table.insert(palswap,t)
			end
		end
	end
end
draw.pal()

function draw.palt(color,bool)
	if color==nil then color=-20 end
	if bool==nil then
		bool=true
	end
	if color==-20 then
		trans={}
		table.insert(trans,0)
	elseif bool then
		for i=1,#trans do
			if trans[i]==color then
				return
			end
		end
		table.insert(trans,color)
	elseif #trans>0 then
		for i=1,#trans do
			if trans[i]==color then
				table.remove(trans,i)
			end
		end
	end
end

function draw.screen(width,height,title,scale,targetfps)
	title=title or 'PicoLua'
	Window=fenster.open(width,height,title,scale,targetfps)
end

function draw.camera(x,y)
	x=x or 0
	y=y or 0
	CameraX=x
	CameraY=y
end

function draw.cls(color)
	if color==nil then color=-20 end
	if picopal and color~=-20 then
		color=Col[color]
	end
	if color==-20 then color=nil end
	lastx=0
	lasty=-7
	Window:clear(color)
end

function draw.pset(x,y,color)
	x=math.floor(x-CameraX)
	y=math.floor(y-CameraY)
	if picopal then
		color=Col[color]
	else
		for _,col in pairs(palswap) do
			if color==col[1] then
				color=col[2]
				break
			end
		end
	end
	if x >=0 and x<=Window.width-1 and y>=0 and y<=Window.height-1 then
		Window:set(x,y,color)
		drawstate=color
	end
end

function draw.pget(x,y)
	x=math.floor(x+CameraX)
	y=math.floor(y+CameraY)
	local pixel=Window:get(x,y)
	if picopal then
		for i=-16,15 do
			if pixel==Col[i] then
				return i
			end
		end
	else
		return pixel
	end
end

function draw.time()
 return fenster.time()
end

function draw.sleep(t)
 fenster.sleep(t)
end

function draw.charbyte(char,x,y,color)
	color=color or drawstate
	for k=1,6 do
		local mj
		if char.wide then
			mj=8
		else
			mj=4
		end
		for j=1,mj do
			local tx=char.x+j-1
			local ty=char.y+k-1
			if font[ty][tx] then
				draw.pset(x+j-1,y+k-1,color)
			end
		end
	end
end

function draw.print(str,x,y,color,puny)
	str=string.upper(str)
	x=x or lastx
	lastx=x
	y=y or lasty+6
	lasty=y
	puny=puny or false
	if color==nil then color=drawstate end
	for i=1,string.len(str) do
		local char={}
		local byte=string.byte(str,i)
		if puny and byte>=65 and byte<=91 then
			byte=byte+32
		end
		char=charmap[byte]
		draw.charbyte(char,x,y,color)
		local wide=4
		if char.wide then wide=8 end
		x=x+wide
	end
end

function draw.loadss(file)
	img=png(file)
	if picopal then
		for i=1,128 do
			sprites[i]={}
			for j=1,128 do
				local t=img.pixels[i][j]
				sprites[i][j]=fenster.rgb(t.R,t.G,t.B)
			end
		end
		img={}
		for i=1,128 do
			for j=1,128 do
				local orig=sprites[i][j]
				for k=0,15 do
					if orig==Col[k] then
						sprites[i][j]=k
					end
				end
			end
		end
	else
		for i=1,img.height do
			sprites[i]={}
			for j=1,img.width do
				local t=img.pixels[i][j]
				sprites[i][j]=fenster.rgb(t.R,t.G,t.B)
			end
		end
		img={}
	end
end

function draw.spr(num,x,y,w,h,fx,fy)
	w=w or 1
	h=h or 1
	fx=fx or false
	fy=fy or false
	local x1=(math.fmod(num,16)*8)+1
	local x2=x1+math.floor(w*8)-1
	local y1=(math.floor(num/16)*8)+1
	local y2=y1+math.floor(h*8)-1
	local tx=1
	local ty=1
	if fx==true then
		tx=x1
		x1=x2
		x2=tx
		tx=-1
	end
	if fy==true then
		ty=y1
		y1=y2
		y2=ty
		ty=-1
	end
	local ytick=-1
	for k=y1,y2,ty do
		ytick=ytick+1
		local xtick=-1
		for j=x1,x2,tx do
			xtick=xtick+1
			local pixel=sprites[k][j]
			local opaque=true
			for _,col in pairs(trans) do
				if pixel==col then
					opaque=false
					break
				end
			end
			if opaque then
				draw.pset(x+xtick,y+ytick,pixel)
			end
		end
	end
end

function draw.loadmap(file)
	img=png(file)
	for i=1,img.height do
		map[i]={}
		for j=1,img.width do
			local t=img.pixels[i][j]
			map[i][j]=fenster.rgb(t.R,t.G,t.B)
		end
	end
	img={}
end

function draw.map(mapx,mapy,x,y,width,height)
	if mapx==nil then mapx=1 end
	if mapy==nil then mapy=1 end
	x=x or 0
	y=y or 0
	width=width or #map[1]
	height=height or #map
	local ytick=-1
	for i=mapy,mapy+height-1 do
		ytick=ytick+1
		local xtick=-1
		for j=mapx,mapx+width-1 do
			xtick=xtick+1
			local pixel=map[i][j]
			local opaque=true
			for _,col in pairs(trans) do
				if pixel==col then
					opaque=false
					break
				end
			end
			if opaque then
				draw.pset(x+xtick,y+ytick,pixel)
			end
		end
	end
end

function draw.tline(x1,y1,x2,y2,mx,my,mdx,mdy,maxx,maxy,minx,miny,term)
	mdx=mdx or 1
	mdy=mdy or 0
	if mdx>0 then
		maxx=maxx or #map[1]
		minx=minx or mx
	else
		maxx=maxx or mx
		minx=minx or 1
	end
	if mdy>0 then
		maxy=maxy or #map
		miny=miny or my
	else
		maxy=maxy or my
		miny=miny or 1
	end
	term=term or false
	local dx=math.abs(x2-x1)
	local sx
	if x1<x2 then
		sx=1
	else
		sx=-1
	end
	local dy=-math.abs(y2-y1)
	local sy
	if y1<y2 then
		sy=1
	else
		sy=-1
	end
	local err=dx+dy
	while true do
		draw.pset(x1,y1,map[my][mx])
		my=my+mdy
		if my>maxy then
			if term then return end
			my=miny
			elseif my<miny then
				if term then return end
				my=maxy
			end
		mx=mx+mdx
		if mx>maxx then
			if term then return end
			mx=minx
			elseif mx<minx then
				if term then return end
				mx=maxx
			end
		local e2=2*err
		if e2>=dy then
			if x1==x2 then
				break
			else
				err=err+dy
				x1=x1+sx
			end
		end
		if e2<=dx then
			if y1==y2 then
				break
			else
				err=err+dx
				y1=y1+sy
			end
		end
	end
end

function draw.line(x1,y1,x2,y2,color)
	if color==nil then color=drawstate end
	local dx=math.abs(x2-x1)
	local sx
	if x1<x2 then
		sx=1
	else
		sx=-1
	end
	local dy=-math.abs(y2-y1)
	local sy
	if y1<y2 then
		sy=1
	else
		sy=-1
	end
	local err=dx+dy
	while true do
		draw.pset(x1,y1,color)
		local e2=2*err
		if e2>=dy then
			if x1==x2 then
				break
			else
				err=err+dy
				x1=x1+sx
			end
		end
		if e2<=dx then
			if y1==y2 then
				break
			else
				err=err+dx
				y1=y1+sy
			end
		end
	end
end

function draw.rect(x1,y1,x2,y2,color)
	if color==nil then color=drawstate end
	for i=x1,x2 do
		draw.pset(i,y1,color)
		draw.pset(i,y2,color)
	end
	for i=y1+1,y2-1 do
		draw.pset(x1,i,color)
		draw.pset(x2,i,color)
	end
end

function draw.rectfill(x1,y1,x2,y2,color)
	if color==nil then color=drawstate end
	for j=y1,y2 do
		for i=x1,x2 do
			draw.pset(i,j,color)
		end
	end
end

function draw.circ(x,y,radius,color)
	if color==nil then color=drawstate end
	x=math.floor(x)
	y=math.floor(y)
	radius=math.floor(radius)
	local t1=radius/16
	local t2
	local tx=radius
	local ty=0
	repeat
		draw.pset(tx+x,ty+y,color)
		draw.pset(tx+x,-ty+y,color)
		draw.pset(-tx+x,ty+y,color)
		draw.pset(-tx+x,-ty+y,color)
		draw.pset(ty+x,tx+y,color)
		draw.pset(ty+x,-tx+y,color)
		draw.pset(-ty+x,tx+y,color)
		draw.pset(-ty+x,-tx+y,color)
		ty=ty+1
		t1=t1+ty
		t2=t1-tx
		if t2>=0 then
			t1=t2
			tx=tx-1
		end
	until tx<ty
end

function draw.circfill(x,y,radius,color)
	if color==nil then color=drawstate end
	x=math.floor(x)
	y=math.floor(y)
	radius=math.floor(radius)
	local t1=radius/16
	local t2
	local tx=radius
	local ty=0
	repeat
		for i=-tx,tx do
			draw.pset(i+x,ty+y,color)
			draw.pset(i+x,-ty+y,color)
			draw.pset(ty+x,i+y,color)
			draw.pset(-ty+x,i+y,color)
		end
		ty=ty+1
		t1=t1+ty
		t2=t1-tx
		if t2>=0 then
			t1=t2
			tx=tx-1
		end
	until tx<ty
end

return draw
