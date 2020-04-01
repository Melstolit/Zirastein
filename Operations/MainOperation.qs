namespace Melstolit.Zirastein.Application {

    open Melstolit.Zirastein.Operations;

    operation RunQuantumMain (choice : Int) : Bool[] {

        if (choice == 1)
        {
            return BersteinVariationAlgorithm ();
	    }

        return ClauserHorneShimonyHoltGame (choice == 2);
    }
}
