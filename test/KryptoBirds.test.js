const { assert } = require("chai");

const kb = artifacts.require("./KryptoBirdz");

require("chai")
  .use(require("chai-as-promised"))
  .should();

contract(kb, (accounts) => {
  let cont;
  before(async () => {
    cont = await kb.deployed();
  });
  describe("deployment", async () => {
    it("deploys successfuly", async () => {
      assert.notEqual(cont.address, "");
      assert.notEqual(cont.address, 0x0);
      assert.notEqual(cont.address, undefined);
      assert.notEqual(cont.address, null);
    });

    it("has valid name", async () => {
      // cont = await kb.deployed();
      const name = await cont.name();
      assert.equal(name, "KryptoBirdz");
    });

    it("it has valid symbol", async () => {
      // cont = await kb.deployed();
      const symbol = await cont.symbol();
      assert.equal(symbol, "KBIRD");
    });

    it("mints the nft", async () => {
      const result = await cont.mint("http://...1");
      const totalSupply = await cont.totalSupply();
      const event = result.logs[0].args;
      console.log("event", event._from);
      assert.equal(totalSupply, 1);
      assert.equal(event._from, "0x0000000000000000000000000000000000000000");
      assert.equal(event._to, accounts[0]);
    });

    it("cannot mint duplicate", async () => {
      const res = await cont.mint("1");
      await cont.mint("1").should.be.rejected;
    });
  });

  describe("Enumeration", async () => {
    it("lists all kryptobirdz", async () => {
      const tokens = ["http://enumeration/1", "http://enumeration/2", "htp://enumeration/3"];
      await cont.mint(tokens[0]);
      await cont.mint(tokens[1]);
      await cont.mint(tokens[2]);
      const totalSupply = await cont.totalSupply();
      let result = [];
      for (let i = 1; i < totalSupply.toNumber(); i++) {
        const tokenAt = await cont.krytoBirds(i);
        console.log("token at " + i + ", token: " + tokenAt);
        result.push(tokenAt);
      }
      // assert.equal(result.join(','), tokens.join(','));
    });
  });
});
