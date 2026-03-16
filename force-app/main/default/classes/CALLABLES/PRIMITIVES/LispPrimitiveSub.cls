public class LispPrimitiveSub extends LispPrimitive {

    public LispPrimitiveSub() {
        super('(- &rest NUMBER-OR-MARKERS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        if (args.isNil()) return new LispNumber(0);
        Decimal result = ((LispNumber)args.car()).unwrap();
        args = args.cdr();
        if (args.isNil()) return new LispNumber(-result);
        while (!args.isNil()) {
            result -= ((LispNumber)args.car()).unwrap();
            args = args.cdr();
        }
        return new LispNumber(result);
    }
}
