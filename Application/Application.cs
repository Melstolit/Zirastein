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
                var keypressed = Console.ReadKey();
                int choice = 0;

                if (keypressed.Key == ConsoleKey.D1 || keypressed.Key == ConsoleKey.NumPad1)
                    choice = 1;

                if (keypressed.Key == ConsoleKey.D2 || keypressed.Key == ConsoleKey.NumPad2)
                    choice = 2;

                var result = RunQuantumMain.Run(qsim, choice).Result;

                Console.WriteLine($"The result is {result}.");
            }
        }
    }
}
