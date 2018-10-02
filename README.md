<p align="center"><img alt="react-native-game-center" src="snapshots/react-native-game-center.jpg" width="308"></p><p align="center">Meet react-native-game-center</p>
<a href=""https://npmjs.org/package/react-native-game-center"><img  src="https://img.shields.io/github/downloads/atom/atom/latest/total.svg"></a>
<a href="https://npmjs.org/package/react-native-game-center"><img alt="npm version" src="http://img.shields.io/npm/v/react-native-game-center.svg?style=flat-square"></a>
<a href="https://npmjs.org/package/react-native-game-center"><img alt="npm version" src="http://img.shields.io/npm/dm/react-native-game-center.svg?style=flat-square"></a>


# React Native Game Center


<p align="center">
<img alt="app" src="snapshots/app.png"/>
<img alt="achivements" src="snapshots/app-achivements.png"/>
<img alt="leaderboard" src="snapshots/app-leaderboard.png"/>
<img alt="ifnotloggedin" src="snapshots/ifnotloggedin.png"/>

</p>


# Status

This is a fork of `garrettmac/react-native-game-center`. It contains some further work, as well as some refactoring. It is, however, a work in progress, and some features beyond simple login (leatherboards) may not work correctly in it's current state. Patches are welcome! It is not currently published on npm.


# Contents

- [Installation](#installation)
- [Getting Started](#example-project)
- [Basic Usage](#basic-usage)
- [Init Method](#init-method)
- [Player Methods](#player-methods)
- [Leaderboard Methods](#leaderboard-methods)  
- [Achievements Methods](#achievements-methods)  


# Installation

In your project root, run:

```bash
yarn add react-native-game-center
react-native link react-native-game-center
```

If you need help setting up GameCenter within iTunes Connect, see [SETUP.md](SETUP.md).


# Example Project

You may want to clone this repo and play with the example project:

```bash
$ git clone https://github.com/miracle2k/react-native-game-center
$ cd react-native-game-center/GameCenterExample
$ yarn install
$ npm start
```


# Basic Usage

```bash
import GameCenter from "react-native-game-center"


// The event handler will be called whenever the authentication status changes,
// and often, when it did not. For example, every time your app returns from
// the background, GameKit will call this, because the user may have logged out.
GameCenter.addListener('onAuthenticate', ({isAuthenticated}) => {
  if (!isAuthenticated) {
    Logout();
  }  
});


// There are two ways to get started:


// The init method will check if the user is already logged in, and if so, the
// user will see a "Welcome back" message from GameCenter. The promise will 
// tell if whether they are or are not authenticated.
//
// If they are, you can then do things like call `getPlayer()`.
      
GameCenter.init().then(({isAuthenticated}) => {
  ...
});


// The authenticate method can be called in addition or instead of "init": It
// will, if the user is not logged in, show the GameCenter login screen.
```


# init() <Promise?>

Initializes GameCenter functionality, and immediately tries to see if the current user 
is already logged into your app. If so, GameKit will show a "Welcome back" message. If
the user is not yet authenticated, you can call `authenticate()` to show the login
screen.


```jsx
GameCenter.init()
  .then(console.log)
  .catch(console.warn)

```

# authenticate() <Promise?>

Same as `init()`, but will show a GameCenter login screen if the user is not yet authorized.


```jsx
GameCenter.authenticate()
  .then(console.log)
  .catch(console.warn)

```


# Player Methods

[Player Methods](#player-methods)
 * [getPlayer <Promise?>](#getplayer--promise--)
 * [getPlayerImage <Promise?>](#getplayerimage--promise--)     
 * [getPlayerFriends](#getplayerfriends)


## getPlayer <Promise?>

Returns the authenticated user, or `null` if no user is authenticated.


#### Basic Usage

```jsx
  GameCenter.getPlayer().then(player=>{
      console.log("player: ", player);
  })
```

#### Response

```json
{alias: "Garrettmacmac", displayName: "Me", playerID: "G:8135064222"}
```


## getPlayerImage <Promise?>


#### Details

Gets logged player image if available.
Most players don't have one.

#### Parameters

No Parameters

#### Usage

```jsx
  GameCenter.getPlayerImage().then(image=>{
      console.log("image: ", image);
  })
```
####  Success Response

```json
{image: "/path/to/image.png"}
```
####  Failed Response

```json
Error fetching player image
```


### getPlayerFriends

#### Details

Gets a list of players.
Most games don't have this anymore as Apple took away the game center App.
Now you see lots of users connect via Facebook, SMS and by geolocation.

#### Parameters

No Parameters

#### Usage

```jsx
  GameCenter.getPlayerFriends().then(friends=>{
      console.log("friends: ", friends);
  })
```

####  Response
I don't know what this looks like, as I don't have friends 😫 and Apple said they are depreciating support for this is new versions.

**Success**
```json
[...array of friends]
```
or

```json
undefined
```

**Failed**

```json
Error fetching player friends
```





# Leaderboard Methods


- [Leaderboard Methods](#leaderboard-methods)
  * [openLeaderboardModal <Promise?>](#openleaderboardmodal--promise--)
      - [Details](#details-4)
      - [Parameters](#parameters-4)
      - [Usage](#usage-3)
      - [Success Response](#success-response-1)
      - [Failed Response](#failed-response-1)
  * [submitLeaderboardScore <Promise?>](#submitleaderboardscore--promise--)
      - [Details](#details-5)
      - [Parameters](#parameters-5)
      - [Usage](#usage-4)
      - [Response](#response-2)
  * [getLeaderboardPlayers <Promise?>](#getleaderboardplayers--promise--)
      - [Details](#details-6)
      - [Parameters](#parameters-6)
      - [Usage](#usage-5)
      - [Response](#response-3)



## openLeaderboardModal <Promise?>

#### Details

Opens Game Center Modal on Leaderboard Page

#### Parameters

No Parameters

#### Usage

```jsx
  GameCenter.openLeaderboardModal()
  .then(success=>{})//is open
  .catch(error=>{})//could not open

```

#### Success Response

```json
opened leaderboard modal
```
#### Failed Response

```json
opened leaderboard modal
```



## submitLeaderboardScore <Promise?>

#### Details
Submit progress of users leaderboard

#### Parameters

| Name  | Required | Default    | Description |
|--------------|--------------|--------------|--------------|
| score |  Yes | n/a | some number to track for leaderboard    |
| leaderboarIdentifier |  No* (see Response) | `leaderboarIdentifier` set up in Itunes Connect  |


#### Usage




**Basic**

```jsx
let options={score:50};

//reverts to default leaderboarIdentifier set up in init()
GameCenter.submitLeaderboardScore(options)
//now update state
this.setState(options)
```

**Advanced**
```jsx
let options={
  score:50,
  leaderboarIdentifier:"some_other_leaderboard"
};

GameCenter.submitLeaderboardScore(options)
  .then(res=>{
    if(res==="Successfully submitted score")
          this.setState({score:50})
  })
  .catch(console.warn("Users progress is not being tracked due to error."))

```


#### Response

**Success**

```json
"Successfully submitted score"
```


**Failed**

```json
"Error submitting score."
```

## getLeaderboardPlayers <Promise?>

#### Details
Get information about certain player ids on the leaderboard

#### Parameters

| Name  | Required | Default    | Description |
|--------------|--------------|--------------|--------------|
| playerIds[] |  Yes | n/a | An array of player ids to recieve data for |
| leaderboardIdentifier |  No if set in init | Set in init |`leaderboardIdentifier` set up in Itunes Connect  |


#### Usage



**Basic**
```jsx
let options={
  playerIds: ["player_1","player_2"], //Please note that this is the player id as set by apple and not the user name
  leaderboarIdentifier:"some_other_leaderboard" //Optional
};

GameCenter.getLeaderboardPlayers(options)
  .then(res=>{
    this.setState({players:res})
  })
  .catch(console.warn("Leaderboard fetch failed"))

```


#### Response

**Success**

```json
[
  {
    "rank":"rank of player on global leaderboard",
    "value":"score of the player on the leaderboard",
    "displayName":"display name of the player",
    "alias":"alias of the player",
    "playerID":"id of the player"
  }
]
```


**Failed**

```json
"Error getting leaderboard players."
```


## getTopLeaderboardPlayers <Promise?>

#### Details
Get information about top players on the leaderboard

#### Parameters

| Name  | Required | Default    | Description |
|--------------|--------------|--------------|--------------|
| count |  Yes | n/a | Anmount of top players to fetch |
| leaderboardIdentifier |  No if set in init | Set in init |`leaderboardIdentifier` set up in Itunes Connect  |


#### Usage



**Basic**
```jsx
let options={
  count:4,
  leaderboarIdentifier:"some_other_leaderboard" //Optional
};

GameCenter.getLeaderboardPlayers(options)
  .then(res=>{
    this.setState({topPlayers:res})
  })
  .catch(console.warn("Leaderboard fetch failed"))

```


#### Response

**Success**

```json
[
  {
    "rank":"rank of player on global leaderboard",
    "value":"score of the player on the leaderboard",
    "displayName":"display name of the player",
    "alias":"alias of the player",
    "playerID":"id of the player"
  }
]
```


**Failed**

```json
"Error getting top leaderboard players."
```




# Achievements Methods

- [Achievements Methods](#achievements-methods)
  * [openAchievementModal <Promise?>](#openachievementmodal--promise--)
      - [Details](#details-6)
      - [Parameters](#parameters-6)
      - [Usage](#usage-5)
      - [Response](#response-3)
  * [getAchievements <Promise?>](#getachievements--promise--)
      - [Details](#details-7)
      - [Parameters](#parameters-7)
      - [Usage](#usage-6)
      - [Response](#response-4)
  * [resetAchievements <Promise?>](#resetachievements--promise--)
      - [Details](#details-8)
      - [Parameters](#parameters-8)
      - [Usage](#usage-7)
      - [Response](#response-5)
  * [submitAchievementScore <Promise?>](#submitachievementscore--promise--)
      - [Details](#details-9)
      - [Parameters](#parameters-9)
      - [Usage](#usage-8)
      - [Response](#response-6)

## openAchievementModal <Promise?>

#### Details

Opens Game Center Modal on Leaderboard Page

#### Parameters

No Parameters

#### Usage

```jsx
  GameCenter.openAchievementModal()
  .then(success=>{})//is open
  .catch(error=>{})//could not open

```

#### Response

**Success**

```json
opened achievement modal
```

**Failed**

```json
opened achievement modal
```



## getAchievements <Promise?>

#### Details

Gets players achievements if completed more than 0%.
You must declare `submitAchievementScore` at least once before calling this.

#### Parameters

No Parameters

#### Usage

```jsx
  GameCenter.getAchievements()
  .then(achievements=>{
    console.log(achievements)
    })
  .catch(error=>{})//failed

```

#### Response

```json
[{"showsCompletionBanner":false,"lastReportedDate":1506301241432,"completed":true,"percentComplete":100,"identifier":"novice_award"},{"showsCompletionBanner":false,"lastReportedDate":1506301211362,"completed":false,"percentComplete":5,"identifier":"pro_award"}]
```

or

```json
[]
```



## resetAchievements <Promise?>

> [![Reset Achievements](snapshots/resetAchievements.png)]

#### Details

Resets the players achievements.

#### Parameters


| Name  | Required | Default    | Description |
|--------------|--------------|--------------|--------------|
| hideAlert |  No | `{hideAlert:false}` | Hide reset confirmation prompt   |


#### Usage

**Basic**

```jsx
  //Triggers confirmation prompt
  GameCenter.resetAchievements()

  // hides confirmation prompt
  GameCenter.resetAchievements({hideAlert:true})
```
**Advanced**
```jsx
  GameCenter.resetAchievements(res=>{
    if(res.resetAchievements){
      do something if user reset achievements
    }
  })
  .catch(alert("Could not reset achievements at this time. Try again later."))
```

#### Response

If you pass in `{hideAlert:true}` into `GameCenter.resetAchievements()` Method **OR** the you don't pass in the `hideAlert` parameter and player presses "Reset"

```json
{"resetAchievements":true,"message":"User achievements reset"}
```

If you don't pass in the `hideAlert` parameter and player presses "No!"

```json
{"resetAchievements":false,"message":"User achievements not reset"}
```




## submitAchievementScore <Promise?>


#### Details
Submit progress of users achievements

#### Parameters

| Name  | Required | Default    | Description |
|--------------|--------------|--------------|--------------|
| percentComplete |  Yes | n/a | number, float, or string of the percent achievement is complete. **Range 1-100**    |
| achievementIdentifier |  No* (see Response) | `achievementIdentifier` set up in Itunes Connect  |
| hideCompletionBanner |  No | `false` | Hides Game center banner when complete   |


#### Usage



```jsx
let options={
            percentComplete:50,
            achievementIdentifier:"novice_award"
          };

GameCenter.submitAchievementScore(options).then(res=>{
  if(res){
//success
  }
})
.catch(alert("Could not update your achievements at this time. Try again later."))
```


#### Response

**Success**

```json
[null]
```

Not required if `achievementIdentifier` set as default in `init()`. `achievementIdentifier` always reverts to default unless defended. However, will reject promise if not passed in `init()` or `submitAchievementScore()` function

**Failed**

```json
No Game Center `achievementIdentifier` passed and no default set
```



# TODO


ADD METHODS

[ ] getLeaderboardPlayers()
[ ] invite()
[ ] challengeComposer()
[ ] findScoresOfFriendsToChallenge()
