public class LispSpecialFormLetStar extends LispSpecialForm {

    public LispSpecialFormLetStar() {
        super('(let* VARLIST &rest BODY)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject bindings = args.car();
        LispObject body = args.cdr();

        LispEnvironment localEnv = new LispEnvironment(env);

        while (!bindings.isNil()) {
            LispObject bind = bindings.car();
            System.assert(bind instanceof LispCons, 'Each let* binding must be a cons: ' + bind);
            LispCons b = (LispCons)bind;

            LispObject symObj = b.car();
            System.assert(symObj instanceof LispSymbol, 'Let* binding name must be a symbol: ' + symObj);
            LispSymbol sym = (LispSymbol)symObj;

            LispObject valExpr = b.cdar();
            LispObject val = valExpr.eval(localEnv);

            localEnv.set(sym, val);

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
