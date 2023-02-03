import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers } from "hardhat";

import {
  JoRocca
} from "../typechain-types";

describe("Resume tests", () => {
  let deployer: SignerWithAddress;
  let alice: SignerWithAddress;

  let contract: JoRocca;

  beforeEach(async () => {
    await deployments.fixture("testbed");
    [deployer, alice] = await ethers.getSigners();
  });

  it("Should only allow stable wallet to confirm burn counts", async () => {
    
  });
});
