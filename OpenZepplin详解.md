# OpenZepplin详解

## 模块

- **拉动式支付（Pull payment）辅助模块：**使用拉动式支付（起名源于其工作方式与需要发送操作的推动式支付相反）策略可避免许多的安全问题（包括臭名昭著的“DAO被破解”事件）。我们已经具有了简易的PullPaymentCapable.sol合约，但是仍需要更全面的工具、文档和实例。
- **合约生命周期工具：**当前在没有过多考虑未来将会发生什么的情况下，大部分的合约就被部署到区块链中。我们需要构建能更好地去管理合约终结策略、合约属主转变、合约暂停及恢复、合约升级等的工具。
- **容错和自动挑错奖励：**其中包括对漏洞的自动检测、从不一致状态恢复的工具、限定合约所管理资金规模的简易工具。我们也在致力于漏洞奖励合约，并期望去改进该合约，这样可实现自动去支付可攻破我们合约固定部分的安全研究者。
- **可重用的基础组件：**对于每个新的项目，其中的一些通用模块依然是需要从零开发重新实现。我们希望能为代币发行、众筹、表决、投注、工资单、收益共享等构建标准的合约。
- **探究形式验证理念：**合约的形式验证是一个活跃的研究领域。将这些研究工作成果集成到Zeppelin中，可为合约提供有意思的安全保障。形式验证意味着对合约代码做静态分析，以形式上验证合约的正确性以及存在的问题。
- **与Oracle更好的接口：**如何与离区块链数据源进行交互是智能合约发展中的一个重要部分。其中一个值得去探究的有意思想法就是做反向控制。这种方式中，oracle通过通用接口方法调用合约（用于在Truth外进行通信），并按所需去实现oracle逻辑，其中包括了值得信赖的专家、关闭的投票、开放投票、API包装器等。这样并非是合约从oracle请求数据，而是在数据发生了改变时由oracle去通知合约。
- **更好的重用代码工具：**当前Solidity的代码重用是基于拷贝-复制的，或是通过从其它的代码库中下载已有的代码。一个成熟的生态系统应具有好的代码库管理系统，就像NodeJS的npm和Ruby的gems这样。对已部署到区块链中代码重用的可能性，构成了以太坊的一个有意思的变体。我们正规划去构建实现将合约轻易链接到已部署的程序库上的工具。

这些功能模块的设计都是基于[通用合约安全模式](https://medium.com/zeppelin-blog/onward-with-ethereum-smart-contract-security-97a827e47702#.pf6263wvd)的。Zeppelin是与以太坊开发者所使用的首要构建架构[Truffle](https://github.com/ConsenSys/truffle)相集成的。先期采用者可在[Zeppelin开发者协作群组（Slack channel)](https://zeppelin-slackin.herokuapp.com/)上提问并追踪进度，也可在[BlockParty项目](https://zeppelin-slackin.herokuapp.com/)中学习如何使用Zeppelin。首个公共发布版本计划在11月发布，该发布将伴以基于Zeppelin构建的真正的DAO项目。

## 安装步骤(ubuntu) 
新建一个自己的合约目录，进入合约目录
Truffle init
npm init -y 该步生成一个package.json，内置一些配置信息
npm install -E openzeppelin-solidity
导入：import ‘openzeppelin-solidity/contracts/ownership/Ownable.sol’;
## 方法
* access：地址白名单和基于签名的权限管理

* crowdsale： 用于管理令牌众筹的一系列智能合约，允许投资者购买eth代币

* examples：一组简单的智能合约，演示如何通过多重继承向基础合约添加新功能。

* introspection：对ERC165的简单实现，ERC165用于创建标准方法以发布和检测智能合约实现的接口。

* lifecycle：一个用于管理合约及其资金的生命周期和行为的基础合约集合

* math：对发生错误的操作进行安全检查的库。

* mocks：主要用于单元测试的抽象合约集合。

* ownership：一个用于管理合约以及TOKEN所有权的集合

* payment：可以通过托管安排、取款、索赔管理支付相关的智能合约集合，支持单个收款人和多个收款人

* proposals:对eip-1046的实现，EIP-1046对ERC20做了简单的扩展

* token：一组ERC标准接口 主要是ERC20和ERC721

## 详解 
### Access

### Crowdsale

### Examples

### Introspection 
* ERC165:创建和发布一个标准方法、用于检测智能合约实现的接口

> 源码地址:https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md

* ERC165可以标准化以下内容 

> 如何识别接口
> 智能合约如何发布其实现的接口
> 如何检测智能合约是否实现了ERC165
> 如何检测智能合约是否实现了一个给定的接口

* SupportsInterfaceWithLookup:查找支持的接口

### Lifecycle 
* Destructible:销毁合约

* Pausable：可暂停

* TokenDestructible：销毁token

### Math 
* Math：简单的数学操作

* SafeMath：带有安全检查的数学运算

### Mocks

### Ownership 
* Rbac 

* RBAC:Role-Based Access Control 角色控制

* Roles:角色操作

* CanReclaimToken：可回收TOKEN

* Claimable：ownerable合约扩展，可用于转移合约所有权

* Ownable：所有权操作

* Contactable：设置合约信息

* DelayedClaimable：Claimable合约扩展、限制pendingOwner只能在两个指定的区块编号之间完成所有权转移

* HasNoContracts：合约所有者可收回合约的所有权

* HasNoEther：合约锁定、阻止以太币转入、防止意外丢失

* HasNoTokens：TOKEN回收

* Superuser：超级用户：就算不是owner也可转移合约所有权

* Heritable：可继承合约

### Payment 

* ConditionalEscrow：收款人取出资金的条件

* Escrow：托管、余额的存取

* PullPayment：存款的查询与取款、支持异步交易

* RefundEscrow：可退款托管

* SplitPayment：支持多个收款人按照自己所占权重/比例来提取资金

## Proposals 

* ERC721标准为不可替换的令牌引入了“tokenURI”参数来处理元数据，例如：缩略图、标题、描述、性能等等。这对于加密收藏品和游戏资产尤其重要。

* TokenMetadata：TOKEN元数据(TokenURI设置与获取)