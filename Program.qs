// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Melstolit.Quantum.Zirastein {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    
    //////////////////////////////////////////////////////////////////
    // Bernstein-Vazirani Algorithm
    //////////////////////////////////////////////////////////////////
    
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length N represented as Int[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    
    // Note: the functions featured in tasks 1.1, 1.3 and 1.4 are special cases of this function.
    operation Oracle_ProductFunction (x : Qubit[], y : Qubit, r : Int[]) : Unit
    is Adj {
            
        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }


    // Inputs:
    //      1) N qubits in |0⟩ state (query register)
    //      2) a qubit in |0⟩ state (answer register)
    operation BV_StatePrep (query : Qubit[], answer : Qubit) : Unit
    is Adj {        
        ApplyToEachA(H, query);
        X(answer);
        H(answer);
    }
    
    
    // Bernstein-Vazirani algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is a scalar product function
    // (can be represented as f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁)).
    // Output:
    //      A bit vector r reconstructed from the function
    
    // Note: a trivial approach is to call the oracle N times:
    //       |10...0⟩|0⟩ = |10...0⟩|r₀⟩, |010...0⟩|0⟩ = |010...0⟩|r₁⟩ and so on.
    // Quantum computing allows to perform this task in just one call to the oracle; try to implement this algorithm.
    operation BV_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
                
        // allocate N qubits for input register and 1 qubit for output
        using ((x, y) = (Qubit[N], Qubit())) {
            
            // prepare qubits in the right state
            BV_StatePrep(x, y);
            
            // apply oracle
            Uf(x, y);
            
            // apply Hadamard to each qubit of the input register
            ApplyToEach(H, x);
            
            // measure all qubits of the input register;
            // the result of each measurement is converted to an Int
            mutable r = new Int[N];
            for (i in 0 .. N - 1) {
                if (M(x[i]) != Zero) {
                    set r w/= i <- 1;
                }
            }
            
            // before releasing the qubits make sure they are all in |0⟩ state
            ResetAll(x);
            Reset(y);
            return r;
        }
    }
    
    // Execute BV algo
    operation BV_Execute() : Unit {
        mutable r = [1, 1, 1, 0, 0];

        let oracle = Oracle_ProductFunction(_, _, r);
        BV_Algorithm(Length(r), oracle);
	}

}
