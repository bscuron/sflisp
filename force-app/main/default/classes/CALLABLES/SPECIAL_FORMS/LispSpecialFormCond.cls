public class LispSpecialFormCond extends LispSpecialForm {
    public LispSpecialFormCond() {
        super('(cond &rest CLAUSES)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        while (!args.isNil()) {
            LispObject clauseObj = args.car();
            if (!(clauseObj instanceof LispCons)) {
                System.assert(false, 'cond clause must be a cons pair: ' + clauseObj);
            }

            LispCons clause = (LispCons)clauseObj;
            LispObject condition = clause.car().eval(env);
            LispObject expressions = clause.cdr();

            if (!condition.isNil()) {
                LispObject result = LispNil.INSTANCE;
                while (!expressions.isNil()) {
                    result = expressions.car().eval(env);
                    expressions = expressions.cdr();
                }
                return result;
            }

            args = args.cdr();
        }

        return LispNil.INSTANCE;
    }
}
