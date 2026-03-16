public class LispSpecialFormIf extends LispSpecialForm {

    public LispSpecialFormIf() {
        super('(if COND THEN &rest ELSE)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject condExpr = args.car().eval(env);
        if (!condExpr.isNil()) {
            LispObject thenExpr = args.cdar();
            return thenExpr.eval(env);
        } else {
            LispObject elseExpr = args.cddar();
            return elseExpr.eval(env);
        }
    }
}
