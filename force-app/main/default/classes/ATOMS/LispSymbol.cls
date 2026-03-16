public class LispSymbol extends LispObject {
    private String name;
    private static Map<String, LispSymbol> interned = new Map<String, LispSymbol>();

    private LispSymbol(String name) {
        this.name = name;
    }

    public static LispSymbol intern(String name) {
        if (interned.containsKey(name)) {
            return interned.get(name);
        } else {
            LispSymbol sym = new LispSymbol(name);
            interned.put(name, sym);
            return sym;
        }
    }

    public override LispObject eval(LispEnvironment env) {
        return env.get(this);
    }

    public override String toString() {
        return name;
    }
}
