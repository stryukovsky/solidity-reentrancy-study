import {Victim, Attacker} from "../typechain-types";
import {ethers} from "hardhat";
import {expect} from "chai";


describe("Reentrancy attack", () => {

    let victim: Victim;
    let attacker: Attacker;
    const initialSupply = ethers.utils.parseEther("10")

    before(async () => {
        victim = await (await ethers.getContractFactory("Victim")).deploy();
        attacker = await (await ethers.getContractFactory("Attacker")).deploy(victim.address);
    });

    it("should perform an initial supply", async () => {
        await victim.provideInitialSupply({
            value: initialSupply
        });
    });

    it("attacker should prepare a deposit for attack", async () => {
        await attacker.prepareDeposit({
            value: ethers.utils.parseEther("1")
        });
    });

    it("attacker should perform an attack", async () => {
        const attackerBalanceBefore = await ethers.provider.getBalance(attacker.address);
        expect(attackerBalanceBefore).eq(0);
        await attacker.attack();
        const attackerBalanceAfter = await ethers.provider.getBalance(attacker.address);
        expect(attackerBalanceAfter).eq(initialSupply);
    });
});
