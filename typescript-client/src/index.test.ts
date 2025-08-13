import { ethers } from 'ethers';
import { testData } from './env';


describe('index', () => {
  const anAmount = 1;
  const aNonce = 0;
  const userWallet = new ethers.Wallet(testData.userPrivateKey());
  const ownerWallet = new ethers.Wallet(testData.ownerPrivateKey());
  const hashOf = (anAddress: string, anAmount: number, aNonce: number) => ethers.solidityPackedKeccak256(
    ['address', 'uint256', 'uint256'],
    [anAddress, anAmount, aNonce]
  );

  test('hash', () => {
    expect(hashOf(userWallet.address, anAmount, aNonce))
      .toEqual('0x75ca50b4c42ed7acf175082fdb327f998983a6f92f9e4cc4e555fb30f6fbc1bd');
  });

  test('signature', async () => {
    const hash = hashOf(userWallet.address, anAmount, aNonce);

    const signature = await ownerWallet.signMessage(ethers.toBeArray(hash));

    expect(signature)
      .toEqual('0x5cff4b47ae35b24fdabe84436e6c3a6ea2e3af178a3c73c31cbf7800d80d548f2fe6c7aaf09068904165ca40467c6551dae21b59e478bf5fb55cf74713d1cd601b');
  });
});
