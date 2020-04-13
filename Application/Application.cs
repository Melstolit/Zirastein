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
                Console.WriteLine("2: Simon algorithm");
                Console.WriteLine("3: CHSH Classic strategy");
                Console.WriteLine("4: CHSH Quantum strategy");
                Console.WriteLine("5: Reflect Grover algorithm");
                Console.WriteLine("6: Deutsch–Jozsa algorithm");
                Console.WriteLine("7: Roetteler algorithm");
                Console.WriteLine("ECS: Quit");

                Console.WriteLine("");

                var keypressed = Console.ReadKey();
                int choice = -1;

                Console.WriteLine($"KeyChar: {keypressed.KeyChar}");

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

                if (keypressed.Key == ConsoleKey.D3 || keypressed.Key == ConsoleKey.NumPad3)
                    choice = 3;

                if (keypressed.Key == ConsoleKey.D4 || keypressed.Key == ConsoleKey.NumPad4)
                    choice = 4;

                if (keypressed.Key == ConsoleKey.D5 || keypressed.Key == ConsoleKey.NumPad5)
                    choice = 5;

                if (keypressed.Key == ConsoleKey.D6 || keypressed.Key == ConsoleKey.NumPad6)
                    choice = 6;

                if (keypressed.Key == ConsoleKey.D7 || keypressed.Key == ConsoleKey.NumPad7)
                    choice = 7;

                using (var qsim = new QuantumSimulator())
                {
                    Console.WriteLine($"The result is {RunQuantumMain.Run(qsim, choice).Result}.");
                }
            }
        }
    }
}
