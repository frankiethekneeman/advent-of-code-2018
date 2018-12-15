(def mySerial 6303)
(defstruct candidate :x :y :l :power)

(defn powerLevel [x y serial]
  (let [rackId (+ 10 x)
        bigPower (* rackId (+ serial (* rackId y)))
        hundreds (mod (quot bigPower 100) 10)
       ]
       (- hundreds 5)))

(defn getField [size serial]
    (for [x (range 0 (+ size 1))] 
        (for [y (range 0 (+ size 1))]
            (powerLevel x y serial))))

(def myField (getField 300 6303))

(defn getPower [x y field]
    (nth (nth field x) y))

(defn getStrip [x y l field]
    (flatten (conj
        (for [n (range 0 (- l 1))] 
            [(getPower (+ x l -1) (+ y n) field) (getPower (+ x n) (+ y l -1) field)])
        (getPower (+ x l -1) (+ y l -1) field))))

(defn getStripSum [x y l field]
    (apply + (getStrip x y l field)))

(defn getSquareDiffs [x y maxL field]
    (for [l (range 1 (+ maxL 1))] (getStripSum x y l field)))

(defn getSquares [x y maxL field]
    (reductions + (getSquareDiffs x y maxL field)))

(defn getCandidates [x y maxL field]
    (let [toCand (fn [l, p] (struct candidate x y l p))]
    (map toCand
        (range 1 (+ maxL 1))
        (getSquares x y maxL field))))

(defn maxCand [candArr]
    (apply max-key :power candArr))

(defn getBestCandidate [x y maxL field]
    (maxCand (getCandidates x y maxL field)))

(import '(java.util.concurrent Executors Callable))
(defn findBest [fieldSize boxLimit field]
    (let [pool (Executors/newFixedThreadPool 12)
        vs (range 1 (+ 1 fieldSize))
        tasks (for [x vs y vs :let [maxL (min boxLimit (- fieldSize -1 (max x y)))]]
            (cast Callable (fn [] (getBestCandidate x y maxL field))))
        futures (for [^Callable task tasks] (.submit pool task))
        results (for [f futures] (.get f))
        best (maxCand results)
    ] (do (.shutdown pool) best)))

(defn getAnswer [cand]
    (str (:x cand) "," (:y cand) "," (:l cand)))

(prn (getAnswer (findBest 300 300 myField)))
