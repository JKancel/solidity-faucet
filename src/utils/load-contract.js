
const NETWORK_ID = 5777;

export const loadContract = async (name, web3) => {
  const res = await fetch(`/contracts/${name}.json`);
  const Artifact = await res.json();
  let contract = null

  try {
    contract = new web3.eth.Contract(
      Artifact.abi,
      Artifact.networks[NETWORK_ID].address
    )
  } catch {
    console.error(`Contract ${name} cannot be loaded`)
  }
  console.log("the contract", contract)
  return contract;
};