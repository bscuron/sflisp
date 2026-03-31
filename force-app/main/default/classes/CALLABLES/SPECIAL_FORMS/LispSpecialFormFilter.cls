public class LispSpecialFormFilter extends LispSpecialForm {

    public LispSpecialFormFilter() {
        super('(filter FUNCTION SEQUENCE)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject fnObj = args.car().eval(env);
        LispObject sequence = args.cdar().eval(env);

        if (!(fnObj instanceof LispCallable)) {
            throw new IllegalArgumentException('filter: first argument must be callable');
        }
        LispCallable fn = (LispCallable) fnObj;

        LispObject result = LispNil.INSTANCE;
        List<LispObject> tempList = new List<LispObject>();

        while (!sequence.isNil()) {
            LispObject elem = sequence.car();
            LispObject test = fn.apply(new LispCons(elem, LispNil.INSTANCE), env);

            if (!test.isNil()) {
                tempList.add(elem);
            }

            sequence = sequence.cdr();
        }

        for (Integer i = tempList.size() - 1; i >= 0; i--) {
            result = new LispCons(tempList.get(i), result);
        }

        return result;
    }
}
