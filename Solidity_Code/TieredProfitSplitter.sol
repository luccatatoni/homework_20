pragma solidity ^0.5.0;

// Import SafeMath library and use it for all math operations in order to secure your token 
// from integer underflow and overflow vulnerabilities, as well as other math-related vulnerabilities.
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// lvl 2: tiered split
contract TieredProfitSplitter {
    using SafeMath for uint;
    
    address payable employee_one; // ceo
    address payable employee_two; // cto
    address payable employee_three; // bob
    address payable hr;

    constructor(address payable _one, address payable _two, address payable _three, address payable _hr) public {
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
        hr = _hr;
    }

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint, uint, uint, uint) {
        return (address(this).balance, employee_one.balance,employee_two.balance, employee_three.balance);
    }

    function deposit() public payable {
        require(msg.sender == hr, "Only your HR can send your salary!");
        uint points = msg.value / 100; // Calculates rudimentary percentage by dividing msg.value into 100 units
        uint total;
        uint amount;

        // Calculate and transfer the distribution percentage for the CEO = 60% of revenues
        // Step 1: Set amount to equal `points` * the number of percentage points for this employee
        amount = points.mul(60);
        // Step 2: Add the `amount` to `total` to keep a running total
        total = total.add(amount);
        // Step 3: Transfer the `amount` to the employee
        employee_one.transfer(amount);
        
        // Calculate and transfer the distribution percentage for the CTO = 25% of revenues
        amount = points.mul(25);
        total = total.add(amount);
        employee_two.transfer(amount);

        // Calculate and transfer the distribution percentage for Bob = 15% of revenues
        amount = points.mul(15);
        total = total.add(amount);
        employee_three.transfer(amount);

        employee_one.transfer(msg.value.sub(total)); // ceo gets the remaining wei
    }


    // Add a fallback function to avoide ETH to be locked into teh contract since we don't create a withdraw function
    function() external payable {
        deposit();
    }
}
