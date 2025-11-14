//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
        struct Candidate{
            uint Candidate_no;
            address can_add;
            string name;
            uint no_of_vote;
        }
        struct Voter{
            address voter_add;
        }

        Candidate[] public vote;

        Voter[] public ppl;


        address public owner;
        constructor(){
            owner=msg.sender;
        }
        bool public Voting_open=false;

        uint private ct=0;
        uint private Total_Votes=0;

    modifier onlyowner{
        require(msg.sender==owner,"Owner Not Found");
        _;
    }

    // uint public x;
    function put_candidate(address  _can_add,string memory _name) public onlyowner{
        bool repeat=false;
        for(uint i=0;i<ct;++i){
           if(vote[i].can_add==_can_add){
                repeat=true;
                break;
           }
        }
        require(repeat==false,"Candidate already present ");
        ++ct;
        vote.push(Candidate(ct,_can_add,_name,0));
    }

    function open_voting() public onlyowner{
        require(Voting_open==false, "Betting already closed!");
        Voting_open = true;
    }

    function close_voting() public onlyowner{
        require(Voting_open==true, "Betting already closed!");
        Voting_open = false;
    }



    function put_vote(uint _Candidate_no) public {
        require(_Candidate_no<=ct && _Candidate_no>0,"Invalid Candidate Number");
        require(Voting_open == true, "Voting not open");
        bool two_vote=false;
        for(uint i=0;i<Total_Votes;++i){
            if(ppl[i].voter_add==msg.sender){
                two_vote=true;
            }
            
        }
        require(two_vote==false,"You have already voted");
        ++Total_Votes;
        ppl.push(Voter(msg.sender));
        vote[_Candidate_no-1].no_of_vote++;
    }

    function check_vote(uint Enter_Candidate_no) public view returns ( uint ){
        return vote[Enter_Candidate_no-1].no_of_vote;
    }

    function Winner() public view returns (string memory _winner) {
        require(Voting_open == false,"Voting is not ended");
        uint max=0;
        
        uint _candidate_no=0;
        for(uint i=0;i<ct;++i){
            if(vote[i].no_of_vote>max){
                max=vote[i].no_of_vote;
                _candidate_no=i;
            }

        }
        for(uint i=0;i<ct;++i){
            if(vote[i].no_of_vote==max && i!=_candidate_no){
                return "Tie";
                
            }
            

        }
        _winner=vote[_candidate_no+1].name ;
         return _winner;
        
    }
    
}