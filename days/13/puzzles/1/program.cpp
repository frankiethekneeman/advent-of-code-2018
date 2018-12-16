#include <functional>
#include <iostream>
#include <list>
#include <queue>
#include <unordered_map>
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
    int t;

    Context(
        int _x
        , int _y
        , Direction _facing
        , CrossingChoice _nextTime
        , int _t
    ) {
        x = _x;
        y = _y;
        facing = _facing;
        t = _t;
        nextTime = _nextTime;
    }

    bool operator==(const Context &rhs) const {
        return x == rhs.x
            && y == rhs.y
            && facing == rhs.facing
            && nextTime == rhs.nextTime;
    }
};

template<> struct hash<Context>{
    size_t operator()(const Context& c) const {
        return ((c.x * 1000 + c.y ) * 1000 + c.facing ) * 1000 + c.nextTime;
    }
};

class Cart {
    public:
        int x;
        int y;
        Direction facing;
        CrossingChoice nextTime = tleft;
        unordered_set<Context> seenPositions;
        list<pair<int, int>> history;
        int t = 0;
        bool looped = false;
        int loopBack = -1;
        pair<int, int>* positions;
        int npositions;

        Cart(int _x, int _y, char _facing) {
            x = _x;
            y = _y;
            facing = getDirection(_facing);
            registerLocation();
            looped = false;
            loopBack = -1;
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

        pair<int, int> at(int q) {
            if (q < npositions) {
                return positions[q];
            }
            return positions[ ((q-loopBack) % (npositions - loopBack)) + loopBack ];
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

        void registerLocation() {
            Context current(x, y, facing, nextTime, t);
            if (seenPositions.count(current)) {
                looped = true;
                npositions = history.size();
                positions = new pair<int, int>[npositions];
                int i = 0;
                for(auto pos = history.begin(); pos != history.end(); ++pos, ++i) {
                    positions[i] = *pos;
                    //cout << i;
                    //for (int loops = 1; loops < 10; loops++) {
                    //     cout << ", " << i + loops * npositions;
                    //}
                    //cout << ": "<< positions[i].first << ", "  << positions[i].second
                    //    << "\n";
                }
                
                loopBack = seenPositions.find(current)->t;
            } else {
                seenPositions.insert(current);
                history.push_back(make_pair(x, y));
            }
        }
};

string locationString(pair<int, int> p) {
    return to_string(p.first) + "," + to_string(p.second);
}

string findFirstCrash(list<Cart> carts) {
    unordered_set<string> seen;
    for (int t = 0; true; t++) {
        for (auto cart = carts.begin(); cart != carts.end(); cart++) {
            string loc = locationString(cart->at(t));
            if ( seen.count(loc)) return loc;
            seen.insert(loc);
        }
        seen.clear();
    }
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
    
    cout << findFirstCrash(carts) << "\n";

    return 0;
}
