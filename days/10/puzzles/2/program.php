<?php
class Point {
    public $x;
    public $y;
    public $vx;
    public $vy;

    function __construct($x, $y, $vx, $vy) {
        $this->x = $x;
        $this->y = $y;
        $this->vx = $vx;
        $this->vy = $vy;
    }

    function key() {
        return "{$this->x}:{$this->y}";
    }
    function below() {
        return new Point($this->x, $this->y - 1, $this->vx, $this->vy);
    }
    function tick() {
        return new Point($this->x + $this->vx, $this->y + $this->vy, $this->vx, $this->vy);
    }
}

class Field {
    public $ts = 0;
    public $points = [];
    public $allPts = [];
    function addPoint($pt) {
        $this->points[$pt->key()] = true;
        $this->allPts[] = $pt;
    }
    function verticality() {
        $pointsVertical = 0;
        foreach ($this->allPts as $pt) {
            if (array_key_exists($pt->below()->key(), $this->points)) {
                $pointsVertical++;
            }
        }
        return $pointsVertical;
    }
    function tick() {
        $toRet = new Field;
        foreach($this->allPts as $pt) {
            $toRet->addPoint($pt->tick());
        }
        $toRet->ts = $this->ts + 1;
        return $toRet;
    }
    function xrange() {
        $xs=array_map(function ($pt) { return $pt->x; }, $this->allPts);
        return range(min($xs),max($xs));
    }
    function yrange() {
        $ys=array_map(function ($pt) { return $pt->y; }, $this->allPts);
        return range(min($ys),max($ys));
    }
    function maxCoord() {
        $maxX = max($this->xrange());
        $maxY = max($this->yrange());
        return max([$maxX, $maxY]);
    }

    function render() {
        $toRet="";
        foreach ($this->yrange() as $y) {
            foreach ($this->xrange() as $x) {
                if (array_key_exists("$x:$y", $this->points)) {
                    $toRet .= "#";
                } else {
                    $toRet .= ".";
                }
            }
            $toRet .= "\n";
        }
        return $toRet;
    }
}
$field = new Field();
while ($line = readline()) {
    preg_match('/position=< *(-?\d+), *(-?\d+)> velocity=< *(-?\d+), *(-?\d+)>/', $line, $match);
    $pt = new Point(intval($match[1]), intval($match[2]), intval($match[3]), intval($match[4]));
    $field->addPoint($pt);
}

$fieldsByVerticality = [];
foreach(range(1, $field->maxCoord() * 2) as $r) {
    $fieldsByVerticality[$field->verticality()][] = $field;
    $field = $field->tick();
} 
foreach ($fieldsByVerticality[max(array_keys($fieldsByVerticality))] as $f) {
    echo "{$f->ts}\n";
}
