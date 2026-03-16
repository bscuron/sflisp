public class LispPrimitiveAppend extends LispPrimitive {

    public LispPrimitiveAppend() {
        super('(append &rest LISTS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject result = LispNil.INSTANCE;

        List<LispObject> lists = new List<LispObject>();
        LispObject iter = args;
        while (!iter.isNil()) {
            lists.add(iter.car());
            iter = iter.cdr();
        }

        for (Integer i = lists.size() - 1; i >= 0; i--) {
            LispObject lst = lists.get(i);
            result = append(lst, result);
        }

        return result;
    }

    private LispObject append(LispObject a, LispObject b) {
        if (a.isNil()) return b;

        if (!(a instanceof LispCons)) {
            throw new IllegalArgumentException('append expects a list, got: ' + a);
        }

        LispCons cons = (LispCons) a;
        return new LispCons(cons.car(), append(cons.cdr(), b));
    }
}
