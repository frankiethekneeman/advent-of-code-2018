using System;
using System.Collections.Generic;

namespace _1
{
    enum Terrain { ROCKY, WET, NARROW }
    enum Tool { NEITHER, TORCH, CLIMBING }
    class Utils {
        public static bool canUse(Terrain terrain, Tool tool) {
            return ((int) terrain) != ((int) tool);
        }
        public static Tool getOtherTool(Terrain terrain, Tool tool) {
            return (Tool) (3 - (int) terrain - (int) tool);
        }
    }
    class CaveSystem {
        public readonly int depth;
        public readonly int xTarget;
        public readonly int yTarget;
        private Dictionary<(int,int), int> erosionLevels = 
            new Dictionary<(int,int), int>();
        public CaveSystem(int depth, int xTarget, int yTarget) {
            this.depth = depth;
            this.xTarget = xTarget;
            this.yTarget = yTarget;
            erosionLevels.Add((0,0),0);
            erosionLevels.Add((xTarget, yTarget),0);
        }
        private int calculateErosionLevel(int x, int y) {
            int geologicIndex;
            if ((x == 0 && y == 0) || (x == xTarget && y == yTarget)) {
                geologicIndex = 0;
            } else if (x == 0) {
                geologicIndex = y * 48271;
            } else if (y == 0) {
                geologicIndex = x * 16807;
            } else {
                geologicIndex = getErosionLevel(x-1,y) * getErosionLevel(x,y-1);
            }
            return (geologicIndex + depth) % 20183;
        }
        public int getErosionLevel(int x, int y) {
            if (erosionLevels.ContainsKey((x, y))) {
                return erosionLevels[(x,y)];
            }
            int el = calculateErosionLevel(x, y);
            erosionLevels.Add((x,y), el);
            return el;
        }

        public Terrain getTerrain(int x, int y) {
            return (Terrain) (getErosionLevel(x, y) % 3);
        }

        public bool targetReached(Location l) {
            return l.x == xTarget
                && l.y == yTarget
                && l.equipped == Tool.TORCH;
        }
    }
    class Location {
        public readonly int x;
        public readonly int y;
        public readonly Tool equipped;
        public readonly int timeElapsed;
        public Location(int x, int y, Tool equipped, int timeElapsed) {
            this.x = x;
            this.y = y;
            this.equipped = equipped;
            this.timeElapsed = timeElapsed;
        }
        public bool canGo((int, int) delta, CaveSystem system) {
            (int deltaX, int deltaY) = delta;
            return ((x + deltaX) >= 0)
                && ((y + deltaY) >= 0)
                && (Utils.canUse(system.getTerrain(x + deltaX, y + deltaY), equipped));
        }
        public Location go((int, int) delta, CaveSystem system) {
            (int deltaX, int deltaY) = delta;
            return new Location (x + deltaX, y + deltaY, equipped, timeElapsed + 1);
        }
        public Location switchTools(CaveSystem system) {
            return new Location(x, y, Utils.getOtherTool(system.getTerrain(x, y), equipped), timeElapsed + 7);
        }
        override public String ToString() {
            return "LOCATION(" + x + "," + y + "," + equipped + "," + timeElapsed + ")" ;
        }
    }
    class Node {
        public readonly Location l;
        public Node next;
        public Node(Location l): this(l, null) {
        }
        public Node(Location l, Node next) {
            this.l = l;
            this.next = next;
        }
    }
    class LocationSorter: IComparer<Location> {
        private readonly int xTarget;
        private readonly int yTarget;
        public LocationSorter(int xTarget, int yTarget) {
            this.xTarget = xTarget;
            this.yTarget = yTarget;
        }
        private int distToTarget(Location loc) {
            return Math.Abs(loc.x - xTarget) + Math.Abs(loc.y - yTarget);
        }
        public int Compare(Location l, Location r) {
            if (l.timeElapsed != r.timeElapsed) return l.timeElapsed - r.timeElapsed;
            int distL = distToTarget(l);
            int distR = distToTarget(r);
            if (distL != distR) return distL - distR;
            if (l.x != r.x) return l.x - r.x;
            if (l.y != r.y) return l.y - r.y;
            if (l.equipped != r.equipped) return l.equipped - r.equipped;
            return 0;
        }
    }
    class Program
    {
        static (int,int)[] directions = new (int,int)[]{(1,0), (-1,0), (0,1), (0,-1)};
        static Dictionary<(int, int, Tool), int> minTimes = 
            new Dictionary<(int, int, Tool), int>();
        static Node locations = null;
        static LocationSorter sorter;
        static void Main(string[] args)
        {
            int depth = Int32.Parse(Console.ReadLine().Split(" ")[1]);
            string target = Console.ReadLine().Split(" ")[1];
            int xTarget = Int32.Parse(target.Split(",")[0]);
            int yTarget = Int32.Parse(target.Split(",")[1]);
            CaveSystem exploring = new CaveSystem(depth, xTarget, yTarget);
            sorter = new LocationSorter(xTarget, yTarget);
            Location curr = new Location(0,0,Tool.TORCH,0);
            while(!exploring.targetReached(curr)) {
                Add(curr.switchTools(exploring));
                foreach ((int, int) dir in directions) {
                    if (curr.canGo(dir, exploring)) Add(curr.go(dir, exploring));
                }
                curr = pop();
            }
            Console.WriteLine(curr.timeElapsed);
        }
        static Location pop() {
            Node removed = locations;
            locations = locations.next;
            return removed.l;
        }
        static void Add(Location l){
            (int, int, Tool) key = (l.x, l.y, l.equipped);
            if (minTimes.ContainsKey(key) && minTimes[key] <= l.timeElapsed){
                return;
            }
            minTimes[key] = l.timeElapsed;
            if (locations == null) {
                locations = new Node(l);
                return;
            }
            Node curr = locations;
            Node prev = null;
            while(curr != null && sorter.Compare(l, curr.l) > 0){
                prev = curr;
                curr = curr.next;
            }
            if (curr != null && sorter.Compare(l, curr.l) == 0) {
                return;
            }
            if (prev == null) {
                locations = new Node(l, locations);
            } else {
                prev.next = new Node(l, prev.next);
            }
        }
    }
}
