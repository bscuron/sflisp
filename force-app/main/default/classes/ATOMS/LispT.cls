public class LispT extends LispObject {
    public static final LispT INSTANCE = new LispT();

    private LispT() {}

    public override String toString() {
        return 't';
    }
}
