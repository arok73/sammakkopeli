local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local audioVolume = 0.3 --Variables to hold audio states.
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 -- These values are set for easier access later on.
local _W = display.contentWidth
centerX = display.contentCenterX
centerY = display.contentCenterY
screenLeft = display.screenOriginX
screenWidth = display.contentWidth-(display.screenOriginX*2)
screenRight = display.contentWidth - display.screenOriginX
screenTop = display.screenOriginY
screenHeight = display.contentHeight-(display.screenOriginY*2)
screenBottom = display.contentHeight-display.screenOriginY
-- -----------------------------------------------------------------------------------
-- Scene event functions

-- menu-painikkeesta mennään game sceneen
local function onPlayTouch( event )
  if ( "ended" == event.phase ) then
    composer.gotoScene("scene-game")
  end
end
-- ääni päälle/pois painikkeen 
local function onSwitchPress( event )
    local switch = event.target
    composer.setVariable( "isAudio", switch.isOn )
	local isMusic = switch.isOn
	
end

-- highscores-painikkeesta mennään highscores sceneen
local function onHighScoresTouch(event)
  if ( "ended" == event.phase ) then
    composer.gotoScene( "highscores", { time=800, effect="crossFade" }  )
  end
end

audio.setVolume( audioVolume, { channel = 2 } )

local function sliderListener( event )
	local value = event.value
		    		    
	--Convert the value to a floating point number we can use it to set the audio volume	
	audioVolume = value / 100
	audioVolume = string.format('%.02f', audioVolume )
	
				
	--Set the audio volume at the current level
   	audio.setVolume( audioVolume, { channel = 2 } )
end



-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
 
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  local background = display.newImageRect(sceneGroup, "kuvat/forest_bground_mh.png", 350, 570) 
	   background.x = centerX
	   background.y = centerY

  -- luodaan otsikko
  local title = display.newImageRect(sceneGroup, "kuvat/teksti.png", 300, 90)
	-- local title = display.newText( "HIGHSCORES" , 0, 200, "BLOODY.ttf", 50) 
	--title:setFillColor( 0, 1, 0.13 )
  	title.x = centerX
  	title.y = 60
	
	-- luodaan menu painike
	local btn_play = widget.newButton({
      --left = 200,
      --top = 350,
      defaultFile = "kuvat/btn_aloita.png",
      overFile = "kuvat/btn_aloita2.png",      
      onEvent = onPlayTouch
    }
	)
	btn_play.x = centerX
	btn_play.y = centerY -60
	sceneGroup:insert(btn_play)
	


local volumeSlider = widget.newSlider
{
	left = 60,
	top = centerY + 180,
	width = _W - 120,
	orientation = "horizontal",
	listener = sliderListener
}
sceneGroup:insert(volumeSlider)
local sliderTeksti = display.newText( "ÄÄNENVOIMAKKUUS", centerX-63, -30, native.systemFont, 18 )
sliderTeksti:setFillColor( 1, 1, 1 )
volumeSlider:insert(sliderTeksti)

-- ääni päälle/pois widget
local onOffSwitch = widget.newSwitch(
    {
        x = centerX,
        y =   centerY + 110,
        style = "onOff",
        id = "onOffSwitch",
        onPress = onSwitchPress,
        initialSwitchState = true
    }
)
sceneGroup:insert(onOffSwitch)
local ylaTeksti = display.newText( "ÄÄNITEHOSTEET", 0, -30, native.systemFont, 18 )
ylaTeksti:setFillColor( 1, 1, 1 )
onOffSwitch:insert(ylaTeksti)

local btn_highscores = widget.newButton({
      --left = 200,
      --top = 350,
      defaultFile = "kuvat/btn_highscores.png",
      overFile = "kuvat/btn_highscores2.png",      
      onEvent = onHighScoresTouch
    }
  )
  btn_highscores.x = centerX
  btn_highscores.y = centerY +  30
  sceneGroup:insert(btn_highscores)
  
local creditsText = display.newText( "© Ari Oksanen\n  HAMK 2017", centerX + 25, screenBottom - 30, 150, 40, native.systemFont, 14 )
creditsText:setFillColor( 1, 1, 1 )
sceneGroup:insert(creditsText)
 end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- This will remove the game scene when available. This is important to allow the game scene to reset itself.
		
		local backgroundMusic = audio.loadSound( "aanet/pimpoy.mp3" )
		local bgAudio = audio.play(backgroundMusic, {channel= 2, loops = -1})
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
		audio.stop(2)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
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