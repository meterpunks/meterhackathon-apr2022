import NftContractProvider from '../lib/NftContractProvider';

async function main() {
  // Attach to deployed contract
  const contract = await NftContractProvider.getContract();
  
  //await (await contract.mint(2)).estimateGas((err, gas) => {
   //     console.log(gas);
    //}).wait();
    await (await contract.methods.mint(2).estimateGas({from: '0x2afC1284B4B2420F7564cbEBA57f87301Be0e4B6'})
    .then(function(gasAmount){
        console.log(gasAmount+' : gas');
    }).catch(function(error){
        console.log(error+' : error');
    }).wait();
  //await (await contract.mintForAddress(5,'0x2afC1284B4B2420F7564cbEBA57f87301Be0e4B6')).wait();

  console.log('Minted 10!');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
