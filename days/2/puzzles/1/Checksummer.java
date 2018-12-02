import java.util.Scanner;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

public class Checksummer {
    public static void main(String [] args) {
        Scanner input = new Scanner(System.in);
        int exactly2 = 0, exactly3 = 0;
        
        while(input.hasNext()) {
            String boxId = input.nextLine();
            Map<Character, Integer> charCounts = getCharCounts(boxId);
            Map<Integer, Integer> countCounts = countValues(charCounts);
            if (countCounts.containsKey(2)) exactly2++;
            if (countCounts.containsKey(3)) exactly3++;
        }
        System.out.println(exactly2 * exactly3);
    }
    private static <K, V> Map<V, Integer> countValues(Map<K, V> input) {
        return count(input.values());
    }
    private static Map<Character, Integer> getCharCounts(String input) {
        return count(input.chars().mapToObj(c -> (char) c).collect(Collectors.toList()));
    }
    private static <E> Map<E, Integer> count(Iterable<E> entries) {
        Map<E, Integer> toReturn = new HashMap<>();
        for (E e: entries) {
            if (toReturn.containsKey(e)) {
                toReturn.put(e, toReturn.get(e) + 1);
            } else {
                toReturn.put(e, 1);
            }
        }
        return toReturn;
    }
    private static <K, V> void printMap(Map<K, V> map) {
        for (Map.Entry<K, V> e: map.entrySet()) {
            System.out.print(e.getKey());
            System.out.print(" -> ");
            System.out.println(e.getValue());
        }
    }
}
