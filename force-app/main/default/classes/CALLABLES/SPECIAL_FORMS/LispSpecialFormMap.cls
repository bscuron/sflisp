public class LispSpecialFormMap extends LispSpecialForm {

    public LispSpecialFormMap() {
        super('(map FUNCTION SEQUENCE)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject fnObj = args.car().eval(env);
        LispObject sequence = args.cdar().eval(env);

        if (!(fnObj instanceof LispCallable)) {
            throw new IllegalArgumentException('map: first argument must be callable');
        }
        LispCallable fn = (LispCallable) fnObj;

        LispObject result = LispNil.INSTANCE;
        List<LispObject> tempList = new List<LispObject>();

        while (!sequence.isNil()) {
            LispObject elem = sequence.car();
            LispObject mapped = fn.apply(new LispCons(elem, LispNil.INSTANCE), env);
            tempList.add(mapped);
            sequence = sequence.cdr();
        }

        for (Integer i = tempList.size() - 1; i >= 0; i--) {
            result = new LispCons(tempList.get(i), result);
        }

        return result;
    }
}
