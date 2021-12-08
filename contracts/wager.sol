// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract A {


struct wager { 

    address creator;
    uint ID;
    bool result;

    uint yesBalance;
    uint noBalance;

    address[] yes;
    address[] no;
    uint balance;

}


struct YES {

    address creator;
    uint ID;
    uint balance;

}


struct NO {

    address creator;
    uint ID;
    uint balance;

}


mapping(address => mapping(uint => wager)) public wagers;
mapping(address => YES) public yes;
mapping(address => NO) public no;

uint private ID;
mapping(address => uint[]) public listmappingUser;


function createWager() public {

    ID = listmappingUser[msg.sender].length;

    wagers[msg.sender][ID].creator = msg.sender;
    wagers[msg.sender][ID].ID = ID;

    listmappingUser[msg.sender].push(ID);


}


function deposit(address user, uint id, bool result) payable public {

    if (result == true) {
        
        yes[msg.sender].balance += msg.value;

        wagers[user][id].yesBalance += msg.value;

        
    }

    else {

        no[msg.sender].balance += msg.value;
    
        wagers[user][id].noBalance += msg.value;

    }


    wagers[user][id].balance += msg.value;

}


function withdraw(address user, uint id) public { 
    

    if (wagers[user][id].result == true) {

        require(yes[msg.sender].balance > 0);

        /* split according to percentage of deposit

        // this function is currently failing but this is the idea.. 

        */


        uint payment = (yes[msg.sender].balance * wagers[user][id].yesBalance) / wagers[user][id].balance;

        payable(msg.sender).transfer(payment);

    }

    else {

        require(no[msg.sender].balance > 0);

        //payable(msg.sender).transfer(address(this).balance);
 
        uint payment = (yes[msg.sender].balance * wagers[user][id].yesBalance) / wagers[user][id].balance;

        payable(msg.sender).transfer(payment);

    }

}


// dev tools
    function oracle(bool result) public {

        wagers[msg.sender][0].result = result;

    }

    
    function array() public view virtual returns (uint) {
        return yes[msg.sender].balance;
    }

    function getBankBalance() public view returns(uint){
        return address(this).balance;
    }

}



