-- ignore the fact this is shit code, its lua...

-- import libraries
local GUI = require("GUI")
local system = require("System")
local internet = require("Internet")

--- maybe separate these??? config.lua??????
-- define colors
local bg = {
  primary = 0x36393f
}
local fg = {
  text = 0xdcddde,
  textmuted = 0x72767d,
  input = 0x40444b
}

-- define user-set variables
local bot_token = ""

-- create a workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 20, bg.primary))

-- add layout
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

local login = function()
  -- remove items
  layout:removeChildren()
  -- add progress circle thing
  --- maybe add text that says logging in and changes throughout login process
  local prog = layout:addChild(GUI.progressIndicator(1, 1, 0x3C3C3C, 0x00B640, 0x99FF80))
  prog.active = true
  workspace:draw()

  -- send login request
  local data, test = internet.request(
    "http://panel.themeow.ml:6098/login",
    "token=" .. bot_token,
    {
      ["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0" -- default from docs lmao
    }
  )
  
  -- moves progress indicator by one
  prog:roll()
  workspace:draw()

  GUI.alert(type(data) .. type(test)) -- note: json isnt being parsed lmao
end

-- add text
layout:addChild(GUI.text(1, 1, fg.text, "Hello " .. system.getUser() .. ", please enter discord token below."))
layout:addChild(GUI.text(1, 2, fg.textmuted, "Middle click to paste."))
-- add token input
local token_input = layout:addChild(GUI.input(1, 3, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Token", "Token", true, "X"))
token_input.onInputFinished = function()
  bot_token = token_input.text
end

-- add submit button
local submit_button = layout:addChild(GUI.roundedButton(1, 4, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Submit"))
submit_button.onTouch = login

-- context menu
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("New")
contextMenu:addSeparator()
contextMenu:addItem("Open")
contextMenu:addItem("Save", true)
contextMenu:addItem("Save as")
contextMenu:addSeparator()
contextMenu:addItem("Close").onTouch = function()
  window:remove()
end

-- testing items without context menu
menu:addItem("Test").onTouch = function()
  GUI.alert("It works!")
end

-- callback to fix height
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

-- draw changes on screen
workspace:draw()
workspace:start()
