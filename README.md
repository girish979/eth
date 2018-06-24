#Betting

* Install truffle, ganacle-cli

* Run ganache-cli. It opens the port and lists available accounts.
They have 100 ether by default

```
ganache-cli -p 7545
```
* Compile and deploy the contract to blockchain

```
truffle compile
truffle migrate --network development
```

* Launch the console and get the first 2 accounts 

```
truffle console --network development	
account0 = web3.eth.accounts[0]
account1 = web3.eth.accounts[1]
```

* Get the instance of the contract deployed to variable BettingInstance
```
Betting.deployed().then(inst => { BettingInstance = inst })
```

* Address of 1st better
```
BettingInstance.better1.call()

BettingInstance.registerAsAnOpponent({from: account1})
```
* Address of 2nd better
```
BettingInstance.better2.call()
```

* Play the game
```
BettingInstance.bet({from: account0, value: web3.toWei(2, "ether")})
BettingInstance.bet({from: account1, value: web3.toWei(3, "ether")})
// End of the first round
BettingInstance.bet({from: account0, value: web3.toWei(5, "ether")})
BettingInstance.bet({from: account1, value: web3.toWei(20, "ether")})
// End of the Betting
```
