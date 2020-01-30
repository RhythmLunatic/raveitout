# Rave It Out: Weaboo Edition
This is a StepMania theme that's mainly for the 'pump' game mode.

# Features
- Customizable loading screen wallpapers: Put as many wallpapers as you want in Graphics/_RandomWalls/HDWalls/ to have them show up.
- Favorites folder: Press DownLeft+DownRight during evaluation to favorite a song. A favorites folder will appear in the group select.
- Change Sort: Folders to change the sort are in the music wheel. Sort by group, title, artist name, origin/year, or level singles or level doubles.
- Auto Velocity: Set the speed of the notes to whatever you prefer.
- Target Score Graph: Target your best score, machine best score, or a percentage (70%, 80%, 90%, 95%, 100%)
- Customizable Judgment Graphic: Choose from a variety of options to change how the judgment graphic looks when you hit a note.
- Fast/Slow (Pro Mode only): Show Fast or Slow if you hit a note fast or slow. Shows the number of fasts and slows you get during results.
- Extra Stage: While Event Mode is off, get >90% accuracy in a song to obtain a bonus heart. Obtain two to bonus hearts to play an extra stage.
- One More Extra Stage/Encore Extra Stage/Special Stage: If you have a extra1.crs in the song group, it is the designated Extra Stage. If you get >95% in the Extra Stage, you will be taken to the OMES, which is defined in 01 SYSTEM_PARAMETERS.lua.
- Customizable song related items: Show a special background in the loading screen after playing a song, show a message before playing a song, etc... Check Song Structure Documentation.txt for more information.
- Quest Mode: Play through some missions. Since this requires having the songs, I'd leave this disabled.
- Card Reader support: Join in with a supported card and card reader. You need the RIO fork to use this feature.
- USB Profile support: This theme fully supports USB profiles including a screen for setting your name. (USB song loading coming soon!)

## Usage
Works on 5.1-new+ only. Auto Velocity will not work if you do not compile the [latest 5.1-new branch](https://github.com/stepmania/stepmania/tree/5_1-new) of StepMania or [the RIO fork](https://github.com/RhythmLunatic/stepmania/tree/starworlds). My fork is required to use level sort and card readers.

Configure the groups for Easy and Special mode in 01 SYSTEM_PARAMETERS.lua.

Supports Dance and Pump mode, although the graphics will still be for pump. (May support other modes too, but you'll probably get some bugs)

## Configuration

Check the operator menu. Edit 01 SYSTEM_PARAMETERS.lua.

## Adding new songs

Check Song Structure Documentation.txt.

## Who worked on this?

Check BGAnimations/ScreenCredits Overlay/default.lua for credits and open source libraries used.
