import java.util.Scanner;
import java.util.Set;
import java.util.HashSet;

public class SimilarIDFinder {
    public static void main(String [] args) {
        Scanner input = new Scanner(System.in);
        Set<String> subIds = new HashSet<>();
        
        while(input.hasNext()) {
            String boxId = input.nextLine();
            Set<String> newSubIds = getSubIds(boxId);
            Set<String> intersect = intersect(subIds, newSubIds);
            if (intersect.size() > 0) {
                printSet(intersect);
                break;
            }
            subIds.addAll(newSubIds);

        }
    }

    private static Set<String> getSubIds(String boxId) {
        Set<String> toReturn = new HashSet<>();
        for(int i = 0; i<boxId.length(); i++) {
            toReturn.add(deleteIndex(boxId, i));
        }
        return toReturn;
    }
    
    private static String deleteIndex(String str, int toDelete) {
        return str.substring(0, toDelete) + str.substring(toDelete + 1, str.length());
    }

    private static <E> Set<E> intersect(Set<E> longer, Set<E> shorter) {
        Set<E> toReturn = new HashSet<>();
        for(E e: shorter) {
            if (longer.contains(e)) toReturn.add(e);
        }
        return toReturn;
    }

    private static <E> void printSet(Set<E> set) {
        for (E e: set) {
            System.out.println(e);
        }
    }
}
