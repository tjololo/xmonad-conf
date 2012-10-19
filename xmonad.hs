import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion

----------------------------------------------------------------------------------------
--------				Workspaces				--------
----------------------------------------------------------------------------------------
myWorkspaces = ["1:main","2:web","3:chat","4:dev","5:media","6:div","7","8","9:minimized"]

----------------------------------------------------------------------------------------
--------				Shift/Float				--------
----------------------------------------------------------------------------------------
myManageHooks = composeAll
        [ isFullscreen --> doFullFloat
	, className =? "Chromium" --> doShift "2:web"
	, className =? "Vlc" --> doShift "5:media"
	, className =? "Dia" --> doShift "4:dev"
	, className =? "jetbrains-idea-ce" --> doShift "4:dev"
	, className =? "Spotify" --> doShift "5:media"
	, className =? "jetbrains-idea-ce" --> doFloat
	, className =? "Gimp" --> doFloat
	, className =? "Dia" --> doFloat
         -- skipped
        ]

----------------------------------------------------------------------------------------
--------				Statusbar				--------
----------------------------------------------------------------------------------------
customPP = defaultPP
		{ ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
		, ppHiddenNoWindows = id . xmobarColor "#777777" ""
		, ppLayout = const ""
		, ppTitle = xmobarColor "#ee9a44" "" . shorten 65
		, ppSep = " |     "
		}

----------------------------------------------------------------------------------------
--------				Layout					--------
----------------------------------------------------------------------------------------
myLayoutHook = tiled ||| noBorders Full ||| tabbed shrinkText defaultTheme ||| Accordion
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

----------------------------------------------------------------------------------------
--------				Main					--------
----------------------------------------------------------------------------------------
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/tjololo/.xmobarrc"
    xmproc <- spawnPipe "/usr/bin/xscreensaver -nosplash"
    xmproc <- spawnPipe "/usr/bin/udiskie"
    xmonad $ defaultConfig
        { workspaces = myWorkspaces
	,manageHook = manageDocks <+> myManageHooks
			<+> manageHook defaultConfig
--        , layoutHook = avoidStruts  $  layoutHook defaultConfig ||| noBorders Full
	, layoutHook = avoidStruts $ smartBorders (myLayoutHook)
	, logHook = dynamicLogString customPP >>= xmonadPropLog -- dbusLog client >> takeTopFocus
        , modMask = mod4Mask --Rebind Mod to windows key
	, terminal = "xterm -bg black -fg green"
--	, terminal = "urxvt"
	, normalBorderColor = "#222222"
	, focusedBorderColor = "#00EE00"
	, startupHook = setWMName "LG3D"
        } `additionalKeys`

----------------------------------------------------------------------------------------
--------				Shortcuts				--------
----------------------------------------------------------------------------------------
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask .|. shiftMask, xK_f), spawn "chromium")
	, ((mod4Mask .|. shiftMask, xK_s), spawn "chromium --proxy-server=socks://localhost:8080")
	, ((mod4Mask .|. shiftMask, xK_t), spawn "thunar")
	, ((mod4Mask .|. shiftMask, xK_v), spawn "vlc")
	, ((mod4Mask .|. shiftMask, xK_m), spawn "xterm alsamixer")
	, ((mod4Mask, xK_s), spawn "spotify")
	, ((0 , 0x1008ff12), spawn "amixer -q set Master toggle")
	, ((0 , 0x1008ff11), spawn "amixer -q set Master 1- unmute")
	, ((0 , 0x1008ff13), spawn "amixer -q set Master 1+ unmute")
        ]
