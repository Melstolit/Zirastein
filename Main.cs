using System;
using System.Linq;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Melstolit.Quantum.Zirastein
{
    class BVMain
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                // Consider a function 𝑓(𝑥⃗) on bitstrings 𝑥⃗ = (𝑥₀, …, 𝑥ₙ₋₁) of the
                // form
                //
                //     𝑓(𝑥⃗) ≔ Σᵢ 𝑥ᵢ 𝑟ᵢ
                //
                // where 𝑟⃗ = (𝑟₀, …, 𝑟ₙ₋₁) is an unknown bitstring that determines
                // the parity of 𝑓.

                // The Bernstein–Vazirani algorithm allows determining 𝑟 given a
                // quantum operation that implements
                //
                //     |𝑥〉|𝑦〉 ↦ |𝑥〉|𝑦 ⊕ 𝑓(𝑥)〉.
                //
                // In BernsteinVazirani.qs, we implement this algorithm as the
                // operation BernsteinVazirani. This operation takes an integer
                // whose bits describe 𝑟, then uses those bits to construct an 
                // appropriate operation, and finally measures 𝑟.

                // We call that operation here, ensuring that we always get the
                // same value for 𝑟 that we provided as input.

                const int nQubits = 4;
                foreach (var parity in Enumerable.Range(0, 1 << nQubits))
                {
                    var measuredParity = BernsteinVazirani.Run(qsim, nQubits, parity).Result;
                    if (measuredParity != parity)
                    {
                        throw new Exception($"Measured parity {measuredParity}, but expected {parity}.");
                    }
                }

                Console.WriteLine("All parities measured successfully!");
            }
        }
    }
}