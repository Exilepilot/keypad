--------------------------------------------
-- AUTHOR - PILOT
-- We control hashing and 
-- manipulation of SQLite database also
-- use the information within the database
-- to determine a successful login.
--------------------------------------------

--------------------------------------------
-- Create string for the creation of the
-- database.
--
--
-- ====THE PASSWORD WILL NOT BE IN PLAIN TEXT====
--------------------------------------------
-- local delete = [[DROP TABLE `login`]]

-- addCommandHandler("drop", 
-- function (thePlayer)
-- 	if hasObjectPermissionTo(thePlayer, "function.banPlayer") then
-- 		executeSQLQuery(delete)
-- 		outputChatBox(getPlayerName(thePlayer).." has dropped SQLite table", root, 0, 255, 0)
-- 	end
-- end)

local database = [[
CREATE TABLE IF NOT EXISTS `login`(
	`ID` INTEGER PRIMARY KEY AUTOINCREMENT,
	`user` TEXT NOT NULL,
	`pass` TEXT NOT NULL);
]]

local querys = {
	[[SELECT `ID` FROM `login` WHERE `user` = ?]], 			-- Check if name is already taken, if ID is valid.
	[[INSERT INTO `login` (`user`, `pass`) VALUES(?,?)]],	-- Create a new account
	[[SELECT `user` FROM `login`]],							-- Retrieve all usernames inside table 'login'
	[[SELECT `pass` FROM `login` WHERE `user` = ?]]			-- Retrieve the password from a certain user.
}
local v = executeSQLQuery(database)
outputDebugString("Attempting to create database return: "..tostring(v))

--------------------------------------------
-- By giving the keycode we get the
-- seed by using the formula: PASS = x^2 / sin(50)
-- where x is the 9 digit keycode.
--------------------------------------------
function getSeed (n)
	if type(n) ~= "number" then n = tonumber(n); assert(n ~= false, "Woops") end

	return (n^2)/math.sin(50)
end

--------------------------------------------
-- Get the keycode from rearranging the
-- equation above. The password for the seed
-- will be the only information on 
-- the SQLite database. It also may be hashed
-- by base64.
--------------------------------------------
function getKeyFromSeed (pass)
	if type(pass) ~= number then n = tonumber(n); assert(n ~= false, "Woops") end

	return math.sqrt(math.sin(50) * pass)
end


function nameAlreadyExist(name)
	if type(name) == "string" then
		local t = executeSQLQuery(querys[1], name)
		--outputChatBox(#t)
		if #t == 0 then
			return false
		end
	end
	return true
end
--------------------------------------------
-- This is not a real register like
-- createAccount function.
--------------------------------------------
function registerUser(pass, user)
	if #pass == 9 and user ~= nil then
		if not nameAlreadyExist(user) then
			local seed = getSeed(pass)
			if type(seed) == "number" then
				local t = executeSQLQuery(querys[2], user, base64Encode(seed))
				outputDebugString("Registered user, return: "..tostring(t))
			end
		else
			outputChatBox("User already exists, please choose a different username", client, 255, 0, 0)
		end
	end
end

addEvent("register", true)
addEventHandler("register", getRootElement(), registerUser)


--------------------------------------------
-- This does not co-exist with the function
-- logIn. It is completely virtual and runs 
-- separately from accounts. This is just a 
-- test.
--------------------------------------------
function loginUser(pass, user)
	if #pass == 9 and user ~= nil then
		local seed = getTEASeed(pass)
		local encrypt = base64Encode(seed)
		local t = executeSQLQuery(querys[4], user)

		if #t ~= 0 then
			if encrypt == t[1]["pass"] then
				outputChatBox("logged in!", client)
			else
				outputChatBox("Invalid password or username", client, 255, 0, 0)
			end
		else
			outputChatBox("You need to invalid username", client, 255, 0, 0)
		end

	end

end

addEvent("login", true)
addEventHandler("login", getRootElement(),
	loginUser)
