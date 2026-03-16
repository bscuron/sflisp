public class LispClosure extends LispCallable {
    private LispObject body;
    private LispEnvironment closure;

    public LispClosure(LispSignature signature, LispObject body, LispEnvironment environment) {
        super(signature);
        this.body = body;
        this.closure = environment;
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispEnvironment localEnv = new LispEnvironment(closure);

        LispObject iter = args;
        Integer i = 0;

        while (i < signature.requiredParameters.size()) {
            LispSymbol sym = signature.requiredParameters[i];
            localEnv.set(sym, iter.car());
            iter = iter.cdr();
            i++;
        }

        i = 0;
        while (i < signature.optionalParameters.size()) {
            LispSymbol sym = signature.optionalParameters[i];
            if (!iter.isNil()) {
                localEnv.set(sym, iter.car());
                iter = iter.cdr();
            } else {
                localEnv.set(sym, LispNil.INSTANCE);
            }
            i++;
        }

        if (signature.restParameter != null) {
            localEnv.set(signature.restParameter, iter);
        }

        LispObject result = LispNil.INSTANCE;
        LispObject current = body;
        while (!current.isNil()) {
            result = current.car().eval(localEnv);
            current = current.cdr();
        }

        return result;
    }
}
