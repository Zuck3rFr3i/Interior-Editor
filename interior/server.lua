addEvent("system:output", true)
addEventHandler("system:output", root, function(objects_tbl)
	if not fileExists("output/objects.txt") then
		fileCreate("output/objects.txt")
	end
	local file_ouput = fileOpen("output/objects.txt")
	if file_ouput then
		for i, v in pairs(objects_tbl) do
			local size = fileGetSize(file_ouput)
			fileSetPos(file_ouput, size)
			fileWrite(file_ouput, v)
		end
		fileClose(file_ouput)
	end
end)