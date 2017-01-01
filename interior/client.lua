--[[
	Author: Zuck3rFr3i
]]

local aviableObjects = {
	{id=1452, name="Wand(Normal)", offset_z=1.5},
	{id=1454, name="Wand(Tuere)"},
	{id=1457, name="Wand(Fenster)"},
	{id=1458, name="Wand(Halbe)"},
	{id=1479, name="Wand(Dreifach)"}
}
	
local pos_tbl = {
	[1] = {x=47, y=47, z=40},
	[2] = {x=0, y=47, z=40},
	[3] = {x=-47, y=47, z=40},
	[4] = {x=-47, y=0, z=40},
	[5] = {x=-47, y=-47, z=40},
	[6] = {x=0, y=-47 , z=40},
	[7] = {x=47, y=-47, z=40},
	[8] = {x=47, y=0, z=40}
}

local createdObjects = {}

local int_objectlimit = 10
local int_currentobjects = 0
local int_objectcheck = 0
local int_draw = 0
local int_pos = 1
local elem_bodenplatte = createObject (6959, 0, 0, 2950)
setElementAlpha ( elem_bodenplatte, 255 )

fadeCamera(true)
local int_ineditor = 0
local sx, sy = guiGetScreenSize()
local width_l, height_l = 300, sy-20
local x_l = 5
local y_l = (sy/2)-(height_l/2)

local width_r, height_r = 300, 200
local x_r = (sy-width_r-5)
local y_r = (sy-height_r-5)

function setObject(button, state, _, _, _, _, _, elem_objects)
	if elem_object and objectcheck == 1 and button == "left" and state == "up" and elem_objects == elem_bodenplatte then
		if int_currentobjects >= int_objectlimit then
			outputDebugString("object Limit erereicht!")
			return
		end
		local elem_x, elem_y, elem_z = getElementPosition(elem_object)
		local elem_id = getElementModel(elem_object)
		local _, _, elem_rot = getElementRotation(elem_object)
		if elem_x and elem_rot then
			local insert_object = createObject(elem_id, elem_x, elem_y, elem_z, _, _, elem_rot)
			local elem_x_object, elem_y_object, elem_z_object = getElementPosition(insert_object)
			local elem_id_object = getElementModel(insert_object)
			local _, _, elem_rot_object = getElementRotation(insert_object)
			table.insert(createdObjects, "|"..elem_id_object.."|"..elem_x_object.."|"..elem_y_object.."|"..elem_z_object.."|"..elem_rot_object.."\n")
			currentobjects = currentobjects+1
		end
	end
end

function delObject(btn, state, _, _, _, _, _, elem_objects_hit)
	if btn == "left" and state == "up" and elem_objects_hit and elem_objects_hit ~= Bodenplatte then
		local x_object, y_object, z_object = getElementPosition(elem_objects_hit)
		local id_object = getElementModel(elem_objects_hit)
		for i, v in pairs(createdObjects) do
			local ido, xo, yo, zo, ro = gettok(v, 1, "|"), gettok(v, 2, "|"), gettok(v, 3, "|"), tonumber(gettok(v, 4, "|")), tonumber(gettok(v, 5, "|"))
			local math_xo = math.floor ( xo * 100 ) / 100
			local math_x_object = math.floor ( x_object * 100 ) / 100
			local math_yo = math.floor ( yo * 100 ) / 100
			local math_y_object = math.floor ( y_object * 100 ) / 100
			local math_zo = math.floor ( zo * 100 ) / 100
			local math_z_object = math.floor ( z_object * 100 ) / 100
			if math_xo == math_x_object and math_yo == math_y_object and math_zo == math_z_object then
				table.remove(createdObjects, i)
				destroyElement(elem_objects_hit)
				currentobjects = currentobjects-1
			end
		end
		removeEventHandler("onClientClick", root, delObject)
	end
end

function rotObject(btn, state)
	if getKeyState ( "lshift" )  == true then
		rot_rate = 7
	elseif  getKeyState ( "lalt" )  == true then
		rot_rate = 1
	else
		rot_rate = 3
	end
	if btn == "mouse_wheel_down" and int_objectcheck == 1 then
		local _, _, rot = getElementRotation(elem_object)
		if rot then
			setElementRotation(elem_object, 0, 0, rot+rot_rate)
		end
	elseif btn == "mouse_wheel_up" then
		local _, _, rot = getElementRotation(elem_object)
		if rot then
			setElementRotation(elem_object, 0, 0, rot-rot_rate)
		end
	end
end

local width_r, height_r = 100, 100
local x_r = (sx-width_r-5)
local y_r = (sy-height_r-5)

function goInterior()
	setPlayerHudComponentVisible ( "all", false)
	showChat(false)
	setCameraMatrix(47, 47, 3000, 0, 0, 2950)
	local btn_right = guiCreateButton(x_r, y_r, width_r, height_r, ">", false)
	local btn_left = guiCreateButton(x_r-101, y_r, width_r, height_r, "<", false)
	local btn_del = guiCreateButton(x_r-301, y_r, width_r, height_r, "X", false)
	frame_l_main = guiCreateWindow(x_l, y_l, width_l, height_l, "Object-Liste", false)
	local frame_l_grid = guiCreateGridList(0.05, 0.05, 0.90, 0.90, true, frame_l_main )
	local col_object = guiGridListAddColumn( frame_l_grid, "Object", 0.50 )
	local col_id = guiGridListAddColumn( frame_l_grid, "ID", 0.20 )
	for id, tbl_objects in ipairs(aviableObjects) do 
		local row = guiGridListAddRow ( frame_l_grid )
		guiGridListSetItemText ( frame_l_grid, row, col_object, tbl_objects.name, false, false )
		guiGridListSetItemText ( frame_l_grid, row, col_id, tbl_objects.id, false, false )
	end
	addEventHandler("onClientGUIClick", frame_l_grid, function()
		local elem_id = guiGridListGetItemText( frame_l_grid, guiGridListGetSelectedItem ( frame_l_grid ), 2 )
		if elem_id ~= nil and elem_id ~= "" then
			int_objectcheck = 1
			local _, _, xm, ym, zm = getCursorPosition ( )
			if elem_object then
				destroyElement(elem_object)
			end
			elem_object = createObject(elem_id, xm, ym, zm)
			setElementCollisionsEnabled ( elem_object, false ) 
			if elem_object then
				addEventHandler("onClientRender", root, function()
					if int_objectcheck == 1 then
						local _, _, xm, ym, zm = getCursorPosition ( )
						local px, py, pz = getCameraMatrix()
						local hit, x, y, z, elementHit = processLineOfSight ( px, py, pz, xm, ym, zm )
						if hit then
							if elementHit ~= elem_object then
								setElementPosition( elem_object, x, y, z )
							end
						end
					else
						return
					end
				end)
			else
				return
			end
		else
			if elem_object ~= nil and elem_object then
				destroyElement(elem_object)
				elem_id = nil
				elem_object = nil
				objectcheck = 0
			end
		end
	end, false)
	addEventHandler("onClientGUIClick", btn_right, function()
		if pos == 8 then
			pos = 0
			local xo, yo, zo = getElementPosition(Bodenplatte)
			local x, y, z = pos_tbl[pos+1].x, pos_tbl[pos+1].y, pos_tbl[pos+1].z
			setCameraMatrix(xo+x, yo+y, zo+z, xo, yo, zo)
			pos = pos+1
		else
			local xo, yo, zo = getElementPosition(Bodenplatte)
			local x, y, z = pos_tbl[pos+1].x, pos_tbl[pos+1].y, pos_tbl[pos+1].z
			setCameraMatrix(xo+x, yo+y, zo+z, xo, yo, zo)
			pos = pos+1
		end
	end, false)
	addEventHandler("onClientGUIClick", btn_left, function()
		if pos == 1 then
			pos = 9
			local xo, yo, zo = getElementPosition(Bodenplatte)
			local x, y, z = pos_tbl[pos-1].x, pos_tbl[pos-1].y, pos_tbl[pos-1].z
			setCameraMatrix(xo+x, yo+y, zo+z, xo, yo, zo)
			pos = pos-1
		else
			local xo, yo, zo = getElementPosition(Bodenplatte)
			local x, y, z = pos_tbl[pos-1].x, pos_tbl[pos-1].y, pos_tbl[pos-1].z
			setCameraMatrix(xo+x, yo+y, zo+z, xo, yo, zo)
			pos = pos-1
		end
	end, false)
	addEventHandler("onClientGUIClick", btn_del, function()
		if elem_object then
			destroyElement(elem_object)
			elem_id = nil
			elem_object = nil
			objectcheck = 0
		end
		addEventHandler("onClientClick", root, delObject)
	end, false)
	guiSetAlpha(frame_l_main, 0.8)
	guiWindowSetMovable(frame_l_main, false)
	guiWindowSetSizable(frame_l_main, false)
	addEventHandler("onClientKey", root, rotObject)
end

function goOutInterior()

end

addCommandHandler("endeditor", function()
	triggerServerEvent("system:output", localPlayer, createdObjects)
end)

bindKey("f2", "down", function()
	if ineditor == 0 then
		goInterior()
		ineditor = 1
		showCursor(true)
		addEventHandler("onClientClick", getRootElement(), setObject)
	elseif ineditor == 1 then
		goOutInterior()
		ineditor = 0
		showCursor(false)
		removeEventHandler("onClientClick", getRootElement(), setObject)
	end
end)

function Mapeditor_Start ( player )
	local int_dim = getElementDimension ( player )
	
	
end