pragma circom 2.0.0;

include "node_modules/circomlib/circuits/comparators.circom";

template AgeVerifier() {
    signal input age;
    signal input limit;

    signal output result;

    component ge = GreaterEqThan(8);     //8 bits -- age could be till 255

    ge.in[0] <== age;
    ge.in[1] <== limit;

    result <== ge.out;

}

component main { public [limit]} = AgeVerifier();