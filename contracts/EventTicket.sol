// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract EventTicket is ERC1155, Ownable{
    //Ticket data structure
    struct Ticket{
        uint256 price;
        uint256 maxPerBatch;
        uint256 totalMinted;
    }
    //mapping of ticket id to ticket details
    mapping(unit256 => Ticket) public tickets;

    //USDC contract  address
    address public usdcAddress;
    constructor(address _usdcaddress) ERC1155 ("https://example.com/tickets/{id}.json") {
        usdcAddress = _usdcaddress;
    }

    //the owner can set the ticket details
    function setTicketDetails (uint256 id, uint256 price , uint256 maxPerBatch ) external onlyOwner{
        tickets[0].price = price;
        tickets[id].maxPerBatch = maxPerBatch;
    }

    //buy the ticket using usdc
    function buy (uint256 id, uint256 amount) external {
        require(tickets[id].totalMinted + amount <= tickets[id].maxperBatch,"Exceed maximum per batch");
        uint256 totalCost = amount * tickets[id].price;
        IERC20(usdcAddress).transferFrom(msg.sender, address(this), totalCost);
        _mint(msg.sender,id,amount,"");
    }

    //update maximum tickets per batch
    function updateMaxPerBatch (uint256 id , uint256 maxPerBatch) external onlyOwner{
        require(maxPerBatch >= tickets[id].totalMinted, "New max limit must be greater than or equal to tickets minted");
        tickets[id].maxPerBatch = maxPerBatch;
        emit MaxPerBatchUpdated(id, maxPerBatch);
    }
}