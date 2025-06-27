import { useContractRead } from "wagmi";
import FanCredNFT_ABI from "./FanCredNFT_ABI.json";

function FanProfile() {
  const { data: nftBalance } = useContractRead({
    address: "0xYourContractAddress",
    abi: FanCredNFT_ABI,
    functionName: "balanceOf",
    args: [userAddress],
  });

  return <div> Your FanCred NFTs: {nftBalance} </div>;
}
