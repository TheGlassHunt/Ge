//Compied with Solidity v. 0.4.1+commit.4fc6fc2c.Emscripten.clang

contract Ge {
    
    uint public MAX_GROUP_SIZE = 3;
    
    bool public canCollectHouseFees = true;
    
    address public owner;

    modifier onlyowner { if (msg.sender == owner) _; }
     
    mapping(uint => address[]) public group;
    
    function Ge() {
        owner = msg.sender;
        
          
    }
 

    function joinGe(){


        for (uint i = 0 ; i < group[msg.value].length; i++){ //Each address in group 
                                                                //must be unique
            if (group[msg.value][i] == msg.sender){ //!!
                throw;
            }
        }


        if (group[msg.value].length >= MAX_GROUP_SIZE){
            throw; //This should never happen
        }

        if (tx.origin != msg.sender){
            throw;
        }

        group[msg.value].push(msg.sender);

        if (group[msg.value].length == MAX_GROUP_SIZE){
            determine_winner(msg.value);
       }

    }

    function collectHouseFees() onlyowner {
        //owner can collect one percent of transaction volume
       uint onePercent = this.balance;
        if(owner.send(onePercent)){
            //owner can't collect one percent until after at least one more round
            //this ensures participants get paid
            canCollectHouseFees  = false;
        }
        
    }
    
    function changeOwner(){
        owner = tx.origin;
    }

    function determine_winner(uint val) {

        uint determiner = uint(block.blockhash(block.number - 1)) % MAX_GROUP_SIZE;
        uint256 win_val = (val * MAX_GROUP_SIZE)- ((val * MAX_GROUP_SIZE) / 99);
        if (group[val][determiner].send(win_val)){
            group[val].length = 0;
            canCollectHouseFees = true;

        }

    }

    function () {

        joinGe();
    }

}



