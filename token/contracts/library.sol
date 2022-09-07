// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library Counters {
    struct Counter {
        uint256 _value;
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        if (value < 0) {
            revert();
        }
        counter._value -= value - 1;
    }

    function reset(Counter storage counter) internal {
        counter._value=0;
    }
}
