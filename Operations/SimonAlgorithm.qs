// Microsoft Quantum Katas - Demonstrates the Simon algorithm.

namespace Melstolit.Zirastein.Operations {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    // Quantum part of Simon's algorithm
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is N-qubit answer register, and f is a function
    //         from N-bit strings into N-bit strings
    //
    // The function f is guaranteed to satisfy the following property:
    // there exists some N-bit string s such that for all N-bit strings b and c (b != c)
    // we have f(b) = f(c) if and only if b = c ⊕ s. In other words, f is a two-to-one function.
    //
    // An example of such function is bitwise right shift function from task 1.2;
    // the bit string s for it is [0, ..., 0, 1].
    //
    // Output:
    //      Any bit string b such that Σᵢ bᵢ sᵢ = 0 modulo 2.
    //
    // Note that the whole algorithm will reconstruct the bit string s itself, but the quantum part of the
    // algorithm will only find some vector orthogonal to the bit string s. The classical post-processing
    // part is already implemented, so once you implement the quantum part, the tests will pass.
    operation make_simon_circuit(x : Qubit[], y : Qubit[], nQubits : Int, oracle : ((Qubit[], Qubit[]) => Unit)) : Bool[]
    {
        ApplyToEach(H, x);
        oracle(x, y);
        ApplyToEach(H, x);
        
        mutable j = new Bool[nQubits];
        for (i in 0 .. nQubits - 1) {
            if (M(x[i]) == One) {
                set j w/= i <- true;
            }
        }

        ResetAll(x);
        ResetAll(y);
        return j;
	}

    // Multidimensional linear operator
    // Inputs:
    //      1) N1 qubits in an arbitrary state |x⟩ (input register)
    //      2) N2 qubits in an arbitrary state |y⟩ (output register)
    //      3) an N2 x N1 matrix (represented as an Int[][]) describing operator A
    //         (see https://en.wikipedia.org/wiki/Transformation_matrix ).
    //         The first dimension of the matrix (rows) corresponds to the output register,
    //         the second dimension (columns) - the input register,
    //         i.e., A[r][c] (element in r-th row and c-th column) corresponds to x[c] and y[r].
    // Goal: Transform state |x, y⟩ into |x, y ⊕ A(x) ⟩ (⊕ is addition modulo 2).
    operation _make_soracle(x : Qubit[], y : Qubit[], A : Int[][]) : Unit
    {
        let N1 = Length(y);
        let N2 = Length(x);
            
        for (i in 0 .. N1 - 1) {
            for (j in 0 .. N2 - 1) {
                if ((A[i])[j] == 1) {
                    CNOT(x[j], y[i]);
                }
            }
        }
	}

    function make_soracle(matrix : Int[][]) : ((Qubit[], Qubit[]) => Unit)
    {
        return _make_soracle(_, _, matrix);
	}

    operation make_matrix(N : Int) : Int[][]
    {
        mutable matrix = new (Int[])[8];
        mutable line = new Int[8];

        for (i in 0 .. N - 1) {
            //set matrix w/= i <- new Int[8];
            for (j in 0 .. N - 1) {
                set line w/= j <- RandomInt(2);
			}
            set matrix w/= i <- line;
		}

        return matrix;
	}

    // "Simon's Algorithm" kata is an exercise designed to teach a quantum algorithm for
    // a problem of identifying a bit string that is implicitly defined (or, in other words, "hidden") by
    // some oracle that satisfies certain conditions. It is arguably the most simple case of an (oracle)
    // problem for which a quantum algorithm has a *provable* exponential advantage over any classical algorithm.
    
    // Each task is wrapped in one operation preceded by the description of the task. Each task (except tasks in
    // which you have to write a test) has a unit test associated with it, which initially fails. Your goal is to
    // fill in the blank (marked with // ... comment) with some Q# code to make the failing test pass.
    operation SimonAlgorithm () : Bool[] {
        
        let nQubits = 8;

        using ((input_qubits , output_qubits ) = (Qubit[nQubits], Qubit[nQubits])) {
            let m = make_matrix(nQubits);

            let oracle = make_soracle(m);
            let temporary = make_simon_circuit(input_qubits, output_qubits, nQubits, oracle);

            return temporary;
		}
    }
}
