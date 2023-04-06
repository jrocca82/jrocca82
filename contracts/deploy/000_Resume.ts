import { ethers, upgrades } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { JoRocca__factory } from "../typechain-types";

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments } = hre;

  const contactInfo = {
    _phoneNumber: "+61455167598",
    _email: "missrocca2016@gmail.com",
    _location: "Fortitude Valley, QLD",
  };

  const tokenFactory = await ethers.getContractFactory("JoRocca");

  const token = await upgrades.deployProxy(tokenFactory, [
    contactInfo,
    "Jo Rocca's Resume",
    "JOROCCA",
    "Professional blockchain developer",
    "https://bafkreidzd6kmexbh2lvrl5iszb3nlogvr7bvzc4sgd6arfjgswbflbtsvy.ipfs.nftstorage.link/",
  ]);

  // Save the deployment to hardhat so that the contract can be fetched via ethers.getContract, upgradeable contracts don't do this by default
  await deployments.save("JoRocca", {
    ...token,
    abi: JoRocca__factory.abi as any,
  });
};

export default func;
func.tags = ["testbed", "_JoRocca"];
