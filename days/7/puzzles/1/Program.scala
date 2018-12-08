import scala.collection.immutable.SortedSet

object Program {
    val Dependency = """^Step (.) must be finished before step (.) can begin\.$""".r

    def getLines(): Stream[String] =
        Option(Console.in.readLine())
            .map(Stream(_) #::: getLines())
            .getOrElse(Stream.empty)

    def getDep(s: String): (String, String) = s match {
        case Dependency(dependency, step) => (step, dependency)
    }

    def getSteps[T](m: Map[T, Set[T]])(implicit o: Ordering[T]): SortedSet[T] = 
        SortedSet() ++ m.keySet ++ m.values.reduce(_ ++ _)

    def getReady[T](steps: SortedSet[T], dependencies: Map[T, Set[T]], completed: Set[T]): Option[T] =
        steps.filter(
            dependencies.getOrElse(_, Set.empty)
                .filter(!completed.contains(_))
                .isEmpty
        ).headOption

    def getOrder[T](steps: SortedSet[T], dependencies: Map[T, Set[T]], completed: Set[T]): Stream[T] =
        getReady(steps, dependencies, completed)
            .map(next => next #:: getOrder(steps - next, dependencies, completed + next))
            .getOrElse(Stream.empty)

    def main(args: Array[String]) {
        val dependencies = getLines()
          .map(getDep)
          .groupBy(_._1)
          .map{
            case (step, deps) => (step, deps.map(_._2).toSet)
          }
        
        val steps = getSteps(dependencies)
        getOrder(steps, dependencies, Set.empty)
            .foreach(print)
        println
    }
}
