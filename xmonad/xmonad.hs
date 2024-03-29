import System.IO
import System.Exit
import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.Volume
import XMonad.Actions.UpdateFocus
import XMonad.Actions.WindowGo
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.PerWorkspace(onWorkspace)
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
import qualified Data.Map as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--

myTerminal = "alacritty"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1","2","3","4","5","6","7","8","9"] -- ++ map show [6..9]


------------------------------------------------------------------------
-- Window rules
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
    [ resource =? "desktop_window"  --> doIgnore
    , className =? "Gimp"           --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className   =? "Download"     --> doFloat
    , className =? "Progress"       --> doFloat
    , className =? "qemu-system-x86_64" --> doFloat
    , isFullscreen                  --> doFullFloat ]

------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts. Note that each layout is separated by |||,
-- which denotes layout choice.
--
defaultLayouts = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    ThreeCol 1 (3/100) (1/2) |||
    ThreeColMid 1 (3/100) (1/2) |||
    noBorders (fullscreenFull Full)

------------------------------------------------------------------------
-- Colors and borders
--
myNormalBorderColor = "#434c5e"
myFocusedBorderColor = "#8fbcbb"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = def {
    activeBorderColor = "#8fbcbb",
    activeTextColor = "#eceff4",
    activeColor = "#000000",
    inactiveBorderColor = "#434c5e",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#a3be8c"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#eceff4"

-- Width of the window border in pixels.
myBorderWidth = 3

gsCellHeight = 73
gsCellWidth = 410
gsFont = "xft:Rye-Regular:size=14"

nordColorizerOcean = colorRangeFromClassName
        (0x2e,0x34,0x40)  -- lowest inactive bg
        (0x81,0xa1,0xc1)  -- highest inactive bg
        (0xeb,0xcb,0x8b)  -- active bg
        white             -- inactive fg
        black             -- active fg
    where black = minBound
          white = maxBound

--gsconfigWindows colorizer = (buildDefaultGSConfig colorizer)
--    {  gs_cellheight  = gsCellHeight
--    ,  gs_cellwidth   = gsCellWidth
--    ,  gs_bordercolor = "#88c0d0"
    --,  gs_font        = "xft:Ubuntu-Light:size=14"
--    ,  gs_font        = gsFont
--    }

--nordColorizerSnow = colorRangeFromClassName
--        (0xd8,0xde,0xe9)  -- lowest inactive bg
--        (0xec,0xef,0xf4)  -- highest inactive bg
--        (0xb4,0x8e,0xad)  -- active bg
--        white             -- inactive fg
--        black             -- active fg
--    where black = minBound
--          white = maxBound

--gsconfigActions colorizer = (buildDefaultGSConfig colorizer)
--    {  gs_cellheight  = gsCellHeight
--    ,  gs_cellwidth   = gsCellWidth
--    ,  gs_bordercolor = "#b48ead"
--    --,  gs_font        = "xft:Ubuntu-Light:size=14"
--    ,  gs_font        = gsFont
--    }
--
--gsconfigSelectedActions =
--  [ ("Firefox", runOrRaise "firefox" (className =? "Firefox")) ]
--
--gsconfig2 = gsconfigActions nordColorizerSnow

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt"). You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal. Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  , ((modMask, xK_f),
     runOrRaise "firefox" (className =? "Firefox"))

  --, ((modMask, xK_g),
  --   goToSelected $ gsconfigWindows nordColorizerOcean)

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  -- Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp)

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Application launcher
  , ((modMask, xK_p),
      spawn "rofi -theme base16-nord-froofy -show run")

  -- change to random wallpaper
  , ((modMask, xK_z),
      spawn "feh --bg-scale ${HOME}/captures/wallpapers/$(ls ${HOME}/captures/wallpapers | shuf -n1) &")

  -- select portion of screen for screenshot
  , ((modMask, xK_s),
      spawn "mkdir -p $HOME/captures && maim --select --bordersize=3 \
      \--color=0.706,0.557,0.678 $HOME/captures/select-screen-$(date +%Y%m%d-%H%M%S).png")

  , ((modMask .|. shiftMask, xK_l),
     spawn "xautolock -locknow")

  -- Change screen layouts
  --
  , ((modMask, xK_n),
     spawn "$HOME/.screenlayout/laptop.sh")

  , ((modMask, xK_m),
     spawn "$HOME/.screenlayout/home-laptop-closed-1-ext-samsung.sh")

  , ((modMask, xK_comma),
     spawn "$HOME/.screenlayout/home-laptop-open-1-ext.sh")

  , ((modMask, xK_period),
     spawn "$HOME/.screenlayout/office-laptop-open-2-ext.sh")

  , ((modMask, xK_slash),
     spawn "$HOME/.screenlayout/home-desktop-1-ext.sh")

  , ((modMask, xK_backslash),
     spawn "$HOME/.screenlayout/office-laptop-open-meeting-room.sh")

  -- Volume controls
  -- Turn the volume up
  , ((modMask, xK_i),
     raiseVolume 3 >> return ())

  , ((modMask .|. shiftMask, xK_i),
     raiseVolume 1 >> return ())

  -- Turn the volume down
  , ((modMask, xK_u),
     lowerVolume 3 >> return ())

  , ((modMask .|. shiftMask, xK_u),
     lowerVolume 1 >> return ())

  -- Mute the volume
  , ((modMask, xK_o),
     toggleMute    >> return ())

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q. Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    adjustEventInput
    spawn "xmodmap ~/.Xmodmap"

------------------------------------------------------------------------
-- Floats all windows in a certain workspace.
-- myLayouts
-- myLayouts = onWorkspace "three" simplestFloat $ defaultLayouts
myLayouts = defaultLayouts

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--

main = do
 xmproc <- spawnPipe "xmobar -i ~/.xmonad/icons ~/.xmobarrc"
 xmonad $ docks defaults
      { manageHook = manageDocks <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ myLayouts
      , handleEventHook = handleEventHook desktopConfig <+> focusOnMouseMove
      , logHook = dynamicLogWithPP xmobarPP
           { ppOutput  = hPutStrLn xmproc
           , ppTitle   = xmobarColor "#657b83" "" . shorten 100
           , ppCurrent = xmobarColor "#c0c0c0" "" . wrap "" ""
           , ppSep     = xmobarColor "#c0c0c0" "" " | "
           , ppUrgent  = xmobarColor "#ff69b4" ""
           , ppLayout  = const "" -- to disable the layout info on xmobar
           }
     }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = desktopConfig {
    -- simple stuff
    terminal = myTerminal,
    focusFollowsMouse = myFocusFollowsMouse,
    borderWidth = myBorderWidth,
    modMask = myModMask,
    workspaces = myWorkspaces,
    normalBorderColor = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    -- key bindings
    keys = myKeys,
    -- mouse bindings
    mouseBindings = myMouseBindings,
    -- hooks, layouts
    -- defaultLayouts = smartBorders $ myLayout,
    -- layoutHook = myLayouts,
    manageHook = myManageHook,
    startupHook = myStartupHook
}
