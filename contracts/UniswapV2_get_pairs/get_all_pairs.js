require("dotenv").config();
const { ethers } = require("ethers");

// Constants
const UNISWAP_V2_FACTORY_ADDRESS = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
const UNISWAP_V2_FACTORY_ABI = [
  "function allPairsLength() view returns (uint256)",
  "function allPairs(uint256) view returns (address)",
];

const UNISWAP_V2_PAIR_ABI = [
  "function token0() view returns (address)",
  "function token1() view returns (address)",
  "function getReserves() view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)",
  "function totalSupply() view returns (uint256)",
];

const ERC20_ABI = [
  "function name() view returns (string)",
  "function symbol() view returns (string)",
  "function decimals() view returns (uint8)",
  "function balanceOf(address) view returns (uint256)",
];

// Initialize Provider
const provider = new ethers.JsonRpcProvider("https://rpc.pulsechain.com");

// Initialize Factory Contract
const factoryContract = new ethers.Contract(
  UNISWAP_V2_FACTORY_ADDRESS,
  UNISWAP_V2_FACTORY_ABI,
  provider
);

(async () => {
  // Fetch token details and balance
  async function getTokenDetails(tokenAddress, pairAddress) {
    const tokenContract = new ethers.Contract(
      tokenAddress,
      ERC20_ABI,
      provider
    );
    let name = "Unknown";
    let symbol = "Unknown";
    let decimals = 18; // Default to 18 if not found
    let balance = ethers.BigNumber.from(0); // Initialize as BigNumber
    try {
      name = await tokenContract.name();
    } catch (error) {
      console.warn(`Error fetching token name for ${tokenAddress}:`, error);
    }
    try {
      symbol = await tokenContract.symbol();
    } catch (error) {
      console.warn(`Error fetching token symbol for ${tokenAddress}:`, error);
    }
    try {
      decimals = await tokenContract.decimals();
    } catch (error) {
      console.warn(`Error fetching token decimals for ${tokenAddress}:`, error);
    }
    try {
      balance = await tokenContract.balanceOf(pairAddress);
    } catch (error) {
      console.warn(
        `Error fetching balance for ${tokenAddress} on pair ${pairAddress}:`,
        error
      );
    }
    return { name, symbol, decimals, balance };
  }

  // Fetch reserves for the pair
  async function getReserves(pairAddress) {
    const pairContract = new ethers.Contract(
      pairAddress,
      UNISWAP_V2_PAIR_ABI,
      provider
    );
    try {
      const { reserve0, reserve1 } = await pairContract.getReserves();
      return {
        reserve0: ethers.BigNumber.from(reserve0),
        reserve1: ethers.BigNumber.from(reserve1),
      }; // Ensure BigNumbers
    } catch (error) {
      console.warn(`Error fetching reserves for pair ${pairAddress}:`, error);
      return {
        reserve0: ethers.BigNumber.from(0),
        reserve1: ethers.BigNumber.from(0),
      }; // Default to zero if error
    }
  }

  // Format BigNumber to human-readable formats
  function formatValue(value, decimals) {
    const valueString = ethers.formatUnits(value, decimals); // Formatted string
    const valueFloat = parseFloat(valueString); // Float value
    return { valueBigNumber: value, valueString, valueFloat };
  }

  // Calculate Price Impact
  function calculatePriceImpact(
    originalReserve0,
    originalReserve1,
    swapAmount,
    token0Decimals,
    token1Decimals
  ) {
    // Convert reserves to human-readable values
    const originalReserve0Formatted = ethers.formatUnits(
      originalReserve0,
      token0Decimals
    );
    const originalReserve1Formatted = ethers.formatUnits(
      originalReserve1,
      token1Decimals
    );

    // Simulate the price change due to a swap
    const newReserve0 = originalReserve0.add(swapAmount);
    const newReserve1 = originalReserve1.add(swapAmount);

    const originalPrice =
      parseFloat(originalReserve1Formatted) /
      parseFloat(originalReserve0Formatted);
    const newPrice =
      ethers.formatUnits(newReserve1, token1Decimals) /
      ethers.formatUnits(newReserve0, token0Decimals);

    const priceImpact = (newPrice - originalPrice) / originalPrice;

    return priceImpact;
  }

  // Fetch and log details for the first 50 pairs
  async function fetchTokenDetailsForPairs() {
    try {
      const totalPairs = Math.min(
        50,
        Number(await factoryContract.allPairsLength())
      );
      console.log(`Fetching details for ${totalPairs} pairs...`);

      for (let index = 0; index < totalPairs; index++) {
        try {
          const pairAddress = await factoryContract.allPairs(index);
          const pairContract = new ethers.Contract(
            pairAddress,
            UNISWAP_V2_PAIR_ABI,
            provider
          );

          // Fetch token addresses
          const [token0Address, token1Address] = await Promise.all([
            pairContract.token0(),
            pairContract.token1(),
          ]);

          // Fetch token details and balances
          const token0Details = await getTokenDetails(
            token0Address,
            pairAddress
          );
          const token1Details = await getTokenDetails(
            token1Address,
            pairAddress
          );

          // Fetch reserves
          const { reserve0, reserve1 } = await getReserves(pairAddress);

          // Format reserves and balances
          const formattedReserve0 = formatValue(
            reserve0,
            token0Details.decimals
          );
          const formattedReserve1 = formatValue(
            reserve1,
            token1Details.decimals
          );
          const formattedBalance0 = formatValue(
            token0Details.balance,
            token0Details.decimals
          );
          const formattedBalance1 = formatValue(
            token1Details.balance,
            token1Details.decimals
          );

          // Calculate Price Impact (using an example swap amount)
          const swapAmount = ethers.parseUnits("1", token0Details.decimals); // Example swap amount (1 token0)
          const priceImpact = calculatePriceImpact(
            reserve0,
            reserve1,
            swapAmount,
            token0Details.decimals,
            token1Details.decimals
          );

          // Log the details
          console.log(`Pair ${index + 1} - ${pairAddress}:`);
          console.log(
            `---> Token0 - ${token0Address} - ${token0Details.name} (${token0Details.symbol})`
          );
          console.log(
            `------> Reserve0 (BigNumber): ${formattedReserve0.valueBigNumber}`
          );
          console.log(
            `------> Reserve0 (String): ${formattedReserve0.valueString}`
          );
          console.log(
            `------> Reserve0 (Float): ${formattedReserve0.valueFloat}`
          );
          console.log(
            `------> Balance0 (BigNumber): ${formattedBalance0.valueBigNumber}`
          );
          console.log(
            `------> Balance0 (String): ${formattedBalance0.valueString}`
          );
          console.log(
            `------> Balance0 (Float): ${formattedBalance0.valueFloat}`
          );
          console.log(
            `---> Token1 - ${token1Address} - ${token1Details.name} (${token1Details.symbol})`
          );
          console.log(
            `------> Reserve1 (BigNumber): ${formattedReserve1.valueBigNumber}`
          );
          console.log(
            `------> Reserve1 (String): ${formattedReserve1.valueString}`
          );
          console.log(
            `------> Reserve1 (Float): ${formattedReserve1.valueFloat}`
          );
          console.log(
            `------> Balance1 (BigNumber): ${formattedBalance1.valueBigNumber}`
          );
          console.log(
            `------> Balance1 (String): ${formattedBalance1.valueString}`
          );
          console.log(
            `------> Balance1 (Float): ${formattedBalance1.valueFloat}`
          );
          console.log(`---> Price Impact: ${priceImpact * 100}%`);
        } catch (error) {
          console.error(
            `Error fetching details for pair at index ${index}:`,
            error
          );
        }
      }
      console.log("Completed fetching details for all pairs.");
    } catch (error) {
      console.error("Error initializing details fetch:", error);
    }
  }

  // Run the fetch function
  await fetchTokenDetailsForPairs();
})();
