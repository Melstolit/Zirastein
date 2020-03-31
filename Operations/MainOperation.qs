namespace Melstolit.Zirastein.Application {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Melstolit.Zirastein.Operations;
    open Melstolit.Zirastein.Utilities;

    operation RunQuantumMain (nQubits : Int) : Bool[] {

        using ((input_qubits , output_qubit ) = (Qubit[nQubits], Qubit())) {
            let secret_bias_bit = IsResultOne(SampleQuantumRandomNumberGenerator());
            mutable count = 0;

            for(_ in 0..63)
            {
                if(SampleQuantumRandomNumberGenerator() == One) {
                    set count += 1;       
	            }
			}

            // Random 8 bit ???
            let secret_factor_bits = IntAsBoolArray(count, nQubits);

            let oracle = make_oracle(secret_factor_bits, secret_bias_bit);
            let temporary = make_bernstein_vazirani_circuit(input_qubits, output_qubit, secret_factor_bits, secret_bias_bit, oracle);

            return temporary;
		}
        
    }
}
