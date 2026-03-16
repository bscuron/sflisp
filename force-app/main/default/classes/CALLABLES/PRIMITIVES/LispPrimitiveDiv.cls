public class LispPrimitiveDiv extends LispPrimitive {

    public LispPrimitiveDiv() {
        super('(/ NUMBER &rest DIVISORS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        Decimal result = ((LispNumber)args.car()).unwrap();
        args = args.cdr();
        if (args.isNil()) return new LispNumber(1 / result);
        while (!args.isNil()) {
            result /= ((LispNumber)args.car()).unwrap();
            args = args.cdr();
        }
        return new LispNumber(result);
    }
}
