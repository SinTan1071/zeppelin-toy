# ZOS guide

## 环境准备

```shell
npm install truffle --global
npm install zos --global
一个以太坊的账户地址，在本文中使用0x666abcde888表示
```

## 创建项目

```shell
mkdir xxx
cd xxx
npm init -y
zos init xxx
npm install zos-lib --save-dev
```

## 修改配置

```javascript
vim truffle-config.js

// truffle-config.js
module.exports = {
  networks: {
    local: {
      host: 'localhost',
      port: 8545,
// 如果你的以太坊扩展链选择了使用无gas模式，那么请删除gas
      network_id: '*',
    }
  },
// 因为我们需要测试不同solidity版本之间的合约升级，所以需要告诉truffle我们需要编译的版本  
  compilers: {
    solc: {
      version: "0.4.25",
      settings: {
        optimizer: {
          enabled: false,
          runs: 200
        }
      }
    }
  },
}

```

## 在contracts文件夹下面编写合约

```javascript
vim contracts/Note.sol

// Note.sol
pragma solidity ^0.4.25;

import "zos-lib/contracts/Initializable.sol";

contract Note is Initializable {
  uint256 private number;

  function initialize(uint256 _number) public initializer {
    number = _number;
  }

  function getNumber() public view returns (uint256 _number) {
    return number;
  }
}
```

## 解锁以太坊账户以用于部署合约

```shell
geth attach http://127.0.0.1:8545

> personal.unlockAccount('0x666abcde888', 'password', 999999999)
```

## 编译合约并使用zos部署

```shell
zos session --network local --from 0x666abcde888 --expires 7200
zos add Note
zos push
```

## 调用合约并存储一个值

```shell
zos create Note --init initialize --args 64

// 打印信息如下
Deploying new ProxyAdmin...
Deployed ProxyAdmin at 0x70f94D58cC3fdcBeAC7140f35A087dA9fcD09b94
Creating proxy to logic contract 0xB6b29Ef90120BEC597939e0Eda6b8a9164F75deb and initializing by calling initialize with:
 - _number (uint256): "64"
Instance created at 0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4
0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4 // 这里的这个地址就是代理合约的地址，之后升级合约后这个代理地址不变，仍然可以访问之前存储的值和状态
```

## 使用truffle验证

```shell
truffle console --network local
let abi = require("./build/contracts/Note.json").abi
let contract = new web3.eth.Contract(abi, "your-proxy-address") // 刚才的代理合约地址0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4
contract.methods.getNumber().call(); // 得到值64
```

## 升级合约

```javascript
// Note.sol
pragma solidity ^0.4.25;

import "zos-lib/contracts/Initializable.sol";

contract Note is Initializable {
  uint256 private number;

  function initialize(uint256 _number) public initializer {
    number = _number;
  }

  function getNumber() public view returns (uint256 _number) {
    return number;
  }

  function setNumber(uint256 _number) public {
    number = _number;
  }
}
```

## 使用zos部署升级

```shell
zos push
zos update Note

// 打印信息如下
Using session with network local, sender address 0x7eFf122b94897EA5b0E2A9abf47B86337FAfebdC, timeout 600 seconds
Upgrading proxy to logic contract 0xAb119259Ff325f845F8CE59De8ccF63E597A74Cd
Upgrading proxy at 0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4 without running migrations...
TX receipt received: 0x73b8789aaa85f96c161d58151ccf3b233e9d75b3de5ec5e2a8d8b219c0263de1
Instance at 0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4 upgraded
0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4 // 代理地址不变
Updated zos.mainnet.json
```

## 使用truffle验证

```shell
truffle console --network local
let abi = require("./build/contracts/Note.json").abi;
let contract = new web3.eth.Contract(abi, "your-proxy-address");// 刚才的代理合约地址0x2cE224CaD729c63C5cDF9CE8F2E8B5B8f81eC7B4
contract.methods.getNumber().call(); // 这里的值是64
contract.methods.setNumber(65).send({ from: YOUR_OTHER_ACCOUNT });// 这里需要另外一个以太坊地址
contract.methods.getNumber().call(); // 使用新更新的合约中的新方法设置值为65
```

至此，合约升级成功了