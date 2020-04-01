// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Melstolit.Zirastein.Operations {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;

    operation make_bernstein_vazirani_circuit(input_qubits : Qubit[], output_qubit : Qubit, secret_factor_bits : Bool[], secret_bias_bit : Bool, oracle : ((Qubit[], Qubit) => Unit)) : Bool[]
    {
        X(output_qubit);
        H(output_qubit);

        ApplyToEach(H, input_qubits);
        oracle(input_qubits, output_qubit);

        let resultArray = ForEach(MResetZ, input_qubits);

        Reset(output_qubit);

        return ResultArrayAsBoolArray(resultArray);
	}

    operation _make_oracle(input_qubits : Qubit[], output_qubit : Qubit, secret_factor_bits : Bool[], secret_bias_bit : Bool) : Unit
    {
        if (secret_bias_bit){
			X(output_qubit);
		}

        for ((qubit, bit) in Zip(input_qubits, secret_factor_bits)) {
            if (bit) {
                Controlled X([qubit], output_qubit);
            }
        }
	}

    function make_oracle(secret_factor_bits : Bool[], secret_bias_bit : Bool) : ((Qubit[], Qubit) => Unit)
    {
        return _make_oracle(_, _, secret_factor_bits, secret_bias_bit);
	}

    operation BersteinVariationAlgorithm () : Bool[] {
        let nQubits = 8;

        using ((input_qubits , output_qubit ) = (Qubit[nQubits], Qubit())) {
            let secret_bias_bit = RandomInt(2) == 1 ? true | false;
            let secret_factor_bits = IntAsBoolArray(RandomInt(63), nQubits);

            let oracle = make_oracle(secret_factor_bits, secret_bias_bit);
            let temporary = make_bernstein_vazirani_circuit(input_qubits, output_qubit, secret_factor_bits, secret_bias_bit, oracle);

            return temporary;
		}
        
    }
}
