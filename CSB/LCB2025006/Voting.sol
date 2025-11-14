//SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract voting{
    struct candidiate{
        string cname;
        uint votes;
    }
    mapping(uint => candidiate) public candidiatemp;
    uint public cid = 0;
    mapping(address => bool) public alreadyvoted;
    bool public votingopen = true;
    address public owner;
    constructor(){
        owner = msg.sender;

    }
    modifier onlyOwner{
        require(msg.sender==owner,"Not contract owner");
        _;
    }
    function add_candidiate(string memory _candidiate_name) onlyOwner public{
        cid++;
        candidiatemp[cid]=candidiate(_candidiate_name,0);
        
    }
    function cast_vote(uint _cid) public{
        require(alreadyvoted[msg.sender] ==false,"you have already voted");
        require(_cid>0&&_cid<=cid,"Invalid cid");
        require(votingopen==true,"voting closed");
        candidiatemp[_cid].votes++;
        alreadyvoted[msg.sender] = true;
    }
    function view_votes(uint _cid) public view returns(string memory,uint ){
        require(_cid>0&&_cid<=cid,"Invalid cid");
        return (candidiatemp[_cid].cname,candidiatemp[_cid].votes);
    }
    function close_voting() public onlyOwner{
        require(votingopen==true, "voting already closed!");
        votingopen = false;
    }
    //I am considering those who registered first are declared winner incase of equal votes
    
    function see_result() public view returns(uint,string memory,uint){
        require(votingopen==false, "voting is still open!");
        require(cid > 0, "No candidates registered yet");
        uint wincid=1;
        for (uint i=2;i<=cid;i++){
            if (candidiatemp[i].votes>candidiatemp[wincid].votes){
                wincid=i;
            }
        }
        return(wincid,candidiatemp[wincid].cname,candidiatemp[wincid].votes);
        
        
    }
}

