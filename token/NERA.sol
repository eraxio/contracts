// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title Interface for other's contracts use
 * @dev This functions will be called by other's contracts
 */
interface INERA {
    /**
     * @dev Mining for NERA tokens.
     *
     */
    function mint(address to, uint256 amount) external returns (bool);
}


contract NERA is ERC20, Ownable, INERA {

    // community
    uint256 private constant communitySupply    = 120000000 * 1e18;
    
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _minters;

    constructor() ERC20("NERA Token", "NERA")
    {
        _mint(msg.sender, communitySupply);
    }
    
    /**
     * @dev See {INERA-mint}. 
     * Mining for NERA tokens.
     */
    function mint(address to, uint256 amount) 
        public 
        virtual
        override
        onlyMinter 
        returns (bool) 
    {
        _mint(to, amount);
        return true;
    }

    function burn(uint256 amount) 
        public 
        onlyOwner
        returns (bool)  
    {
        _burn(msg.sender, amount);
        return true;
    }

    function addMinter(address miner) 
        public 
        onlyOwner 
        returns (bool)
    {
        require(miner != address(0), "NERA: miner is the zero address");
        return _minters.add(miner);
    }

    function delMinter(address _delMinter)
        public
        onlyOwner 
        returns (bool)
    {
        require(_delMinter != address(0), "NERA: _delMinter is the zero address");
        return _minters.remove(_delMinter);
    }

    function getMinterLength() 
        public 
        view 
        returns (uint256)
    {
        return _minters.length();
    }

    function isMinter(address account)
        public
        view
        returns (bool)
    {
        return _minters.contains(account);
    }

    function getMinter(uint256 idx)
        public
        view
        onlyOwner
        returns (address)
    {
        require(idx < getMinterLength(), "NERA: index out of bounds");
        return _minters.at(idx);
    }

    modifier onlyMinter() 
    {
        require(isMinter(msg.sender), "NERA: caller is not the minter");
        _;
    }
}
