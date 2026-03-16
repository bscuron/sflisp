public class LispPrimitiveMul extends LispPrimitive {

    public LispPrimitiveMul() {
        super('(* &rest NUMBER-OR-MARKERS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        Decimal product = 1;
        while (!args.isNil()) {
            product *= ((LispNumber)args.car()).unwrap();
            args = args.cdr();
        }
        return new LispNumber(product);
    }
}
