namespace Melstolit.Zirastein.Application {

    open Melstolit.Zirastein.Operations;
    open Microsoft.Quantum.Arrays;

    operation RunQuantumMain (choice : Int) : Bool[] {

        if (choice == 1)
        {
            return BersteinVaziraniAlgorithm ();
	    }

        if (choice == 2)
        {
            return SimonAlgorithm ();
	    }

        if (choice == 5)
        {
            return ReflectedGrover (8);
		}

        if (choice == 6)
        {
            return DeutschJozsaTestCase ();
		}

        if (choice == 7)
        {
            return HiddenShiftBentCorrelationTestCase ();
		}

        return ClauserHorneShimonyHoltGame (choice == 4);
    }
}
