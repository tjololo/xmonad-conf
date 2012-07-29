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


myWorkspaces = ["1:main","2:web","3:chat","4:dev","5:media","6","7","8","9:minimized"]
myManageHooks = composeAll
        -- [ isFullscreen --> (doF W.focusDown <+> doFullFloat)

        [ isFullscreen --> doFullFloat
	, className =? "Chromium" --> doShift "2:web"
	, className =? "Vlc" --> doShift "5:media"
	, className =? "Dia" --> doShift "4:dev"
	, className =? "jetbrains-idea-ce" --> doShift "4:dev"
	, className =? "jetbrains-idea-ce" --> doFloat
	, className =? "Gimp" --> doFloat
	, className =? "Dia" --> doFloat
         -- skipped
        ]

customPP = defaultPP
		{ ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
		, ppHiddenNoWindows = id . xmobarColor "#777777" ""
		, ppLayout = const ""
		, ppTitle = xmobarColor "#ee9a44" "" . shorten 70
		, ppSep = " |     "
		}

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/tjololo/.xmobarrc"
    xmproc <- spawnPipe "/usr/bin/xscreensaver -nosplash"
    xmproc <- spawnPipe "/usr/bin/udiskie"
    xmonad $ defaultConfig
        { workspaces = myWorkspaces
	,manageHook = manageDocks <+> myManageHooks
			<+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
	, logHook = dynamicLogString customPP >>= xmonadPropLog
        , modMask = mod4Mask --Rebind Mod to windows key
	, terminal = "xterm -bg black -fg green"
	, normalBorderColor = "#222222"
	, focusedBorderColor = "#444444"
	, startupHook = setWMName "LG3D"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask .|. shiftMask, xK_f), spawn "chromium")
	, ((mod4Mask .|. shiftMask, xK_t), spawn "thunar")
	, ((mod4Mask .|. shiftMask, xK_v), spawn "vlc")
	, ((mod4Mask .|. shiftMask, xK_m), spawn "xterm alsamixer")
        ]
