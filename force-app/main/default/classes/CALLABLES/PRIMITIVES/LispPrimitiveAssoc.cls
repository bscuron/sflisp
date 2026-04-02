public class LispPrimitiveAssoc extends LispPrimitive {

    public LispPrimitiveAssoc() {
        super('(assoc KEY ALIST &optional TESTFN)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject key = args.car();
        LispObject alist = args.cdar();

        LispObject testFnObj = args.cddr().isNil()
            ? env.get(LispSymbol.intern('equal'))
            : args.cddar().eval(env);
        if (!(testFnObj instanceof LispCallable)) {
            throw new IllegalArgumentException('assoc: TESTFN must be callable');
        }
        LispCallable testFn = (LispCallable)testFnObj;

        LispObject iter = alist;
        while (!iter.isNil()) {
            LispObject pairObj = iter.car();
            if (!(pairObj instanceof LispCons)) {
                throw new IllegalArgumentException('assoc: each element of ALIST must be a cons cell');
            }

            LispCons pair = (LispCons)pairObj;
            LispObject pairKey = pair.car();
            LispObject testArgs = new LispCons(key, new LispCons(pairKey, LispNil.INSTANCE));
            LispObject result = testFn.apply(testArgs, env);

            if (!result.isNil()) {
                return pair;
            }

            iter = iter.cdr();
        }

        return LispNil.INSTANCE;
    }
}
