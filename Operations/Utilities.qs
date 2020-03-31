namespace Melstolit.Zirastein.Utilities {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;


    operation Utilities () : Unit {
        
    }

    operation SampleQuantumRandomNumberGenerator() : Result {
        using (q = Qubit())  {
            H(q);
            let r = M(q);
            Reset(q);
            return r;
        }
    }
}
