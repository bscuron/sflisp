public class LispPrimitiveAdd extends LispPrimitive {

    public LispPrimitiveAdd() {
        super('(+ &rest NUMBER-OR-MARKERS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        Decimal sum = 0;
        while (!args.isNil()) {
            sum += ((LispNumber)args.car()).unwrap();
            args = args.cdr();
        }
        return new LispNumber(sum);
    }
}
