namespace Melstolit.Zirastein.Operations {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;


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
