import scala.collection.immutable.SortedSet
import scala.collection.Iterable

object Program {
    val Dependency = """^Step (.) must be finished before step (.) can begin\.$""".r
    val WORKERS = 5
    val MIN_TIME = 61

    def getLines(): Stream[String] =
        Option(Console.in.readLine())
            .map(Stream(_) #::: getLines())
            .getOrElse(Stream.empty)

    def getDep(s: String): (String, String) = s match {
        case Dependency(dependency, step) => (step, dependency)
    }

    def getSteps[T](m: Map[T, Set[T]])(implicit o: Ordering[T]): SortedSet[T] = 
        SortedSet() ++ m.keySet ++ m.values.reduce(_ ++ _)

    def getReady[T](steps: SortedSet[T], dependencies: Map[T, Set[T]], completed: Set[T]): SortedSet[T] =
        steps.filter(
            dependencies.getOrElse(_, Set.empty)
                .filter(!completed.contains(_))
                .isEmpty
        )

    def getMin[T](m: Map[T, Int]): Seq[T] = 
        m.toSeq.sortBy(_._2).headOption.map(_._2)
            .map(t => m.toSeq.filter(_._2 == t).map(_._1))
            .getOrElse(Seq.empty)

    def timeToComplete[T](in: T): Int = in match {
        case step:String => step.charAt(0) - 'A' + MIN_TIME
    }

    def timeToCompleteEach[T](steps: Iterable[T]): Map[T, Int] = 
        Map(steps.toSeq.map(s => (s, timeToComplete(s))): _*)

    def timeToComplete[T](
        steps: SortedSet[T],
        dependencies: Map[T, Set[T]],
        completed: Set[T],
        working: Map[T, Int]
    ): Int = {
        if(steps.isEmpty && working.isEmpty) {
            0
        } else {
            val nextComplete = getMin(working)
            val nextTime = nextComplete.headOption.map(working).getOrElse(0)
            val nextCompleted = completed ++ nextComplete
            val nextReady = getReady(steps, dependencies, nextCompleted)
                .take(WORKERS - working.size + nextComplete.size)
            val nextWorking = (working -- nextComplete).map{
                case (step, time) => (step, time - nextTime)
            } ++ timeToCompleteEach(nextReady)

            nextTime + timeToComplete(
                steps -- nextReady,
                dependencies,
                nextCompleted,
                nextWorking
            )
        }
    }

    def main(args: Array[String]) {
        val dependencies = getLines()
          .map(getDep)
          .groupBy(_._1)
          .map{
            case (step, deps) => (step, deps.map(_._2).toSet)
          }
        
        val steps = getSteps(dependencies)
        val time = timeToComplete(
            steps,
            dependencies,
            Set.empty,
            Map.empty[String, Int]
        )
        println(time)
    }
}
