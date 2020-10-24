import * as secp256k1 from 'secp256k1/secp256k1-wasm_bg.wasm';


const thing = secp256k1.memory.buffer;
secp256k1.rustsecp256k1_v0_2_0_ecdsa_verify
console.log(thing);