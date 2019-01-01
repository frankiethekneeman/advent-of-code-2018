using System;

namespace _1
{
    class Program
    {
        static void Main(string[] args)
        {
            int depth = Int32.Parse(Console.ReadLine().Split(" ")[1]);
            string target = Console.ReadLine().Split(" ")[1];
            int xTarget = Int32.Parse(target.Split(",")[0]);
            int yTarget = Int32.Parse(target.Split(",")[1]);
            int[,] erosionLevels = new int[xTarget + 1,yTarget + 1];
            for (int x = 0; x <=xTarget; x++) {
                for (int y = 0; y <= yTarget; y++) {
                    int geologicIndex;
                    if ((x == 0 && y == 0) || (x == xTarget && y == yTarget)) {
                        geologicIndex = 0;
                    } else if (x == 0) {
                        geologicIndex = y * 48271;
                    } else if (y == 0) {
                        geologicIndex = x * 16807;
                    } else {
                        geologicIndex = erosionLevels[x-1,y] * erosionLevels[x,y-1];
                    }
                    int el = (geologicIndex + depth) % 20183;
                    erosionLevels[x,y] = el;
                }
            }
            int riskLevel = 0;
            foreach (int el in erosionLevels) {
                riskLevel += el % 3;
            }
            Console.WriteLine(riskLevel);

        }
    }
}
