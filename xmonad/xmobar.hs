--------------------------------------------------------------------------
-- |
-- Copyright: (c) 2019, 2020 Drew Smathers
-- License: MIT
--
-- Maintainer: drew.smathers@gmail.com
-- Stability: unstable
-- Portability: linux
-- |
--------------------------------------------------------------------------


Config {
    font = "xft:audiowide-regular:pixelsize=15:antialias=true"
  , bgColor = "#2e3440"
  , fgColor = "#eceff4"
  , border = NoBorder
  , hideOnStart = False
  , persistent = True
  , position = Top
  , lowerOnStart = True
  , overrideRedirect = False
  , allDesktops = True
  , commands =
     [
     -- Kernel
       Run Com "uname" ["-r"] "kernel" 10
     -- Seattle Weather
     , Run Weather "KSEA" [ "--template", "SEA: <fc=#4c566a><tempF>°F</fc>"
                          , "--Low"    , "50"
                          , "--High"   , "77"
                          , "--normal" , "#81a1c1"
                          , "--high"   , "#d08770"
                          , "--low"    , "#88c0d0"
                          ] 10
     , Run Weather "KATL" [ "--template", "ATL: <fc=#4c566a><tempF>°F</fc>"
                          , "--Low"    , "50"
                          , "--High"   , "77"
                          , "--normal" , "#81a1c1"
                          , "--high"   , "#d08770"
                          , "--low"    , "#88c0d0"
                          ] 10
     -- CPU activity monitor
     , Run Cpu [ "--template", "Cpu: <fc=#4c566a><total>%</fc>"
               , "--Low"     , "20"
               , "--High"    , "80"
               , "--low"     , "#a3be8c"
               , "--normal"  , "#d08770"
               , "--high"    , "#bf616a"
               ] 10
     , Run MultiCoreTemp [ "--template"  , "Temp: <fc=#4c566a><max>°C <avg>°C</fc>"
                         , "--Low"     , "55"
                         , "--High"    , "80"
                         , "--low"     , "#88c0d0"
                         , "--normal"  , "#d08770"
                         , "--high"    , "#bf616a"
                         ] 10
     -- Memory Usage monitor
     , Run Memory [ "--template" , "Mem: <fc=#4c566a><usedratio>%</fc>"
                  ,  "--Low"     , "20"
                  , "--High"     , "80"
                  , "--low"      , "#a3be8c"
                  , "--normal"   , "#d08770"
                  , "--high"     , "#bf616a"
                  ] 10
     -- Battery monitor
     , Run Battery [ "--template" , "Batt: <fc=#4c566a><acstatus>\\<left>%</fc>"
                   , "--Low"      , "10"   -- units: %
                   , "--High"     , "80"   -- units: %
                   , "--low"      , "#bf661a"
                   , "--normal"   , "#ebcb8b"
                   , "--high"     , "#a3be8c"
                   , "--" -- battery specific options
                          -- discharging status
                          , "-o"  , "<fc=#d08770>Charging</fc>"
                          -- charged status
                          , "-i"  , "<fc=#a3be8c>Charged</fc>"
                   ] 50
     -- Network monitoring
     , Run DynNetwork [ "--template", "Net: <fc=#4c566a><tx>kB/s|<rx>kB/s</fc>"
                      , "--Low"     , "1000"          -- units: B/s
                      , "--High"    , "10000000"      -- units: B/s
                      , "--low"     , "#a3be8c"
                      , "--normal"  , "#d08770"
                      , "--high"    , "#bf616a"
                      ] 10
     -- Disk Usage
     , Run DiskU [ ("/"     , "Disk: <fc=#4c566a>/ <usedp>%</fc>")
                 , ("/boot" , "<fc=#4c566a> /boot <usedp>%</fc>")
                 ]
                 [ "--Low"       , "55"
                 , "--High"      , "85"
                 , "--low"       , "#a3be8c"
                 , "--normal"    , "#d08770"
                 , "--high"      , "#bf616a"
                 ] 50
     -- Volume
     , Run Volume "default" "Master" [ "--template"  , "Vol: <fc=#b48ead><volume>%</fc> <status>"
                                     , "--"
                                     , "--onc"       , "#a3be8c"
                                     , "--offc"      , "#bf616a"
                                     ] 3
     -- Date and time
     , Run Date "<fc=#88c0d0>%a %b %_d %Y %H:%M</fc>" "date" 10
     , Run StdinReader
     ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = " <icon=nixos.xpm/> %StdinReader% }{ \
                \%battery% | %cpu% | %memory% | %multicoretemp% | %disku% | %dynnetwork% | \
                \%KSEA% %KATL% | %default:Master% | %date% | \
                \<icon=tux.xpm/> <fc=#ebcb8b>%kernel%</fc> "
}
