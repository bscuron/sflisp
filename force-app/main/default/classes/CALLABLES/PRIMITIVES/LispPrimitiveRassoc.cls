public class LispPrimitiveRassoc extends LispPrimitive {

    public LispPrimitiveRassoc() {
        super('(rassoc KEY ALIST)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject key = args.car();
        LispObject alist = args.cdar();

        LispCallable testFn = (LispCallable)env.get(LispSymbol.intern('equal'));
        LispObject iter = alist;
        while (!iter.isNil()) {
            LispObject pairObj = iter.car();
            if (!(pairObj instanceof LispCons)) {
                throw new IllegalArgumentException('rassoc: each element of ALIST must be a cons cell');
            }

            LispCons pair = (LispCons) pairObj;
            LispObject pairCdr = pair.cdr();
            LispObject testArgs = new LispCons(key, new LispCons(pairCdr, LispNil.INSTANCE));
            LispObject result = testFn.apply(testArgs, env);

            if (!result.isNil()) {
                return pair;
            }

            iter = iter.cdr();
        }

        return LispNil.INSTANCE;
    }
}
