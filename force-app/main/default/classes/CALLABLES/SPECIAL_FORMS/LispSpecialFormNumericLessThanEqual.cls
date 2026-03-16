public class LispSpecialFormNumericLessThanEqual extends LispSpecialForm {

    public LispSpecialFormNumericLessThanEqual() {
        super('(<= NUMBER-OR-MARKER &rest NUMBER-OR-MARKERS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject iter = args;
        Decimal last = ((LispNumber)iter.car().eval(env)).unwrap();
        iter = iter.cdr();

        while (!iter.isNil()) {
            Decimal current = ((LispNumber)iter.car().eval(env)).unwrap();
            if (last > current) {
                return LispNil.INSTANCE;
            }
            last = current;
            iter = iter.cdr();
        }

        return LispT.INSTANCE;
    }
}
