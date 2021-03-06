local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- asetetaan muuttujat helpottamaan näytön asetuksia 
local acw = display.actualContentWidth
local ach = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth-(display.screenOriginX*2)
local screenRight = display.contentWidth - display.screenOriginX
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight-(display.screenOriginY*2)
local screenBottom = display.contentHeight-display.screenOriginY

 -- muuttujien esittelyt
local json = require( "json" )
 
local pisteTaulu = {}
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
 
local function lataaPisteet()
 
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        pisteTaulu = json.decode( contents )
    end
 
    if ( pisteTaulu == nil or #pisteTaulu == 0 ) then
        pisteTaulu = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end


local function tallennaPisteet()
 
    for i = #pisteTaulu, 11, -1 do
        table.remove( pisteTaulu, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( pisteTaulu ) )
        io.close( file )
    end
end

-- local function gotoMenu()
    -- composer.gotoScene( "scene-menu", { time=1000, effect="crossFade" } )
-- end

local function onMenuTouch(event)
  if ( "ended" == event.phase ) then
    composer.gotoScene( "scene-menu", { time=1000, effect="crossFade" }  )
  end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
    -- lataa aikaisemmat pisteet
    lataaPisteet()

    -- lisää viimeisen pelin pisteet taulukkoon ja nollaa
    table.insert( pisteTaulu, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- lajittele pistetaulun tietueet suurimmasta pienimpään
    local function compare( a, b )
        return a > b
    end
    table.sort( pisteTaulu, compare )

    -- pisteiden tallennus
    tallennaPisteet()

    local background = display.newImageRect( sceneGroup, "kuvat/forest_bground_mh.png", 350, 570 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
     
    local highscoresOtsikko = display.newImageRect( sceneGroup, "kuvat/highscores.png", 250, 65)
    highscoresOtsikko.x = centerX
    highscoresOtsikko.y = centerY - 200
    for i = 1, 6 do
        if ( pisteTaulu[i] ) then
            local yPos = 40 + ( i * 56 )

            local sijoitus = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 22 )
            sijoitus:setFillColor( 0.8 )
            sijoitus.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, pisteTaulu[i], display.contentCenterX-30, yPos, native.systemFont, 22 )
            thisScore.anchorX = 0
 
        end
    end

    -- local menuButton = display.newImageRect( sceneGroup, "kuvat/btn_menu.png", 100, 50)
    -- menuButton.x = centerX
    -- menuButton.y = centerY + 200
    -- menuButton:addEventListener( "tap", gotoMenu )
	
	local menuButton = widget.newButton({
      defaultFile = "kuvat/btn_menu.png",
      overFile = "kuvat/btn_menu2.png",      
      onEvent = onMenuTouch
    }
  )
  menuButton.x = centerX
  menuButton.y = centerY +  200
  sceneGroup:insert(menuButton)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local prevScene = composer.getSceneName( "previous" )
        if(prevScene) then 
          composer.removeScene( prevScene )
        end
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "highscores" )
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene