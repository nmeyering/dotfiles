--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import System.Exit
import System.IO
import XMonad
import XMonad.Actions.WindowGo
import XMonad.Config.Kde
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.WindowNavigation
import XMonad.Operations
import XMonad.Util.EZConfig
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Layout.Tabbed
import XMonad.Hooks.ICCCMFocus
import qualified XMonad.StackSet as W -- to shift and float windows
import qualified Data.Map        as M

myXmonadBar = "dzen2 -x '0' -y '0' -h '12' -w '1280' -ta 'l' -bg '#002b36' -fg '#657b83'"
myStatusBar = "conky -c /home/niels/.xmonad/.conky_dzen | dzen2 -x '1280' -w '1280' -h '12' -ta 'r' -bg '#002b36' -fg '#657b83' -y '0'"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal		= "urxvt"

-- Width of the window border in pixels.
--
myBorderWidth	= 0

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask		= mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2		 Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
--myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces	= ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#002b36"
myFocusedBorderColor = "#657b83"

-- Default offset of drawable screen boundaries from each physical
-- screen. Anything non-zero here will leave a gap of that many pixels
-- on the given edge, on the that screen. A useful gap at top of screen
-- for a menu bar (e.g. 15)
--
-- An example, to set a top gap on monitor 1, and a gap on the bottom of
-- monitor 2, you'd use a list of geometries like so:
--
-- > defaultGaps = [(18,0,0,0),(0,18,0,0)] -- 2 gaps on 2 monitors
--
-- Fields are: top, bottom, left, right.
--

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

	-- launch a terminal
	[ ((modMask, xK_c), spawn $ XMonad.terminal conf)

	-- launch dmenu
	--, ((modMask,				 xK_r	  ), spawn "exe=`cat dmenu_stuff | dmenu` && eval \"exec $exe\"")
	-- , ((modMask,				  xK_r	   ), shellPrompt defaultXPConfig)
	, ((modMask,								xK_p		 ), spawn "dmenu_run -b" )

	-- launch gmrun
	--, ((modMask .|. shiftMask, xK_p	  ), spawn "gmrun")

	-- close focused window 
	, ((modMask .|. shiftMask, xK_c		), kill)

	 -- Rotate through the available layout algorithms
	, ((modMask,			   xK_space ), sendMessage NextLayout)

	-- screenshot
	, ((modMask,			   xK_Print		), spawn "exe=`scrot -e \'mv $f ~/.screenshots/\'` && eval \"exec $exe\"")
	, ((modMask	.|. shiftMask,	xK_s), spawn "exec xscreensaver-command -l" )

	--	Reset the layouts on the current workspace to default
	, ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

	-- Resize viewed windows to the correct size
	--, ((modMask,				 xK_n	  ), refresh)

	, ((modMask,				 xK_h	 ), sendMessage $ Go L)
	, ((modMask,				 xK_j	 ), sendMessage $ Go D)
	, ((modMask,				 xK_k	 ), sendMessage $ Go U)
	, ((modMask,				 xK_l	 ), sendMessage $ Go R)

	-- Move focus to the next window
	, ((modMask,			   xK_Tab	), windows W.focusDown)

	-- Move focus to the next window
	, ((modMask,			   xK_n		), windows W.focusDown)

	-- Move focus to the previous window
	--, ((modMask,				 xK_p	  ), windows W.focusUp	)

	-- Move focus to the master window
	--, ((modMask,				 xK_m	  ), windows W.focusMaster	)

	-- Swap the focused window and the master window
	, ((modMask,			   xK_Return), windows W.swapMaster)

	-- Swap the focused window with the next window
	, ((modMask .|. shiftMask,	xK_j), windows W.swapDown  )

	-- Swap the focused window with the previous window
	, ((modMask .|. shiftMask,	xK_k), windows W.swapUp    )

	-- Shrink the master area
	, ((modMask .|. shiftMask,	xK_k), sendMessage Shrink)

	-- Expand the master area
	, ((modMask .|. shiftMask,	xK_l), sendMessage Expand)

	-- Push window back into tiling
	, ((modMask,				xK_t), withFocused $ windows . W.sink)

	-- run or raise firefox
	-- , ((modMask				 , xK_f), runOrRaise "/usr/lib/firefox/firefox" (className =? "Firefox"))

	-- Increment the number of windows in the master area
	, ((modMask				 , xK_comma ), sendMessage (IncMasterN 1))

	-- Deincrement the number of windows in the master area
	, ((modMask				 , xK_period), sendMessage (IncMasterN (-1)))

	-- Quit xmonad
	, ((modMask .|. shiftMask, xK_q		), io (exitWith ExitSuccess))

	-- Restart xmonad
	, ((modMask				 , xK_q		), restart "xmonad" True)

	, ((modMask				 , xK_o		), pasteSelection)
	]
	++

	--
	-- mod-[1..9], Switch to workspace N
	-- mod-shift-[1..9], Move client to workspace N
	--
	[((m .|. modMask, k), windows $ f i)
		| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
		, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
	-- ++

	--
	-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
	-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
	--
	--[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
	--	  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
	--	  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

	-- mod-button1, Set the window to floating mode and move by dragging
	[ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

	-- mod-button2, Raise the window to the top of the stack
	, ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

	-- mod-button3, Set the window to floating mode and resize by dragging
	, ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

	-- you may also bind events to the mouse scroll wheel (button4 and button5)
	]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- myLayout = tiled ||| Mirror tiled ||| Full
myLayout = lessBorders OnlyFloat $ avoidStruts $ windowNavigation(Full ||| Grid ||| tiled) -- ||| Mirror tiled
  where
	 -- default tiling algorithm partitions the screen into two panes
	 tiled	 = Tall nmaster delta ratio

	 -- The default number of windows in the master pane
	 nmaster = 1

	 -- Default proportion of screen occupied by master pane
	 ratio	 = 1/2

	 -- Percent of screen to increment by when resizing panes
	 delta	 = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
	[ className =? "Gimp"			--> doFloat
	, resource	=? "desktop_window" --> doIgnore
	, resource	=? "kdesktop"		--> doIgnore
	, className =? "mpv" --> doFloat
	, className =? "csgo_linux" --> doFullFloat
	, className =? "csgo_linux" --> doShift "5"
	, (className =? "Steam" <&&> title =? "Chat") --> doShift "4"
	, composeOne [ isFullscreen -?> doFullFloat ]
	]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
	{
		ppCurrent			=	dzenColor "white" "#002b36" . pad
	  , ppVisible			=	dzenColor "magenta" "#002b36" . pad
	  , ppHidden			=	dzenColor "#586e75" "#002b36" . pad
	  , ppHiddenNoWindows	=	dzenColor "#073642" "#002b36" . pad
	  , ppUrgent			=	dzenColor "#93a1a1" "#586e75" . pad
	  , ppWsSep				=	" "
	  , ppSep				=	"  |  "
	  , ppTitle				=	(" " ++) . dzenColor "#657b83" "#002b36" . dzenEscape
	  , ppOutput			=	hPutStrLn h
	}

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
	dzenRightBar <- spawnPipe myStatusBar
	dzenLeftBar <- spawnPipe myXmonadBar
	xmonad $ defaultConfig
		{
	  -- simple stuff
		terminal		   = myTerminal,
		focusFollowsMouse  = myFocusFollowsMouse,
		borderWidth		   = myBorderWidth,
		modMask			   = myModMask,
		--numlockMask		 = myNumlockMask,
		workspaces		   = myWorkspaces,
		normalBorderColor  = myNormalBorderColor,
		focusedBorderColor = myFocusedBorderColor,

	  -- key bindings
		keys			   = myKeys,
		mouseBindings	   = myMouseBindings,

	  -- hooks, layouts
		layoutHook			= myLayout,
		manageHook			= myManageHook,
		logHook				= myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd >> takeTopFocus,
		startupHook			= setWMName "LG3D"
		}
