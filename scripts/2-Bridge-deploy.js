const fs = require('fs');
const LufiERC20 = require('./abi/LufiERC20.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(`Deploying contracts with the account: ${deployer.address}`);

    const balance = await deployer.getBalance();
    console.log(`Account balance: ${balance.toString()}`);

    const contractFactory = await ethers.getContractFactory('LufiBridge');
    const contract = await contractFactory.deploy(LufiERC20.address);
    console.log(`Contract address: ${contract.address}`);

    const data = {
        address: contract.address,
        abi: JSON.parse(contract.interface.format('json'))
    };
    fs.writeFileSync('abi/LufiBridge.json', JSON.stringify(data));

    // grant mint role
    // grant burn role
}

main()
    .then(() => process.exit(0))
    .catch((e) => {
        console.log(e);
        process.exit(1);
    });
