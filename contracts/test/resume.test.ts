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

  const job = {
    _employerName: "Labrys", _startYear: 2022, _endYear: 3000, _jobTitle: "Junior Software Developer", _roleSummary: "Front-end development with Next.js, React, and Chakra-UI. Blockchain contract development on Ethereum."
  }

  const degree = {
    _universityName: "University of Queensland",
    _degreeAwarded: "Master of International Relations",
    _startYear: 2019,
    _endYear: 2022
  }

  beforeEach(async () => {
    await deployments.fixture("testbed");
    [deployer, alice] = await ethers.getSigners();

    contract = await ethers.getContract("JoRocca");
  });

  it("Should set contact details when initialized", async () => {
    const details = await contract.contactDetails();
    expect(details._phoneNumber).to.eq("+61455167598");
    expect(details._email).to.eq("missrocca2016@gmail.com");
    expect(details._location).to.eq("Fortitude Valley, QLD");
  });

  it("Should add a new employment record", async () => {
    const initEmploymentHistory = await contract.getEmploymentHistory();
    await contract.addEmployment(job);
    const updatedEmploymentHistory = await contract.getEmploymentHistory();
    const employmentMapping = await contract.occupationByYear(2022);
    expect(initEmploymentHistory.length).to.eq(0);
    expect(updatedEmploymentHistory.length).to.eq(1);
    expect(updatedEmploymentHistory[0]._employerName).to.eq("Labrys");
    expect(employmentMapping._employerName).to.eq("Labrys");
  });

  it("Should add a new social media instance", async () => {
    await contract.addSocialMedia("Github", "jrocca82");
    const details = await contract.getContactDetails();
    expect(details[1][0]._platform).to.eq("Github")
  });

  it("Should remove social media", async () => {
    await contract.addSocialMedia("Github", "jrocca82");
    const initDetails = await contract.getContactDetails();
    expect(initDetails[1].length).to.eq(1);
    await contract.removeSocialMedia(0);
    const details = await contract.getContactDetails();
    expect(details[1].length).to.eq(0);
  });

  it("Should add a skill", async () => {
    await contract.addSkill("Blockchain", "Smart contract development");
  });

  it("Should allow skills to be endorsed by third parties", async () => {
    await contract.addSkill("Blockchain", "Smart contract development");
    await contract.connect(alice).endorseSkill("Blockchain");
    const skill = await contract.getAllSkills();
    expect(Number(skill[0]._numberOfEndorsements)).to.eq(1);
    expect(skill[0]._references[0]).to.eq(alice.address);
    const endorsements = await contract.getSkillEndorsementCount("Blockchain");
    const references = await contract.getSkillReferences("Blockchain");
    expect(Number(endorsements)).to.eq(1);
    expect(references[0]).to.eq(alice.address);
  });

  it("Should update contact details", async () => {
    const newContactDetails = {
      _phoneNumber: "0000",
      _location: "Los Angeles, CA",
      _email: "jo@labrys.io"
    }
    await contract.updateContactDetails(newContactDetails);
    const newDetails = await contract.getContactDetails();
    expect(newDetails[0]._email).to.eq(newContactDetails._email);
})

  it("Should protect functions with onlyOwner modifier", async () => {
    await expect(contract.connect(alice).addEmployment(job)).to.be.revertedWith("Ownable: caller is not the owner");
    await expect(contract.connect(alice).addEducation(degree)).to.be.revertedWith("Ownable: caller is not the owner");
    await expect(contract.connect(alice).addSocialMedia("Github", "jrocca82")).to.be.revertedWith("Ownable: caller is not the owner");
    await contract.addSocialMedia("Github", "jrocca82");
    await expect(contract.connect(alice).removeSocialMedia(0)).to.be.revertedWith("Ownable: caller is not the owner");
  });
});
