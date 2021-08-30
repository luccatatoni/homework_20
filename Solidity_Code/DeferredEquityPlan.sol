pragma solidity ^0.5.0;

// Import SafeMath library and use it for all math operations in order to secure your token 
// from integer underflow and overflow vulnerabilities, as well as other math-related vulnerabilities.
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// lvl 3: equity plan
contract DeferredEquityPlan {
    using SafeMath for uint;
    
    address human_resources;
    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // Set the total shares and annual distribution
    uint total_shares = 1000;
    uint annual_distribution = 250;
    
    // permanently store the time when this contract was initialized - the idea is to keep track of the 4years
    uint start_time = now;

    // Set the `unlock_time` to be 365 days from now
    uint public unlock_time = now.add(365);
    
    // Track how many vested shares the employee has claimed and was distributed
    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        
        // Add "require" statements to enforce that:
        // 1: `unlock_time` is less than or equal to `now`
        require(unlock_time <= now, "Shares are not yet vested");
        // 2: `distributed_shares` is less than the `total_shares`
        require(distributed_shares <= total_shares, "All Shares have been distributed");

        // Add 365 days to the `unlock_time`
        unlock_time = unlock_time.add(365);

        // Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution
        distributed_shares = ((now.sub(start_time)).div(365).mul(annual_distribution));

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }
    
    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
