// Wikipedia.org - Demonstrates the Bernstein–Vazirani algorithm.

namespace Melstolit.Zirastein.Operations {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;

    /// # Summary
    /// ParityViaFourierSampling implements the Bernstein-Vazirani quantum algorithm.
    /// This algorithm computes for a given Boolean function that is promised to be
    /// a parity 𝑓(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ a result in form of
    /// a bit vector (𝑟₀, …, 𝑟ₙ₋₁) corresponding to the parity function.
    /// Note that it is promised that the function is actually a parity function.
    ///
    /// # Input
    /// ## Uf
    /// A quantum operation that implements |𝑥〉|𝑦〉 ↦ |𝑥〉|𝑦 ⊕ 𝑓(𝑥)〉,
    /// where 𝑓 is a Boolean function that implements a parity Σᵢ 𝑟ᵢ 𝑥ᵢ.
    /// ## n
    /// The number of bits of the input register |𝑥〉.
    ///
    /// # Output
    /// An array of type `Bool[]` that contains the parity 𝑟⃗ = (𝑟₀, …, 𝑟ₙ₋₁).
    ///
    /// # See Also
    /// - For details see Section 1.4.3 of Nielsen & Chuang.
    ///
    /// # References
    /// - [ *Ethan Bernstein and Umesh Vazirani*,
    ///     SIAM J. Comput., 26(5), 1411–1473, 1997 ](https://doi.org/10.1137/S0097539796300921)
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

    // To demonstrate the Bernstein–Vazirani algorithm, we define
    // a function which returns black-box operations (Qubit[] => ()) of
    // the form

    //    U_f |𝑥〉|𝑦〉 = |𝑥〉|𝑦 ⊕ 𝑓(𝑥)〉,

    // as described above.

    // In particular, we define 𝑓 by providing the pattern 𝑟⃗. Thus, we can
    // easily assert that the pattern measured by the Bernstein–Vazirani
    // algorithm matches the pattern we used to define 𝑓.

    // As is idiomatic in Q#, we define an operation that we will typically
    // only call by partially applying it from within a matching function.
    // To indicate that we are using this idiom, we name the operation
    // with an initial underscore to mark it as private, and provide
    // documentation comments for the function itself.
    operation _make_boracle(input_qubits : Qubit[], output_qubit : Qubit, secret_factor_bits : Bool[], secret_bias_bit : Bool) : Unit
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

    /// # Summary
    /// Given a bitstring 𝑟⃗ = (r₀, …, rₙ₋₁), returns an operation implementing
    /// a unitary 𝑈 that acts on 𝑛 + 1 qubits as
    ///
    ///       𝑈 |𝑥〉|𝑦〉 = |𝑥〉|𝑦 ⊕ 𝑓(𝑥)〉,
    /// where 𝑓(𝑥) = Σᵢ 𝑥ᵢ 𝑟ᵢ mod 2.
    ///
    /// # Input
    /// ## pattern
    /// The bitstring 𝑟⃗ used to define the function 𝑓.
    ///
    /// # Output
    /// An operation implementing 𝑈.
    function make_boracle(secret_factor_bits : Bool[], secret_bias_bit : Bool) : ((Qubit[], Qubit) => Unit)
    {
        return _make_boracle(_, _, secret_factor_bits, secret_bias_bit);
	}

    operation BersteinVaziraniAlgorithm () : Bool[] {
        let nQubits = 8;

        using ((input_qubits , output_qubit ) = (Qubit[nQubits], Qubit())) {
            let secret_bias_bit = RandomInt(2) == 1 ? true | false;
            let secret_factor_bits = IntAsBoolArray(RandomInt(63), nQubits);

            let oracle = make_boracle(secret_factor_bits, secret_bias_bit);
            let temporary = make_bernstein_vazirani_circuit(input_qubits, output_qubit, secret_factor_bits, secret_bias_bit, oracle);

            return temporary;
		}
        
    }
}
