public class LispSpecialFormLet extends LispSpecialForm {

    public LispSpecialFormLet() {
        super('(let VARLIST &rest BODY)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject bindings = args.car();
        LispObject body = args.cdr();
        LispEnvironment localEnv = new LispEnvironment(env);

        while (!bindings.isNil()) {
            LispObject binding = bindings.car();
            LispSymbol sym;
            LispObject valueExpr;

            if (binding instanceof LispSymbol) {
                sym = (LispSymbol)binding;
                valueExpr = LispNil.INSTANCE;
            } else if (binding instanceof LispCons) {
                LispCons cons = (LispCons)binding;
                sym = (LispSymbol)cons.car();
                valueExpr = cons.cdr().isNil() ? LispNil.INSTANCE : cons.cdar();
            } else {
                System.assert(false, 'Invalid let binding: ' + binding);
                return LispNil.INSTANCE;
            }

            localEnv.set(sym, valueExpr.eval(env));
            bindings = bindings.cdr();
        }

        LispObject result = LispNil.INSTANCE;
        while (!body.isNil()) {
            result = body.car().eval(localEnv);
            body = body.cdr();
        }

        return result;
    }
}
