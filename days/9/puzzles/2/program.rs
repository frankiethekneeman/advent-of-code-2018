use std::io;
use std::collections::LinkedList;

struct Ring<> {
    marbles: LinkedList<usize>
}

impl Ring {
    fn new() -> Self {
        Ring { marbles: LinkedList::new()  }
    }

    fn move_clockwise(&mut self) {
        if self.marbles.len() > 0 {
            let mover = self.marbles.pop_front().unwrap();
            self.marbles.push_back(mover)
        }
    }

    fn move_counterclockwise(&mut self) {
        if self.marbles.len() > 0 {
            let mover = self.marbles.pop_back().unwrap();
            self.marbles.push_front(mover)
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
            self.marbles.push_front(value);
        } else {
            self.move_clockwise();
            self.marbles.push_front(value);
        }
    }

    //Remove current - return value
    fn remove(&mut self) -> usize {
        if self.marbles.len() > 0 {
            self.marbles.pop_front().unwrap()
        } else {
            0
        }
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
    let mut ring = Ring::new();

    ring.insert(0);
    for marble in 0..(max_marble * 100) {
        scores[marble  % players] += ring.take_move(marble + 1);
    }
    println!("{}", scores.iter().max().unwrap())
}
