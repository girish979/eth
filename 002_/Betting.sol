pragma solidity ^0.4.22;

contract Betting {

    //Two players
    address public better1;
    address public better2;

    bool public better1Played;
    bool public better2Played;

    uint private better1Deposit;
    uint private better2Deposit;

    bool public gameFinished; 
    address public theWinner;
    uint gains;

    //3 Events for match
    event WrestlingStartsEvent(address better1, address better2);
    event EndOfRoundEvent(uint better1Deposit, uint better2Deposit);
    event EndOfWrestlingEvent(address winner, uint gains);

    //Player 1 is the person who invoked the contract
    constructor()  public {
        better1 = msg.sender;
    }

    //Let player 2 register
    function registerAsAnOpponent() public {
        
        //Make sure nobody else is registered as player 2
        require(better2 == address(0));

        better2 = msg.sender;

        //Start the match
        emit WrestlingStartsEvent(better1, better2);
    }


    //Each player starts playing
    //payable -> function can receive money
    //If both played, check if there is a winner
    function bet() public payable {
        require(!gameFinished && (msg.sender == better1 || msg.sender == better2));

        if(msg.sender == better1) {
            require(better1Played == false);
            better1Played = true;
            better1Deposit = better1Deposit + msg.value;
    	} else { 
            require(better2Played == false);
            better2Played = true;
            better2Deposit = better2Deposit + msg.value;
    	}
        if(better1Played && better2Played) {
            if(better1Deposit >= better2Deposit * 2) {
                endOfGame(better1);
            } else if (better2Deposit >= better1Deposit * 2) {
                endOfGame(better2);
            } else {
                endOfRound();
            }
    	}
    }

    function endOfRound() internal {
        better1Played = false;
        better2Played = false;

        emit EndOfRoundEvent(better1Deposit, better2Deposit);
    }

    function endOfGame(address winner) internal {
        gameFinished = true;
        theWinner = winner;

        gains = better1Deposit + better2Deposit;
        emit EndOfWrestlingEvent(winner, gains);
    }

    //Withdraw money using withdrawal pattern
    //Direct send call is not recommended
    function withdraw() public {
        require(gameFinished && theWinner == msg.sender);

        uint amount = gains;
        // Remember to zero the pending gains before sending, to prevent re-entrancy attacks
        gains = 0;
        msg.sender.transfer(amount);
    }
}