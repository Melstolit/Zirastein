// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Melstolit.Zirastein.Operations {

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    //open Microsoft.Quantum.Diagnostics;


    function WinCondition (x : Bool, y : Bool, a : Bool, b : Bool) : Bool {
        return (x and y) == (a != b);
    }

    function AliceClassical (x : Bool) : Bool {
        return x;
    }

    function BobClassical (y : Bool) : Bool {
        return y;
    }

    operation CreateEntangledPair (qs : Qubit[]) : Unit
    is Adj {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }

    operation AliceQuantum (bit : Bool, qubit : Qubit) : Bool {
        let basis = bit ? PauliX | PauliZ;
        return ResultAsBool(Measure([basis], [qubit]));
    }

    operation RotateBobQubit (clockwise : Bool, qubit : Qubit) : Unit {
        let angle = 2.0 * PI() / 8.0;
        Ry(clockwise ? -angle | angle, qubit);
    }

    operation BobQuantum (bit : Bool, qubit : Qubit) : Bool {
        RotateBobQubit(not bit, qubit);
        return ResultAsBool(M(qubit));
    }

    operation PlayQuantumCHSH (askAlice : (Qubit => Bool),
                                         askBob : (Qubit => Bool)) : (Bool, Bool) {

        using ((aliceQubit, bobQubit) = (Qubit(), Qubit())) {
            CreateEntangledPair([aliceQubit, bobQubit]);

            let aliceResult = askAlice(aliceQubit);
            let bobResult = askBob(bobQubit);

            Reset(aliceQubit);
            Reset(bobQubit);
            return (aliceResult, bobResult);
        }

    }

    operation AliceBobClassicalGame() : Bool[] {
        mutable wins = 0;
        for (i in 1..1000) {
            let x = RandomInt(2) == 1 ? true | false;
            let y = RandomInt(2) == 1 ? true | false;
            let (a, b) = (AliceClassical(x), BobClassical(y));
            if (WinCondition(x,y,a,b)) {
                set wins = wins + 1;
            }
        }
        //EqualityWithinToleranceFact(IntAsDouble(wins) / 10000., 0.03, 0.005);
        return [IntAsDouble(wins) / 10000. < 0.035 and IntAsDouble(wins) / 10000. > 0.025];
    }

    operation AliceBobQuantumGame () : Bool[] {
        mutable wins = 0;
        for (i in 1..10000) {
            let x = RandomInt(2) == 1 ? true | false;
            let y = RandomInt(2) == 1 ? true | false;
            let (a, b) = PlayQuantumCHSH(AliceQuantum(x, _), BobQuantum(y, _));
            if (WinCondition(x,y,a,b)) {
                set wins = wins + 1;
            }
        }
        //EqualityWithinToleranceFact(IntAsDouble(wins) / 10000., 0.85, 0.01);
        return [IntAsDouble(wins) / 10000. < 0.86 and IntAsDouble(wins) / 10000. > 0.84];
    }

    operation ClauserHorneShimonyHoltGame(isClassicType : Bool) : Bool[] {
        if(isClassicType) {
            return AliceBobClassicalGame();
	    }
        return AliceBobQuantumGame();
	}
}
