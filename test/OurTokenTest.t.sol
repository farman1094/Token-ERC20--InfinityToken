// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {

    OurToken public ourToken;
    DeployOurToken public deployer;
    address aamir = makeAddr("aamir"); 
    address fasil = makeAddr("fasil"); 
    address tokenOwner = msg.sender;
    uint256 initialSupply;
    // balanceOf(DefaultSender: [0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38]) [staticcall]
    // address(msg.sender)


    uint256 public constant STARTING_BAL = 100 ether;
    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(tokenOwner);
        ourToken.transfer(aamir, STARTING_BAL);
        initialSupply = deployer.INITIAL_SUPPLY(); //1,000,000,000,000,000,000,000
    }
    

    function testInitialSupply() public  view{
        assertEq(ourToken.totalSupply(), initialSupply);
    }
    function testAamirBalancePublic() public view {
        assertEq(STARTING_BAL, ourToken.balanceOf(aamir));
    }

      function testTransfer() public {
        uint256 amount = 1000;
        address user1 = makeAddr("user1");
        vm.prank(tokenOwner);
        ourToken.transfer(user1, amount);

        assertEq(ourToken.balanceOf(user1), amount);
        assertEq(ourToken.balanceOf(tokenOwner), initialSupply - (amount + STARTING_BAL));
    }
    
    function testAllowanceWork() public {
        uint256 initialAllowance = 1000;

        // Aamir approve fasil to use token on his behalf
        vm.prank(address(aamir));
        ourToken.approve(fasil, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(address(fasil));
        ourToken.transferFrom(aamir, fasil, transferAmount);
        /** Another way to do this
        //automatically sets from
        ourToken.transfer( fasil, transferAmount);
         */
         assertEq(ourToken.balanceOf(fasil), transferAmount);
         assertEq(ourToken.balanceOf(aamir), STARTING_BAL - transferAmount);
    }
}