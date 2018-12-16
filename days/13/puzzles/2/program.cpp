//#include <functional>
#include <iostream>
#include <list>
#include <queue>
#include <map>
#include <unordered_set>
#include <utility>
using namespace std;

enum TrackType {
    horizontal='-'
    , vertical='|'
    , crossing='+'
    , corner='/'
    , reverseCorner='\\'
    , none=' '
};

enum CrossingChoice { tleft, straight, tright };
enum Direction { west='<', north='^', south='v', east='>' };

TrackType parseTrackPos(char c) {
    switch(c) {
        case '-': 
        case '>':
        case '<':
            return horizontal;
        case '|':
        case '^':
        case 'v':
            return vertical;
        case '+':
            return crossing;
        case '/':
            return corner;
        case '\\':
            return reverseCorner;
        default:
            return none;
    }
}

class Context {
    public:
    int x;
    int y;
    Direction facing;
    CrossingChoice nextTime;

    Context(
        int _x
        , int _y
        , Direction _facing
        , CrossingChoice _nextTime
    ) {
        x = _x;
        y = _y;
        facing = _facing;
        nextTime = _nextTime;
    }
    Context() {
        Context(0, 0, north, straight);
    }
    string toString() {
        return "(" + to_string(x) + ", " + to_string(y) + ", " + (char) facing + 
        + ", " + to_string(nextTime) + ")";
    }

    string location()  {
        return to_string(x) + "," + to_string(y);
    }

    int sortablePos() {
        return x * 10000 + y;
    }


    bool operator==(const Context &rhs) const {
        return x == rhs.x
            && y == rhs.y
            && facing == rhs.facing
            && nextTime == rhs.nextTime;
    }
};

class Cart {
    public:
        int x;
        int y;
        Direction facing;
        CrossingChoice nextTime = tleft;
        Context startingContext;
        list<Context> history;
        int t = 0;
        bool looped = false;
        Context* positions;
        int npositions;

        Cart(int _x, int _y, char _facing) {
            x = _x;
            y = _y;
            facing = getDirection(_facing);
            startingContext = registerLocation();
            looped = false;
        }

        string toString() {
            return "(" + to_string(x) + ", " + to_string(y) + ", " + (char) facing + ")";
        }

        void tick(TrackType** track) {
            if (!looped) {
                t++;
                move();
                facing = turn(track[x][y]);
                registerLocation();
            }
        }

        Context at(int q) {
            if (q < npositions) {
                return positions[q];
            }
            return positions[ q % npositions];
        }
    private:
        Direction getDirection(char rep) {
            switch (rep) {
                case '>': return east;
                case '<': return west;
                case '^': return north;
                case 'v': return south;
            }
            throw "Nope.";
        }

        void move() {
            switch(facing) {
                case north: y--;
                    break;
                case south: y++;
                    break;
                case east: x++;
                    break;
                case west: x--;
                    break;
            }
        }

        Direction turn(TrackType t) {
            switch(t) {
                case vertical:
                case horizontal:
                    return facing;
                case crossing:
                    return crossingDecision();
                case corner:  // '/'
                    switch(facing) {
                        case north: return east;
                        case south: return west;
                        case east: return north;
                        case west: return south;
                    }
                case reverseCorner:  // '\'
                    switch(facing) {
                        case north: return west;
                        case south: return east;
                        case west: return north;
                        case east: return south;
                    }

                case none: throw "No.";
            }
        }

        Direction crossingDecision() {
            switch (nextTime) {
                case tleft:
                    nextTime = straight;
                    switch(facing) {
                        case north: return west;
                        case south: return east;
                        case west: return south;
                        case east: return north;
                    }
                case straight:
                    nextTime = tright;
                    return facing;
                case tright:
                    nextTime = tleft;
                    switch(facing) {
                        case north: return east;
                        case south: return west;
                        case west: return north;
                        case east: return south;
                    }
            }
        }

        Context registerLocation() {
            Context current(x, y, facing, nextTime);
            if (current == startingContext) {
                looped = true;
                npositions = history.size();
                positions = new Context[npositions];
                int i = 0;
                for(auto pos = history.begin(); pos != history.end(); ++pos, ++i) {
                    positions[i] = *pos;
                }
            } else {
                history.push_back(current);
            }
            return current;
        }
};

string locationString(pair<int, int> p) {
    return to_string(p.first) + "," + to_string(p.second);
}

map<int, Cart*> tick(map<int, Cart*> startingPositions, int nextT) {
    map<int, Cart*> nextPositions;
    for (auto p = startingPositions.begin(); p != startingPositions.end(); p++) {
        int start = p->first;
        int end = p->second->at(nextT).sortablePos(); 
        if (nextPositions.count(start)) {
            //Someone Ran into me!
            nextPositions.erase(start);
        } else if (nextPositions.count(end)) {
            //I ran into someone!
            nextPositions.erase(end);
        } else {
            nextPositions[end] = p->second;
        }
    }
    return nextPositions;
}
string findLastCart(list<Cart> carts) {
    map<int, Cart*> positions;
    for (auto cart = carts.begin(); cart != carts.end(); cart++) {
        positions[cart->at(0).sortablePos()] = &*cart;
    }
    int t;
    for (t = 1; positions.size() != 1; t++) {
        positions = tick(positions, t);
    }
    return positions.begin()->second->at(t-1).location();
}
int main()
{
    unordered_set<char> CART_DEPICTIONS;
    CART_DEPICTIONS.insert('>');
    CART_DEPICTIONS.insert('<');
    CART_DEPICTIONS.insert('^');
    CART_DEPICTIONS.insert('v');
    list<Cart> carts;
    string row;
    queue<string> rows;
    int width = 0;
    while (getline(cin, row)) {
        rows.push(row);
        if (row.length() > width) {
            width = row.length();
        }
    }
    int height = rows.size();
    TrackType** track = new TrackType*[width];
    for (int x = 0; x < width; x++) {
        track[x] = new TrackType[height];
    }
    for (int y = 0; y < height; y++) {
        row = rows.front();
        rows.pop();
        for (int x = 0; x < row.length(); x++) {
            track[x][y] = parseTrackPos(row[x]);
            if (CART_DEPICTIONS.count(row[x])) {
                Cart ci(x, y, row[x]);
                carts.push_back(ci);
            }
        }
        for (int x = row.length(); x < width; x++) {
            track[x][y] = none;
        }
    }

    for (auto cart = carts.begin(); cart != carts.end(); cart++) {
      while (!cart->looped) {
          cart->tick(track);
      }
    }
    
    cout << findLastCart(carts) << "\n";

    return 0;
}
