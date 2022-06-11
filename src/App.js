import { useCallback, useEffect, useState } from 'react';
import './App.css';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import { loadContract } from './utils/load-contract';

const App = () => {
  const [web3Api, setWeb3Api] = useState({ provider: null, isProviderLoaded: false, web3: null, contract: null });
  const [account, setAccount] = useState(null);
  const [balance, setBalance] = useState(0);
  const [shouldReload, reload] = useState(false);

  const reloadEffect = useCallback(() => reload(!shouldReload), [shouldReload]);
  const canConnectToContract = account && web3Api.contract;
  const setAccountListener = (provider) => {
    provider.on("accountsChanged", _ => window.location.reload());
    provider.on("chainChanged", _ => window.location.reload());
  };

  useEffect(() => {
    const loadProvider = async () => {
      // with metmask we have an access to window.ethereum & to window.web3
      // metamask injects a global API into website
      // this API allows websites to request users, accounts, read data to blockchain
      // sign messages and transactions
  
      // old way to detect provider
      // if (window.ethereum) {
      //   provider = window.ethereum;
      //   try {
      //     await provider.request({method: "eth_requestAccounts"});
      //   } catch(e) {
      //     console.error("User denied accounts access !", e);
      //   }
      // } else if(window.web3) {
      //   provider = window.web3.currentProvider;
      // } else if(!process.env.production) {
      //   provider = new Web3.providers.HttpProvider("http://localhost:7545");
      // }
  
      const provider = await detectEthereumProvider();
      if (provider) {
        // try {
        //   // await provider.request({ method: "eth_requestAccounts" });
        // } catch (e) {
        //   console.error("User denied accounts access !", e);
        // }
        setAccountListener(provider);
        const web3 = new Web3(provider);
        const contract = await loadContract('Faucet', web3);
        console.log("Faucet contract", contract);

        setWeb3Api({
          web3,
          isProviderLoaded: true,
          provider,
          contract
        });
        console.log('Ethereum successfully detected!');
      } else {
        setWeb3Api(api => ({
            ...api,
            isProviderLoaded: true
        }));
        // if the provider is not detected, detectEthereumProvider resolves to null
        console.error('Please install MetaMask!');
      }
    };
    loadProvider();
  }, []);

  useEffect(() => {
    const loadBalance = async () => {
      const { contract, web3 } = web3Api;
      const balance = await web3.eth.getBalance(contract.options.address);
      setBalance(web3Api.web3.utils.fromWei(`${balance}`, "ether"));
    }
    web3Api.contract && loadBalance()
  }, [web3Api, shouldReload]);

  useEffect(() => {
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts();
      setAccount(accounts[0]);
    };
    web3Api.web3 && getAccount();
  }, [web3Api.web3]);

  const addFunds = useCallback(async () => {
    const { contract, web3 } = web3Api;
    await contract.methods.addFunds().send({
      from: account,
      value: web3.utils.toWei('1', 'ether')
    });
    reloadEffect();
  }, [account, web3Api, reloadEffect]);

  const withdraw = useCallback(async (amount) => {
    const { contract, web3 } = web3Api;
    await contract.methods.withdraw(web3.utils.toWei(`${amount}`, "ether")).send({
      from: account
    });
    reloadEffect();
  }, [account, web3Api, reloadEffect]);

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          { web3Api.isProviderLoaded ? 
            <div className="is-flex align-items is-align-items-center">
              <span><strong className="mr-2">Account: </strong></span>
              {account ? <div>{account}</div> :
              !web3Api.provider ? 
              <>
                <div className="notification is-warning is-size-6 is-rounded">
                  Wallet is not detected!{` `};
                  <a target="_blank" rel="noreferrer" href="https://docs.metamask.io">Install Metasmask</a>
                </div>
              </> :
              <button onClick={() => web3Api.provider.request({ method: "eth_requestAccounts" })} className='button is-small'>Connect Wallet</button>}
            </div> :
            <span>Looking for Web3...</span>
          }
          <div className="balance-view is-size-2 my-4">
            Current Balance: <strong>{balance}</strong>&nbsp;ETH
          </div>
          { !canConnectToContract && 
          <i className="is-block">
            Connect to Ganache
            </i>}
          <button disabled={!canConnectToContract} onClick={addFunds} className="button is-link mr-2">Donate 1 eth</button>
          <button disabled={!canConnectToContract} onClick={() => withdraw('0.5')} className="button is-primary">Withdraw</button>
        </div>
      </div>
    </>
  );
};

export default App;
