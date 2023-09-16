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
-- font = "xft:Audiowide-Regular:pixelsize=12:antialias=true"
    font = "Audiowide Normal Thin 11"
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
       Run Com "uname" ["-r"] "kernel" 3600
     -- Hostname
     , Run Com "hostname" [] "hostname" 3600
     -- VPN Tunneled status
     , Run Com "/home/dsmather/bin/show_tunnel_on" [] "tunnel_on" 50
     , Run Com "/home/dsmather/bin/show_tunnel_off" [] "tunnel_off" 50
     -- Audio Sink Name
     , Run Com "/home/dsmather/bin/default-audio-sink-name" [] "default_audio_sink_name" 50
     -- Seattle Weather
     , Run Weather "KSEA" [ "--template", "SEA: <fc=#4c566a><tempF>°F</fc>"
                          , "--Low"    , "50"
                          , "--High"   , "77"
                          , "--normal" , "#81a1c1"
                          , "--high"   , "#d08770"
                          , "--low"    , "#88c0d0"
                          ] 1200
     , Run Weather "KATL" [ "--template", "ATL: <fc=#4c566a><tempF>°F</fc>"
                          , "--Low"    , "50"
                          , "--High"   , "77"
                          , "--normal" , "#81a1c1"
                          , "--high"   , "#d08770"
                          , "--low"    , "#88c0d0"
                          ] 1200
     -- CPU activity monitor
     , Run Cpu [ "--template", "C: <fc=#4c566a><total>%</fc>"
               , "--Low"     , "20"
               , "--High"    , "80"
               , "--low"     , "#a3be8c"
               , "--normal"  , "#d08770"
               , "--high"    , "#bf616a"
               ] 10
     -- Core Temperatures
     , Run MultiCoreTemp [ "--template"  , "T: <fc=#4c566a><max>°C <avg>°C</fc>"
                         , "--Low"     , "55"
                         , "--High"    , "80"
                         , "--low"     , "#88c0d0"
                         , "--normal"  , "#d08770"
                         , "--high"    , "#bf616a"
                         ] 10
     -- Memory Usage monitor
     , Run Memory [ "--template" , "M: <fc=#4c566a><usedratio>%</fc>"
                  ,  "--Low"     , "20"
                  , "--High"     , "80"
                  , "--low"      , "#a3be8c"
                  , "--normal"   , "#d08770"
                  , "--high"     , "#bf616a"
                  ] 10
     -- Battery monitor
     , Run Battery [ "--template" , "B: <fc=#4c566a><acstatus>\\<left>%</fc>"
                   , "--Low"      , "10"   -- units: %
                   , "--High"     , "80"   -- units: %
                   , "--low"      , "#bf661a"
                   , "--normal"   , "#ebcb8b"
                   , "--high"     , "#a3be8c"
                   , "--" -- battery specific options
                          -- discharging status
                          , "-o"  , "<fc=#d08770>Charged</fc>"
                          -- charged status
                          , "-i"  , "<fc=#a3be8c>Charged</fc>"
                   ] 50
     -- Network monitoring
     , Run DynNetwork [ "--template", "N: <fc=#4c566a><tx>kB/s|<rx>kB/s</fc>"
                      , "--Low"     , "80000"          -- units: B/s
                      , "--High"    , "10000000"       -- units: B/s
                      , "--low"     , "#a3be8c"
                      , "--normal"  , "#d08770"
                      , "--high"    , "#bf616a"
                      ] 10
     -- Wireless Network Interface information
     , Run Wireless "{wiiface}" [ "--template" , "<essid> <fc=#4c566a><quality></fc>" ] 50
     -- Disk Usage
     , Run DiskU [ ("/"     , "D: <fc=#4c566a>/ <usedp>%</fc>")
                 , ("/boot" , "<fc=#4c566a> /boot <usedp>%</fc>")
                 ]
                 [ "--Low"       , "55"
                 , "--High"      , "85"
                 , "--low"       , "#a3be8c"
                 , "--normal"    , "#d08770"
                 , "--high"      , "#bf616a"
                 ] 50
     -- Disk IO
     , Run DiskIO [ ("/", "IO: <fc=#4c566a><read> <write></fc>") ]
                  [ "--Low"     , "2000"
                  , "--High"    , "100000"
                  , "--low"     , "#a3be8c"
                  , "--normal"  , "#d08770"
                  , "--high"    , "#bf616a"
                  ] 30
     -- Volume
     , Run Alsa "default" "Master" [ "--template"  , "V: <fc=#b48ead><volume>%</fc> <status>"
                                     , "--"
                                     , "--onc"       , "#a3be8c"
                                     , "--offc"      , "#bf616a"
                                     ]
     -- Date and time
     , Run Date "<fc=#88c0d0>%a %b %_d %Y %H:%M %Z</fc>" "date" 10
     -- Spotify - Currently playing
     , Run StdinReader
     ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "} <icon=nixos.xpm/> %StdinReader% %hostname% <fc=#ebcb8b>%tunnel_on%</fc><fc=#4c566a>%tunnel_off%</fc> \
                \ <fc=#b48ead>%default_audio_sink_name%</fc> { \
                \ %battery% | %cpu% | {temp}%memory% | %disku% | %diskio% | \
                \%dynnetwork% | %{wiiface}wi% | \
                \%KSEA% %KATL% | %alsa:default:Master% | %date% | \
                \<icon=tux.xpm/> <fc=#ebcb8b>%kernel%</fc> "
}
