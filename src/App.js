import { useEffect, useState } from 'react';
import './App.css';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import { loadContract } from './utils/load-contract';

const App = () => {
  const [web3Api, setWeb3Api] = useState({ provider: null, web3: null, contract: null });
  const [account, setAccount] = useState(null);
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    const loadBalance = async () => {
      const { contract, web3 } = web3Api;
      const balance = await web3.eth.getBalance(contract.options.address);
      setBalance(web3Api.web3.utils.fromWei(`${balance}`, "ether"));
    }
    web3Api.contract && loadBalance()
  }, [web3Api]);

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

        const web3 = new Web3(provider);
        const contract = await loadContract('Faucet', web3);
        console.log("Faucet contract", contract);

        setWeb3Api({
          web3,
          provider,
          contract
        });
        console.log('Ethereum successfully detected!');
      } else {
        // if the provider is not detected, detectEthereumProvider resolves to null
        console.error('Please install MetaMask!');
      }
    };
    loadProvider();
  }, []);

  useEffect(() => {
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts();
      setAccount(accounts[0]);
    };
    web3Api.web3 && getAccount();
  }, [web3Api.web3]);

  console.log(account);

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <div className="is-flex align-items is-align-items-center">
            <span><strong className="mr-2">Account: </strong></span>
            {account ? <span>{account}</span> : <button onClick={() => web3Api.provider.request({ method: "eth_requestAccounts" })} className='button is-small'>Connect Wallet</button>}</div>
          <div className="balance-view is-size-2 my-4">
            Current Balance: <strong>{balance}</strong>&nbsp;ETH
          </div>
          <button className="button is-link mr-2">Donate</button>
          <button className="button is-primary">Withdraw</button>
        </div>
      </div>
    </>
  );
};

export default App;
