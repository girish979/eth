pragma solidity ^0.4.22;

contract Wrestling {

    //Two players
    address public wrestler1;
    address public wrestler2;

    bool public wrestler1Played;
    bool public wrestler2Played;

    uint private wrestler1Deposit;
    uint private wrestler2Deposit;

    bool public gameFinished; 
    address public theWinner;
    uint gains;

    //3 Events for match
    event WrestlingStartsEvent(address wrestler1, address wrestler2);
    event EndOfRoundEvent(uint wrestler1Deposit, uint wrestler2Deposit);
    event EndOfWrestlingEvent(address winner, uint gains);

    //Player 1 is the person who invoked the contract
    constructor()  public {
        wrestler1 = msg.sender;
    }

    //Let player 2 register
    function registerAsAnOpponent() public {
        
        //Make sure nobody else is registered as player 2
        require(wrestler2 == address(0));

        wrestler2 = msg.sender;

        //Start the match
        emit WrestlingStartsEvent(wrestler1, wrestler2);
    }


    //Each player starts playing
    //payable -> function can receive money
    //If both played, check if there is a winner
    function wrestle() public payable {
        require(!gameFinished && (msg.sender == wrestler1 || msg.sender == wrestler2));

        if(msg.sender == wrestler1) {
            require(wrestler1Played == false);
            wrestler1Played = true;
            wrestler1Deposit = wrestler1Deposit + msg.value;
    	} else { 
            require(wrestler2Played == false);
            wrestler2Played = true;
            wrestler2Deposit = wrestler2Deposit + msg.value;
    	}
        if(wrestler1Played && wrestler2Played) {
            if(wrestler1Deposit >= wrestler2Deposit * 2) {
                endOfGame(wrestler1);
            } else if (wrestler2Deposit >= wrestler1Deposit * 2) {
                endOfGame(wrestler2);
            } else {
                endOfRound();
            }
    	}
    }

    function endOfRound() internal {
        wrestler1Played = false;
        wrestler2Played = false;

        emit EndOfRoundEvent(wrestler1Deposit, wrestler2Deposit);
    }

    function endOfGame(address winner) internal {
        gameFinished = true;
        theWinner = winner;

        gains = wrestler1Deposit + wrestler2Deposit;
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