using Melstolit.Zirastein.Application;
using Microsoft.Quantum.Simulation.Simulators;
using Microsoft.Quantum.Chemistry.Samples.Hydrogen;
using System;

namespace Melstolit.Zirastein.Core
{
    class Application
    {
        public static void Run()
        {
            while (true)
            {
                Console.WriteLine("Available program: ");
                Console.WriteLine("0: Hydrogen Simulator");
                Console.WriteLine("1: Berstein-Vaziranni algorithm");
                Console.WriteLine("2: CHSH Classic strategy");
                Console.WriteLine("3: CHSH Quantum strategy");
                Console.WriteLine("ECS: Quit");

                Console.WriteLine("");

                var keypressed = Console.ReadKey();
                int choice = -1;

                if (keypressed.Key == ConsoleKey.Escape)
                {
                    Console.WriteLine("Exiting...");
                    break;
                }

                if (keypressed.Key == ConsoleKey.D0 || keypressed.Key == ConsoleKey.NumPad0)
                {
                    Program.RunHydrogenEnergySimulator();
                    continue;
                }

                if (keypressed.Key == ConsoleKey.D1 || keypressed.Key == ConsoleKey.NumPad1)
                    choice = 1;

                if (keypressed.Key == ConsoleKey.D2 || keypressed.Key == ConsoleKey.NumPad2)
                    choice = 2;

                using (var qsim = new QuantumSimulator())
                {
                    Console.WriteLine($"The result is {RunQuantumMain.Run(qsim, choice).Result}.");
                }
            }
        }
    }
}
