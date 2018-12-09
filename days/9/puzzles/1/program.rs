use std::io;
use std::vec::Vec;

struct Ring<> {
    current: usize,
    marbles: Vec<usize>
}

impl Ring {
    fn new(cap: usize) -> Self {
        Ring { current: 0, marbles: Vec::with_capacity(cap)  }
    }

    fn move_clockwise(&mut self) {
        self.current = (self.current + 1) % self.marbles.len()
    }

    fn move_counterclockwise(&mut self) {
        if self.current == 0 {
            self.current = self.marbles.len() - 1;
        } else {
            self.current = self.current - 1;
            
        }
    }

    fn move_counterclockwise_count(&mut self, count: usize) {
        for _turn in 0..count {
            self.move_counterclockwise()
        }
    }

    // insert to right of current, become current
    fn insert(&mut self, value: usize) {
        if self.marbles.len() == 0 {
            self.marbles.push(value);
        } else {
            self.marbles.insert(self.current + 1, value);
        }
        self.move_clockwise();
    }

    //Remove current - return value
    fn remove(&mut self) -> usize {
        let to_ret = self.marbles.remove(self.current);
        self.current = self.current % self.marbles.len();
        to_ret
    }

    fn take_move(&mut self, value: usize) -> usize {
        if value % 23 == 0 {
            self.move_counterclockwise_count(7);
            value + self.remove()
        } else {
            self.move_clockwise();
            self.insert(value);
            0
        }
    }
}

fn main() {
    let mut input = String::new();

    io::stdin().read_line(&mut input)
        .expect("Failed to read line");

    let pieces: Vec<&str> = input.split(' ').collect();

    let players: usize = pieces[0].parse().unwrap();
    let max_marble: usize = pieces[6].parse().unwrap();

    let mut scores = vec![0; players].into_boxed_slice();
    let mut ring = Ring::new(max_marble - (max_marble/23) * 2 + 1);

    ring.insert(0);
    for marble in 0..(max_marble) {
        scores[marble  % players] += ring.take_move(marble + 1);
    }
    println!("{}", scores.iter().max().unwrap())
}
