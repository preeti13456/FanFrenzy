import { EthereumClient, w3mConnectors } from "@web3modal/ethereum";
import { Web3Modal } from "@web3modal/react";
import { configureChains, createConfig, WagmiConfig } from "wagmi";
import { chiliz } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";

const chains = [chiliz];
const projectId = "YOUR_WALLETCONNECT_PROJECT_ID";

const { publicClient } = configureChains(chains, [publicProvider()]);
const wagmiConfig = createConfig({
  autoConnect: true,
  connectors: w3mConnectors({ projectId, chains }),
  publicClient,
});

const ethereumClient = new EthereumClient(wagmiConfig, chains);

function App() {
  return (
    <>
      <WagmiConfig config={wagmiConfig}> {/* Your dApp UI */} </WagmiConfig>{" "}
      <Web3Modal projectId={projectId} ethereumClient={ethereumClient} />{" "}
    </>
  );
}

export default App;
