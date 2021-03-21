-- io
if not io.readfile then
	io.readfile = function(filename)
		local handle = io.open(filename, 'r')
		local buffer = handle:read('*a')
		handle:close()
		return buffer
	end
end

if not io.writefile then
	io.writefile = function(filename, data)
		local handle = io.open(filename, 'w')
		handle:write(data)
		handle:close()
	end
end

-- table
if not table.has_value then
	table.has_value = function(tab, value)
		for _, val in ipairs(tab) do
			if value == val then
				return true
			end
		end
		return false
	end
end

if not table.join then
	table.join = function(tab, separator)
		if tab == nil then return nil end
		local result = table.remove(tab, 1)
		for _, val in ipairs(tab) do
			result = result..separator..val
		end
		return result
	end
end

-- string
if not string.split then
	string.split = function(value, separator)
		local idx = 1
		local length = value:len()
		local seplen = separator:len()
		local result = {}
		while idx < length do
			local match_idx = value:find(separator, idx, true)
			if match_idx == nil then break end

			if idx ~= match_idx then
				local slice = value:sub(idx, match_idx - 1)
				table.insert(result, slice)
			end

			idx = match_idx + seplen
		end
		return result
	end
end

if not string.slugify then 
	string.slugify = function(value)
		value = value:lower():gsub('[ \'"|]+', '-')
		return value
	end
end

if not string.padright then
	string.padright = function(value, pad, len)
		if value == nil then value = '' end
		while (value:len() + pad:len()) < len do
			value = value..pad
		end
		return value
	end
end
