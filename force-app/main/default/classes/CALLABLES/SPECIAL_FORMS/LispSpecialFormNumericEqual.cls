public class LispSpecialFormNumericEqual extends LispSpecialForm {

    public LispSpecialFormNumericEqual() {
        super('(= NUMBER-OR-MARKER &rest NUMBER-OR-MARKERS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject iter = args;
        Decimal last = ((LispNumber)iter.car().eval(env)).unwrap();
        iter = iter.cdr();

        while (iter != LispNil.INSTANCE) {
            Decimal current = ((LispNumber)iter.car().eval(env)).unwrap();
            if (current != last) {
                return LispNil.INSTANCE;
            }
            last = current;
            iter = iter.cdr();
        }

        return LispT.INSTANCE;
    }
}
