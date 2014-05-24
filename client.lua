local render = {}
local gui = {
    button = { 
    	other = {} 
    },
    window = {},
    label = {},
    edit = {}
}
gui.window[1] = guiCreateWindow(0.33, 0.23, 0.35, 0.60, "Login", true)
guiWindowSetMovable(gui.window[1], false)
guiWindowSetSizable(gui.window[1], false)

gui.edit[1] = guiCreateEdit(0.30, 0.10, 0.39, 0.06, "", true, gui.window[1])
gui.label[1] = guiCreateLabel(0.30, 0.06, 0.38, 0.04, "Username", true, gui.window[1])
guiLabelSetHorizontalAlign(gui.label[1], "center", false)
guiLabelSetVerticalAlign(gui.label[1], "center")
gui.label [2] = guiCreateLabel(0.36, 0.32, 0.29, 0.05, "Enter your password", true, gui.window[1])
guiLabelSetColor(gui.label[2], 98, 226, 28)
guiLabelSetHorizontalAlign(gui.label[2], "center", false)

gui.button.other[1] = guiCreateButton(0.45, 0.92, 0.08, 0.05, "X", true, gui.window[1])
gui.button.other[2] = guiCreateButton(0.53, 0.91, 0.25, 0.05, "Register", true, gui.window[1])
gui.button.other[3] = guiCreateButton(0.21, 0.91, 0.24, 0.05, "Login", true, gui.window[1])
gui.button[9] = guiCreateButton(0.21, 0.80, 0.09, 0.08, "7", true, gui.window[1])
gui.button[8] = guiCreateButton(0.45, 0.80, 0.09, 0.08, "8", true, gui.window[1])
gui.button[7] = guiCreateButton(0.69, 0.80, 0.09, 0.08, "9", true, gui.window[1])
gui.button[6] = guiCreateButton(0.45, 0.59, 0.09, 0.08, "5", true, gui.window[1])
gui.button[5] = guiCreateButton(0.21, 0.59, 0.09, 0.08, "4", true, gui.window[1])
gui.button[4] = guiCreateButton(0.69, 0.59, 0.09, 0.08, "6", true, gui.window[1])
gui.button[3] = guiCreateButton(0.69, 0.39, 0.09, 0.08, "3", true, gui.window[1])
gui.button[2] = guiCreateButton(0.45, 0.39, 0.09, 0.08, "2", true, gui.window[1])
gui.button[1] = guiCreateButton(0.21, 0.39, 0.09, 0.08, "1", true, gui.window[1])

-- Toggle window invisible
guiSetVisible(gui.window[1], false)



function gui:isVisible()
	return guiGetVisible(self.window[1]), isCursorShowing()
end


function gui:toggle()
	local x,y = gui:isVisible()

	guiSetVisible(self.window[1], not x)
	showCursor	 (not y                )

	return
end

addEvent("gui:toggle", true)
addEventHandler("gui:toggle", getRootElement(),
	function ()
		gui:toggle()
	end)


local keys = {
	nums = {}
}

-- Only add another key if there isn't already 9
-- to the table
function keys:add(n)
	if #keys.nums < 9 then
		table.insert(self.nums, n)
	end
end

function keys:toStr()
	local str = table.concat( self.nums, "")

	return str
end


-- addCommandHandler("outputNums",
-- 	function()
-- 		outputChatBox(keys:toStr())
-- 	end)

addEventHandler("onClientGUIClick", getRootElement(),
	function()
		if gui:isVisible() then
			for i,v in ipairs(gui.button) do
				if source == v then
					if #keys.nums >= 9 then return end
					keys:add(guiGetText(v))
					outputDebugString("added "..guiGetText(v).." to table")
					--guiSetText(gui.label[2], "Entered numbers: "..#keys.nums)
				end
			end
		end
	end)


--------------------------------------------
-- Toggle the gui.
--------------------------------------------
bindKey("F5", "down",
	function()
		gui:toggle()

	end
)


--------------------------------------------
-- When this button is pressed it will
-- clear all nums.
--------------------------------------------
addEventHandler("onClientGUIClick", gui.button.other[1],
	function()
		gui:toggle()
		keys.nums = {}
		render[1] = false
	end, false)

--------------------------------------------
-- 
--------------------------------------------
addEventHandler("onClientGUIClick", gui.button.other[3],
	function()
		if #keys.nums == 9 then
			local username = guiGetText(gui.edit[1])
			if #username > 0 then
				triggerServerEvent("login", localPlayer, keys:toStr(), username)
			end
		else
			outputChatBox("Please enter 9 numbers to login.", 255,0,0)
			return
		end
	end, false)



addEventHandler("onClientGUIClick", gui.button.other[2],
	function()
		if #keys.nums == 9 then
			local username = guiGetText(gui.edit[1])
			if #username > 2 then
				triggerServerEvent("register", localPlayer, keys:toStr(), username)
			else
				outputChatBox("Please enter more than 2 characters for your username", 255, 0, 0)
			end
		else
			outputChatBox("Please enter 9 numbers to register", 255,0,0)
			return
		end
	end, false)



addEventHandler("onClientRender", getRootElement(),
	function()
		if gui:isVisible() then

			if #keys.nums == 0 then
				if not render[1] then render[1] = true; guiSetText(gui.label[2], "Enter your password") end
			else
				guiSetText(gui.label[2], "Length of password: "..#keys.nums)
			end
		end
	end)