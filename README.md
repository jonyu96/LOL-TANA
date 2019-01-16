# LOL:TANA <img width="40" height="40" src="https://github.com/jonyu96/LOL-TANA/blob/master/README_resources/LOLTANA.png">

[![Version Release](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/jonyu96/Cloud-/releases) ![build passing](https://img.shields.io/badge/build-passing-brightgreen.svg) ![platform type](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

LOL:TANA is an interactive iOS app that uses machine learning to assist League of Legends players during their live games. It acts as an AI-assistant by using the individual player's past match and in-game statistics (e.g. number of kills by 10 min mark) to generate a win percentage. Ultimately, LOL:TANA will suggest specific strategies and tips that the player can follow in order to increase this percentage. This feature will be implemented in the future. 


## Current Features

* Allows users to choose one of 21 available ADC (attack damage carry) champions 
* Displays initial win percentage based on current win-rate of selected champion (win-rate retrieved using Champion.gg API)
* User can input the following in-game statistics:

  - number of kills 
  - number of deaths 
  - number of assists
  - creep score (CS)
  - lane matchup's creep score (CS)
  - number of completed items 
  - number of dragons 
  - first blood (true/false)
  - first tower (true/false)
  - rift herald killed (true/false)
  - first baron (true/false)
  - first inhibitor (true/false) 

* Tapping on pulsating percentage icon will generate a win percentage based on input feature values

## Demo 

