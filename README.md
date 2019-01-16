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

<img src="https://github.com/jonyu96/LOL-TANA/blob/master/README_resources/ezgif.com-video-to-gif.gif" width="300" height="650" />

## Machine Learning Implementation 

#### Gathering Data
Raw data was retrieved using a Python script and Riot Games Developer API. The raw data consisted of 1000 past matches of professional ADC player, C9 Sneaky. There were two reasons for this decision: 1) limiting scope of app's design and functionality to only ADC champions 2) not enough personal, past matches to be used as dataset. 

#### Data Pre-Processing 
Features were selected based on which aspects of the individual performance had the biggest impact on the game. For example, the number of kills or total creep score of a single player has a high correlation to a team's overall performance throughout the game. 

#### Developing Dataset 
Three separate datasets were created. Each dataset has a different set of features and represents a specific time mark (10/20/30 min mark). In the game, there are different objectives that can be achieved in each time period. For example, baron spawns after the 20 min mark and one of the feature values is whether or not first baron was achieved. Also, the impact or correlation between feature values and the overall win-percentage is an exponential growth with time. The number of kills of an individual player can have a greater effect on the chances of winning in the first ten miniutes than after 30 minutes. In order to create the most accurate models, three separate datasets with different features and feature values must be used. 

#### Training the Models
As a result of three separate datasets, three separate models were developed and trained using Python and Scikit-learn library. Logistic Regression models were used, which came to produce the highest accurage score. The models were then converted to CoreML models using CoreML library. These models were then imported and integrated into LOL:TANA.  
