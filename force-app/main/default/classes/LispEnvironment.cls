public class LispEnvironment {
    private Map<LispSymbol, LispObject> table;
    private LispEnvironment parent;

    public LispEnvironment(LispEnvironment parent) {
        this.parent = parent;
        this.table = new Map<LispSymbol, LispObject>();
    }

    public void set(LispSymbol sym, LispObject value) {
        table.put(sym, value);
    }

    public LispObject get(LispSymbol sym) {
        if (table.containsKey(sym)) {
            return table.get(sym);
        } else if (parent != null) {
            return parent.get(sym);
        }
        System.assert(false, 'Unbound symbol ' + sym);
        return LispNil.INSTANCE;
    }

}
