// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Test {
    int[] public arr;

    struct User {
        string name;
        uint age;
    }

    User[] public users;

    function add(int a, int b) public pure returns (int) {
        return a + b;
    }
    function sayHello() public pure returns (string memory) {
        return "Hello";
    }
    function setArr(int value) public {
        arr.push(value);
    }
    function getArr() public view returns (int[] memory) {
        return arr;
    }

    function addUser(string memory _name, uint _age) public {
        users.push(User(_name, _age));
    }

    function editUser(uint index, string memory _name, uint _age) public {
        require(index < users.length, "User index out of bounds");
        users[index].name = _name;
        users[index].age = _age;
    }

    function deleteUser(uint index) public {
        require(index < users.length, "User index out of bounds");
        users[index] = users[users.length - 1];
        users.pop();
    }
}
