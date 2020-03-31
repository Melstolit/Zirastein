using Melstolit.Zirastein.Application;
using Microsoft.Quantum.Simulation.Simulators;
using System;

namespace Melstolit.Zirastein.Core
{
    class Application
    {
        public void Run()
        {
            using (var qsim = new QuantumSimulator())
            {
                var result = RunQuantumMain.Run(qsim, 8).Result;

                Console.WriteLine($"The result is {result}.");
            }
        }
    }
}
