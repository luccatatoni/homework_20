pragma solidity ^0.5.0;

// Import SafeMath library and use it for all math operations in order to secure your token 
// from integer underflow and overflow vulnerabilities, as well as other math-related vulnerabilities.
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// lvl 1: equal split
contract AssociateProfitSplitter {
    using SafeMath for uint;
    
    // Create three payable addresses representing `employee_one`, `employee_two` and `employee_three`.
    address payable public employee_one;
    address payable public employee_two;
    address payable public employee_three;
    address payable public hr;
    
    // Build teh constructor to input the three employees addresses while deploying the contract. 
    constructor(address payable _one, address payable _two, address payable _three, address payable _hr) public {
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
        hr = _hr;
    }

    // Add a function to return the contract balance
    function balance() public view returns(uint) {
        return address(this).balance; 
    }
    
    // Function to pay the employees - can only be used by the owner
    function deposit() public payable {
        require(msg.sender == hr, "Only your HR can send your salary!");
        // Split `msg.value` into three
        uint amount = msg.value.div(3);
        
        // Transfer the amount to each employee
        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);
        

        // take care of a potential remainder by sending back to HR (`msg.sender`)
        uint remainder = msg.value.sub(amount.mul(3));
        msg.sender.transfer(remainder);
    }
    
    // Add a fallback function to avoide ETH to be locked into teh contract since we don't create a withdraw function
    function fallback() external payable {
        // Enforce that the `deposit` function is called in the fallback function!
        deposit();
    }
}
